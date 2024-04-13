import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:tv_streaming/constants.dart';
import 'package:http/http.dart' as http;
import 'package:tv_streaming/pages/home_page.dart';
import 'package:tv_streaming/pages/ios_page.dart';
import 'package:tv_streaming/pages/segunda_page.dart';

class IntermedioPage extends StatefulWidget {
  static final String routeName = 'intermedio';
  IntermedioPage({Key key}) : super(key: key);

  @override
  State<IntermedioPage> createState() => _IntermedioPageState();
}

class _IntermedioPageState extends State<IntermedioPage> {
  Future<bool> validarurl() async {
    String url;
    var response;
    url = "http://tv1.yottalan.com";
    print("validar url");
    try {
      response = await http
          .post(
        Uri.parse('$url/auth/login/'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          "email": "emanuel@emanuel.com",
          "password": "emanuel",
        }),
      )
          .timeout(
        const Duration(seconds: 3),
        onTimeout: () {
          // Time has run out, do what you wanted to do.
          return http.Response(
              'Error', 408); // Request Timeout response status code
        },
      );

      print("error codeeeeeeeeeeeeeeeeeeeeeeeeeeee");
      print(response.toString());
      print("mensajeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee");
      if (response.statusCode == 400) {
        Navigator.pushReplacementNamed(context, HomePage.routeName);
        print("ifffffffffffffffftv1");
        return true;
      } else {
        print("ifffffffffffffffftv2");

        Navigator.pushReplacementNamed(context, SegundaPage.routeName);
        //Navigator.pushReplacementNamed(context, IosPage.routeName);
        return false;
      }
    } on SocketException catch (_) {
      print('errrrrrrrrrrrrrrrrrrrrrrrrrrr tv11111111111111111111111111111');
      response.close();
      //Navigator.pushReplacementNamed(context, ConectivityPage.routeName);
      return false;
    }
  }

  @override
  void initState() {
    super.initState();
    validarurl();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            child: Image.asset(
              'assets/images/conectivity.jpg',
              width: 400.0,
              height: 200.0,
              scale: 1.0,
            ),
            alignment: Alignment.center,
          ),
          Text(
            "Hola",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          SizedBox(
            height: 10,
          ),
          Text("Validando disponibilidad del contenido "),
          SizedBox(
            height: 10,
          ),
          Text("Yottalan"),
          SizedBox(
            height: 20,
          ),
          SizedBox(
            height: 20,
          ),
//          ElevatedButton(child: Text("Comprar"), onPressed: () {})
        ],
      )),
    );
  }
}
