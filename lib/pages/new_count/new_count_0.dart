import 'package:flutter/material.dart';
import 'package:tv_streaming/constants.dart';
import 'package:tv_streaming/widgets/app_button.dart';
import 'package:tv_streaming/widgets/outlined_input.dart';

class NewcountPage extends StatefulWidget {
  static final routeName = 'newCount0';

  @override
  _NewcountPageState createState() => _NewcountPageState();
}

class _NewcountPageState extends State<NewcountPage> {
  String email = "";
  String emailError;

  void verificar() {
    if (email.isEmpty) {
      setState(() {
        emailError = "Ingrese su e-mail";
      });
      return;
    } else if (!RegExp(
      "^[a-zA-Z0-9.!#\$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*\$",
    ).hasMatch(email)) {
      setState(() {
        emailError = "Correo electrónico inválido";
      });
      return;
    } else {
      setState(() {
        emailError = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Scaffold(
      backgroundColor: epgColor,
      floatingActionButton: FloatingActionButton(
        child: Container(
          width: 60,
          height: 60,
          child: Icon(
            Icons.arrow_back,
            // size: 40,
          ),
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [primaryColor, secondaryColor],
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
              )),
        ),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      body: SafeArea(
          child: Stack(
        children: [
          Positioned(
              right: 10,
              top: 10,
              child: Image.asset(
                'assets/images/logo.png',
                width: 80,
                color: Colors.white,
              )),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 20),
                Text('PASO 1 DE 3',
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        color: primaryTextColor)),
                SizedBox(height: 5),
                Text('Disfruta donde quieras',
                    style: TextStyle(fontSize: 28, color: primaryTextColor)),
                SizedBox(height: 15),
                OutlinedInput(
                  onChanged: (value) {
                    email = value;
                    setState(() {
                      emailError = null;
                    });
                  },
                  pageView: 'newCount',
                  errorText: emailError,
                  labelText: 'Correo electrónico',
                  keyboardType: TextInputType.emailAddress,
                ),
                SizedBox(height: 10),
                AppButton(
                  label: "SIGUIENTE",
                  width: double.infinity,
                  onPressed: verificar,
                ),
                SizedBox(height: 40),
              ],
            ),
          ),
        ],
      )),
    );
  }
}
