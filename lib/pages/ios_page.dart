import 'package:flutter/material.dart';

import '../constants.dart';

class IosPage extends StatefulWidget {
  static final String routeName = 'iosvista';
  const IosPage({Key key}) : super(key: key);

  @override
  State<IosPage> createState() => _IosPageState();
}

class _IosPageState extends State<IosPage> {
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
            "YottaTV",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          SizedBox(
            height: 10,
          ),
          Text("El contenido no está disponible en su red"),
          SizedBox(
            height: 20,
          ),
          CircularProgressIndicator(
            backgroundColor: epgColor,
            valueColor: AlwaysStoppedAnimation(Colors.blue),
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
