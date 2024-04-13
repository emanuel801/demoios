import 'package:flutter/widgets.dart';
import 'package:localstorage/localstorage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tv_streaming/api/access.dart';
import 'package:tv_streaming/models/user.dart';

class AccessProvider extends ChangeNotifier {
  AccessState _state;
  final String _stateKey = 'state';
  final _storage = LocalStorage('access-state.json');

  String _urlcore = "http://tv1.yottalan.com";

  get urlcore {
    return _urlcore;
  }

  set urlcore(String nombre) {
    this._urlcore = nombre;

    notifyListeners();
  }

  void init() async {
    await _storage.ready;
    final _data = _storage.getItem(_stateKey);
    try {
      if (_data != null) {
        _state = AccessState.fromJson(_data);
      }
    } catch (e) {}

    if (_data == null) {
      _state = AccessState(currentUser: null, isLoggingIn: false);
    }
    notifyListeners();
  }

  Future<void> logout(String token) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
    await logoutCall(token);

    _state.currentUser = null;
    _state.token = null;
    if (_state != null) _saveState();
    notifyListeners();
    return;
  }
  Future<void> remove(String token) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
    await logoutCall(token);

    _state.currentUser = null;
    _state.token = null;
    if (_state != null) _saveState();
    notifyListeners();
    return;
  }

  Future<LoginResponse> login(email, password, url) async {
    _state.isLoggingIn = true;
    notifyListeners();
    LoginResponse response = await loginCall(email, password, url);
    print("loginnnnnn");
    print(response);
    if (response.data != null) {
      final prefs = await SharedPreferences.getInstance();
      prefs.setString('email', response.data.email);
      prefs.setString('firstName', response.data.firstName);
      prefs.setString('lastName', response.data.lastName);
      if (response.data.cellphone == null) {
        prefs.setString('cellphone', "");
      } else {
        prefs.setString('cellphone', response.data.cellphone);
      }
      if (response.data.documentNumber == null) {
        prefs.setString('documentNumber', "");
      } else {
        prefs.setString('documentNumber', response.data.documentNumber);
      }
      prefs.setString('documentType', response.data.documentType);
      if (response.data.avatar == null) {
        prefs.setString('avatar', "");
      } else {
        prefs.setString('avatar', response.data.avatar);
      }
    }

    _state.currentUser = response.data;
    _state.isLoggingIn = false;
    _state.token = response.access;
    notifyListeners();
    _saveState();

    return response;
  }

  bool get isLoggingIn => _state?.isLoggingIn;
  User get currentUser => _state?.currentUser;
  String get token => _state?.token;

  void _saveState() async => await _storage.setItem(_stateKey, _state.toJson());
}

class AccessState {
  bool isLoggingIn;
  User currentUser;
  String token;

  AccessState({this.isLoggingIn, this.currentUser, this.token});

  factory AccessState.fromJson(Map<String, dynamic> json) => AccessState(
        currentUser: json['currentUser'] != null
            ? User.fromJson(json['currentUser'])
            : null,
        token: json["token"],
        isLoggingIn: false,
      );

  Map<String, dynamic> toJson() => {
        "currentUser": currentUser,
        "token": token,
      };
}
