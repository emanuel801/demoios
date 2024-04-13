
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferenciasUsuario{
  static final PreferenciasUsuario _instancia = new PreferenciasUsuario._internal();

  factory PreferenciasUsuario() {
    return _instancia;
  }

  PreferenciasUsuario._internal();

  SharedPreferences _prefs;

  initPrefs() async {
    WidgetsFlutterBinding.ensureInitialized();
    this._prefs = await SharedPreferences.getInstance();
  }


  get email {
    return _prefs.getString('email') ?? '';
  }
  set email(String value) {
    _prefs.setString('email', value);
  }

  get firstName {
    return _prefs.getString('firstName') ?? '';
  }
  set firstName(String value) {
    _prefs.setString('email', firstName);
  }

  get lastName {
    return _prefs.getString('lastName') ?? '';
  }
  set lastName(String value) {
    _prefs.setString('email', lastName);
  }

  get cellphone {
    return _prefs.getString('cellphone') ?? '';
  }
  set cellphone(String value) {
    _prefs.setString('email', cellphone);
  }

  get documentNumber {
    return _prefs.getString('documentNumber') ?? '';
  }
  set documentNumber(String value) {
    _prefs.setString('email', documentNumber);
  }

  get documentType {
    return _prefs.getString('documentType') ?? '';
  }
  set documentType(String value) {
    _prefs.setString('email', documentType);
  }

  get avatar {
    return _prefs.getString('avatar') ?? '';
  }
  set avatar(String value) {
    _prefs.setString('email', avatar);
  }  
}