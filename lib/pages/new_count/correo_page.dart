import 'package:flutter/material.dart';
import 'package:tv_streaming/pages/login_page.dart';
import 'package:tv_streaming/widgets/app_button.dart';

class CorreoPage extends StatefulWidget {
  final String emaill;
  final String nombree;

  const CorreoPage({this.emaill, this.nombree});
  @override
  _CorreoPageState createState() => _CorreoPageState();
}

class _CorreoPageState extends State<CorreoPage> {
  @override
  Widget build(BuildContext context) {
    String email = this.widget.emaill;
    String nombre = this.widget.nombree;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            child: Image.asset(
              'assets/images/40.jpg',
              width: 400.0,
              height: 200.0,
              scale: 1.0,
            ),
            alignment: Alignment.center,
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            "Bienvenido",
            style: TextStyle(fontSize: 24),
          ),
          SizedBox(
            height: 10,
          ),
          Text(nombre == null ? "-" : nombre,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
          SizedBox(
            height: 10,
          ),
          Container(
            alignment: Alignment.center,
            margin: EdgeInsets.only(left: 40, right: 40),
            child: Text(
                "Para activar su cuenta haga click en el enlace enviado a su correo"),
          ),
          SizedBox(
            height: 10,
          ),
          Text(email == null ? "-" : email,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          SizedBox(
            height: 20,
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            height: 50,
            margin: EdgeInsets.only(left: 40, right: 40),
            child: AppButton(
              label: "INICIAR SESIÓN",
              width: double.infinity,
              onPressed: () {
                Navigator.pushReplacementNamed(context, LoginPage.routeName);
              },
            ),
          ),
        ],
      )),
    );
  }
}
