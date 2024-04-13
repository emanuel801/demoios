import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tv_streaming/constants.dart';
import 'package:tv_streaming/pages/home_page.dart';
import 'package:tv_streaming/pages/nuevo_page.dart';
import 'package:tv_streaming/pages/renovar_page.dart';
import 'package:tv_streaming/pages/splash_page.dart';
import 'package:tv_streaming/providers/access_provider.dart';
import 'package:http/http.dart' as http;

class SegundaPage extends StatefulWidget {
  static final String routeName = 'segunda';

  SegundaPage({Key key}) : super(key: key);

  @override
  State<SegundaPage> createState() => _SegundaPageState();
}

class _SegundaPageState extends State<SegundaPage> {
  Future<bool> validar() async {
    final accessProvider = Provider.of<AccessProvider>(context, listen: false);
    var token = accessProvider.token;
    try {
      final response = await http.get(
        Uri.parse('https://tv2.yottalan.com/user/me/'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 200) {
        print("2000000000000000000000000");
        print(response.body);
        final body = json.decode(utf8.decode(response.bodyBytes));
        if ((body['data']['activate']) == null) {
          print("nuevo");
          Navigator.pushReplacementNamed(context, NuevoPage.routeName);
        }
        String hoy = DateFormat('yyyy-MM-dd').format(DateTime.now());
        String fin = body['data']['activate'].toString();

        final hoyy = hoy.split('-');
        final finn = fin.split('-');
        if ((int.parse(finn[0]) >= int.parse(hoyy[0])) &&
            (int.parse(finn[1]) >= int.parse(hoyy[1])) &&
            int.parse(finn[2]) >= int.parse(hoyy[2])) {
          Navigator.pushReplacementNamed(context, HomePage.routeName);
          print("homeeeeeeee");
        } else {
          print("renovarrrrrrr");
          Navigator.pushReplacementNamed(context, RenovarPage.routeName);
        }

        return true;
      } else {
        return false;
      }
    } catch (error) {
      return false;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    validar();
  }

  @override
  Widget build(BuildContext context) {
    final accessProvider = Provider.of<AccessProvider>(context, listen: false);
    //accessProvider.urlcore = "https://tv2.yottalan.com";
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
            height: 20,
          ),
          //ElevatedButton(child: Text("Comprar"), onPressed: () {})
        ],
      )),
    );
  }
}
