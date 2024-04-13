import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tv_streaming/constants.dart';
import 'package:tv_streaming/pages/splash_page.dart';

import 'login_page.dart';

class ConectivityPage extends StatefulWidget {
  static final String routeName = 'conectivity';
  ConectivityPage({Key key}) : super(key: key);

  @override
  _ConectivityPageState createState() => _ConectivityPageState();
}

class _ConectivityPageState extends State<ConectivityPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
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
            "Conéctate a Internet",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          SizedBox(
            height: 10,
          ),
          Text("No estás conectado."),
          Text("Comprueba la conexión."),
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
          ElevatedButton(
              child: Text("Reintentar"),
              onPressed: () {
                Navigator.pushReplacementNamed(context, SplashPage.routeName);
              })
        ],
      )),
    );
  }
}
