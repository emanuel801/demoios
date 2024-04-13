import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tv_streaming/constants.dart';
import 'package:tv_streaming/pages/home_page.dart';
import 'package:tv_streaming/pages/intermedio_page.dart';
import 'package:tv_streaming/pages/login_page.dart';
import 'package:tv_streaming/providers/access_provider.dart';
import 'package:http/http.dart' as http;

class SplashPage extends StatefulWidget {
  static final String routeName = 'splash';
  const SplashPage({Key key}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with AfterLayoutMixin<SplashPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/images/fondo.jpeg'),
                  fit: BoxFit.fitWidth,
                  alignment: Alignment.topCenter)),
        ),
        Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
            Colors.transparent,
            Color(0xff2e4053),
            Color(0xff17202a),
            Color(0xff17202a),
          ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
        ),
        Center(
          child: Image.asset(
            'assets/images/logoyotta.png',
            width: 300,
            color: Colors.white,
          ),
        ),
      ],
    ));
  }

  @override
  void afterFirstLayout(BuildContext context) async {
    Future.delayed(Duration(seconds: 2)).then((_) {
      final accessProvider =
          Provider.of<AccessProvider>(context, listen: false);

      if (accessProvider.token != null) {
        Navigator.pushReplacementNamed(context, IntermedioPage.routeName);
      } else {
        Navigator.pushReplacementNamed(context, LoginPage.routeName);
      }
    });
  }
}
