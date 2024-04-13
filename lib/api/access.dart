import 'dart:async';
import 'dart:io';

import 'package:flutter/src/widgets/framework.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:tv_streaming/models/user.dart';
import 'dart:convert';
import 'package:tv_streaming/constants.dart';
import 'package:tv_streaming/providers/access_provider.dart';
import 'package:tv_streaming/providers/user_provider.dart';

Future<LoginResponse> loginCall(
    String email, String password, String url) async {
  print("url que le pasa");
  print(url);

  try {
    final response = await http
        .post(
          Uri.parse('$url/auth/login/'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, String>{
            "email": "$email",
            "password": "$password",
          }),
        )
        .timeout(const Duration(seconds: 5))
        .catchError((Object error) {
      print(error.toString());
    });

    final body = json.decode(
        utf8.decode((response?.bodyBytes) == null ? "" : response?.bodyBytes));
    print("error code");
    print(response.statusCode);
    print("mensaje");
    print(body['message'][0]);
    if (response.statusCode == 400) {
      return LoginResponse(message: body['message'][0]);
    }
    if (response.statusCode == 200) {
      return LoginResponse.fromJson(body);
    }
  } on SocketException {
    throw ('Sin internet  o falla de servidor ');
  } on TimeoutException catch (_) {
    throw ('Tiempo de espera alcanzado');
  } catch (error) {
    return LoginResponse(message: "Error interno");
  }
}

Future<int> logoutCall(String token) async {
  try {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/logout/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      return 1;
    } else {
      return 0;
    }
  } catch (error) {
    return 0;
  }
}

class LoginResponse {
  String access;
  String message;
  User data;

  LoginResponse({
    this.access,
    this.message,
    this.data,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
        access: json["access"],
        message: json["message"],
        data: User.fromJson(json["data"]),
      );

  String toString() => '$access, $message';
}
