import 'package:flutter/material.dart';

import '../constants.dart';

class CarritoPage extends StatefulWidget {
  static final String routeName = 'carrito';

  const CarritoPage({Key key}) : super(key: key);

  @override
  State<CarritoPage> createState() => _CarritoPageState();
}

class _CarritoPageState extends State<CarritoPage> {
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
              'assets/images/logoyotta.png',
              width: 400.0,
              height: 200.0,
              scale: 1.0,
            ),
            alignment: Alignment.center,
          ),
          Container(
            width: 300,
            child: Text(
              "Pronto podrás adquirir tu membresía YottaTV ",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            width: 300,
            child: Text(
              "Para mayor información escríbanos ",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            "tv@yottalan.com",
            style: TextStyle(fontWeight: FontWeight.normal, fontSize: 17),
          ),
          SizedBox(
            height: 10,
          ),
          SizedBox(
            height: 20,
          ),
          CircularProgressIndicator(
            backgroundColor: epgColor,
            valueColor: AlwaysStoppedAnimation(Colors.cyan[800]),
            strokeWidth: 7,
          ),
          SizedBox(
            height: 20,
          ),
        ],
      )),
    );
  }
}
