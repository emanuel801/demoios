import 'dart:async';
import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:localstorage/localstorage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tv_streaming/constants.dart';
import 'package:http/http.dart' as http;
import 'package:tv_streaming/models/user.dart';

class UserProvider extends ChangeNotifier {
  Future<int> verifyEmail(String email) async {
    try {
      final url = '$baseUrl/register/verify?email=$email';
      var resp = await http
          .get(Uri.parse(url), headers: {'Accept': 'application/json'});
      if (resp.statusCode != 200) return resp.statusCode;
      final Map<String, dynamic> decodedData =
          json.decode(utf8.decode(resp?.bodyBytes));
      if (decodedData == null) return 0;
      if (decodedData['status'] == true) return 0;
      return 1;
    } on Exception {
      return 0;
    }
  }

  Future<String> createAcount(String email, String password, String nombre,
      String apellido, String celular, String fecha) async {
    try {
      final url = '$baseUrl/register/';
      var resp = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: jsonEncode(<String, String>{
          'email': '$email',
          'password': '$password',
          'first_name': '$nombre',
          'last_name': '$apellido',
          'birthday': '$fecha',
          'cellphone': '$celular'
        }),
      );
      Map<String, dynamic> user;
      user = jsonDecode(utf8.decode(resp?.bodyBytes));
      print("posttttt");
      print(user["email"]);
      print(resp.body);
      print(resp.statusCode);
      if (resp.statusCode != 200) return user["email"].toString();
      final Map<String, dynamic> decodedData =
          json.decode(utf8.decode(resp?.bodyBytes));
      if (decodedData.length > 0) {
        return "1";
      }
      return "0";
    } on Exception {
      return "0";
    }
  }

  Future<int> verifyEmailChange(String email) async {
    try {
      final url = '$baseUrl/forgot/password/';
      var resp = await http.post(Uri.parse(url),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, String>{
            'email': '$email',
          }));
      if (resp.statusCode != 200) return resp.statusCode;
      final Map<String, dynamic> decodedData =
          json.decode(utf8.decode(resp?.bodyBytes));
      if (decodedData['status']) return 1;
      if (!decodedData['status']) return 0;
      return 0;
    } on Exception {
      return 0;
    }
  }

  Future<String> sendNewPsw(String password, String token) async {
    try {
      final url = '$baseUrl/password/change/';
      var resp = await http.put(Uri.parse(url),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode(<String, String>{
            'new_password': '$password',
          }));
      if (resp.statusCode != 200) {
        final Map<String, dynamic> decodedData =
            json.decode(utf8.decode(resp?.bodyBytes));
        print("decodecado");
        print(decodedData.values.first);
        return decodedData.values.first.toString();
      } else {
        return "ok";
      }
    } on Exception {
      return '0';
    }
  }

  final String _stateKey = 'state';
  final _storage = LocalStorage('access-state.json');

  void init() async {
    await _storage.ready;
    final _data = _storage.getItem(_stateKey);
    try {
      if (_data != null) {}
    } catch (e) {}

    if (_data == null) {}
    notifyListeners();
  }

  Future<int> updateAcount(
      String email,
      String nombres,
      String apellidos,
      String celular,
      String documento,
      String tipoDocumento,
      String token,
      dynamic avatar) async {
    if (tipoDocumento == '0') {
      tipoDocumento = 'DNI';
    } else if (tipoDocumento == '1') {
      tipoDocumento = 'CE';
    } else if (tipoDocumento == '2') {
      tipoDocumento = 'PASSPORT';
    }
    final url = '$baseUrl/user/profile/';
    var resp;

    String subAvatar;
    if (avatar != null) {
      subAvatar = avatar.substring(0, 4);
    }
    if (subAvatar == 'http' || avatar == null) {
      resp = await http.put(Uri.parse(url),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode(<String, String>{
            'email':'$email',
            'first_name': '$nombres',
            'last_name': '$apellidos',
            'cellphone': '$celular',
            'document_number': '$documento',
            'document_type': '$tipoDocumento',
          }));
    } else {
      resp = await http.put(Uri.parse(url),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode(<String, String>{
            'email':'$email',
            'first_name': '$nombres',
            'last_name': '$apellidos',
            'cellphone': '$celular',
            'document_number': '$documento',
            'document_type': '$tipoDocumento',
            'avatar': '$avatar'
          }));
    }
    try {
      Map<String, dynamic> user;
      user = jsonDecode(utf8.decode(resp?.bodyBytes));
      print("updateeeeeeeeeeee");
      print(resp.body);
      print(resp.statusCode);

      if (resp.statusCode != 200) return resp.statusCode;
      final Map<String, dynamic> decodedData =
          json.decode(utf8.decode(resp?.bodyBytes));
      if (decodedData == null) return 0;
      if (decodedData['error'] != null) return 0;
      final body = json.decode(utf8.decode(resp?.bodyBytes));
      UpdateResponse updateResponse = UpdateResponse.fromJson(body);

      final prefs = await SharedPreferences.getInstance();
      prefs.setString('email', updateResponse.data.email);
      prefs.setString('firstName', updateResponse.data.firstName);
      prefs.setString('lastName', updateResponse.data.lastName);
      if (updateResponse.data.cellphone == null) {
        prefs.setString('cellphone', updateResponse.data.cellphone);
      } else {
        prefs.setString('cellphone', updateResponse.data.cellphone);
      }
      prefs.setString('documentNumber', updateResponse.data.documentNumber);
      prefs.setString('documentType', updateResponse.data.documentType);
      if (updateResponse.data.avatar == null) {
        prefs.setString('avatar', "");
      } else {
        prefs.setString('avatar', updateResponse.data.avatar);
      }

      return 1;
    } on Exception {
      return 0;
    }
  }

Future<int> removeAccount(String email,String name,String apellido,
      String token) async {
    final url = '$baseUrl/user/profile/';
    var resp;

      resp = await http.put(Uri.parse(url),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode(<String, String>{
            'email': 'eliminado-'+'$email',
            'first_name': 'eliminado-'+'$name',
            'last_name': '$apellido',
            
          }));
     
    try {
      Map<String, dynamic> user;
      user = jsonDecode(utf8.decode(resp?.bodyBytes));
      print("updateeeeeeeeeeee");
      print(resp.body);
      print(resp.statusCode);
      
      final prefs = await SharedPreferences.getInstance();
      prefs.clear();
      
      if (resp.statusCode != 200) return resp.statusCode;
      final Map<String, dynamic> decodedData =
          json.decode(utf8.decode(resp?.bodyBytes));
      if (decodedData == null) return 0;
      if (decodedData['error'] != null) return 0;
      final body = json.decode(utf8.decode(resp?.bodyBytes));
      UpdateResponse updateResponse = UpdateResponse.fromJson(body);
      return 1;
    } on Exception {
      return 0;
    }
  }

}



class UpdateResponse {
  String message;
  User data;

  UpdateResponse({
    this.message,
    this.data,
  });

  factory UpdateResponse.fromJson(Map<String, dynamic> json) => UpdateResponse(
        message: json["message"],
        data: User.fromJson(json["data"]),
      );
  String toString() => '$message';
}
