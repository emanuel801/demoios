import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tv_streaming/constants.dart';
import 'package:tv_streaming/pages/home_page.dart';
import 'package:tv_streaming/pages/intermedio_page.dart';
import 'package:tv_streaming/pages/new_count/new_count_1.dart';
import 'package:tv_streaming/pages/restore_psw/verify_email.dart';
import 'package:tv_streaming/pages/segunda_page.dart';
import 'package:tv_streaming/providers/access_provider.dart';
import 'package:tv_streaming/widgets/app_button.dart';
import 'package:tv_streaming/widgets/loader_modal.dart';
import 'package:tv_streaming/widgets/outlined_input.dart';
import 'package:http/http.dart' as http;
import 'dart:io';

import 'conectivity_page.dart';

class LoginPage extends StatefulWidget {
  static final String routeName = 'login';
  const LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String email = "";
  String password = "";
  String emailError;
  String passwordError;
  Future<bool> rpta;
  int valor = 0;
  bool _passwordVisible = false;

  Future<bool> validar() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('connected');

        valor = 1;
        return true;
      }
    } on SocketException catch (_) {
      print('not connected');
      Navigator.pushReplacementNamed(context, ConectivityPage.routeName);
      return false;
    }
  }

  void handleSignIn() async {
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
    if (password.isEmpty) {
      setState(() {
        passwordError = "Ingrese su contraseña";
      });
      return;
    } else {
      setState(() {
        passwordError = null;
      });
    }

    final accessProvider = Provider.of<AccessProvider>(context, listen: false);
    final response =
        await accessProvider.login(email, password, accessProvider.urlcore);

    print("url 1");
    print(accessProvider.urlcore);

    if (response.message != "" &&
        response.message != "Error interno" &&
        response.access == null) {
      setState(() {
        emailError = response.message;
      });
    }
    if (response.access != null) {
      Navigator.pushReplacementNamed(context, IntermedioPage.routeName);
    }

    if (response.message == "Error interno") {
      accessProvider.urlcore = "https://tv2.yottalan.com";
      print("url 2");

      print(accessProvider.urlcore);
      final response2 =
          await accessProvider.login(email, password, accessProvider.urlcore);

      if (response2.message != "" &&
          response2.message != "Error interno" &&
          response2.access == null) {
        setState(() {
          emailError = response2.message;
        });
      }

      if (response2.message != "" && response2.access == null) {
      } else {
        if (response2.access != null) {
          Navigator.pushReplacementNamed(context, SegundaPage.routeName);
        }
      }
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
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;

    return Scaffold(
        body: SafeArea(
      child: Stack(
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
          SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(
                  height: 120,
                ),
                Center(
                  child: Image.asset(
                    'assets/images/logoyotta.png',
                    width: 140,
                    color: Colors.white,
                  ),
                ),
                Container(
                  height: 60,
                  margin: EdgeInsets.only(left: 30, right: 30),
                  child: OutlinedInput(
                    onChanged: (value) {
                      email = value;
                      setState(() {
                        emailError = null;
                      });
                    },
                    //errorText: emailError,
                    labelText: 'Correo electrónico',
                    keyboardType: TextInputType.emailAddress,
                  ),
                ),
                SizedBox(height: 20),
                Container(
                    height: 60,
                    margin: EdgeInsets.only(left: 30, right: 30),
                    child: TextFormField(
                      cursorColor: Colors.white,
                      onChanged: (value) {
                        password = value;
                        setState(() {
                          passwordError = null;
                        });
                      },
                      obscureText: !_passwordVisible,
                      style: TextStyle(fontSize: 18, color: Colors.white),
                      decoration: InputDecoration(
                        labelText: 'Contraseña',
                        labelStyle: TextStyle(color: Colors.white),
                        fillColor: Colors.white,
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.white, width: 2.0),
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: Color(0xff96979b), width: 2.0),
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            // Based on passwordVisible state choose the icon
                            _passwordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            // Update the state i.e. toogle the state of passwordVisible variable
                            setState(() {
                              _passwordVisible = !_passwordVisible;
                            });
                          },
                        ),
                      ),
                    )),
                SizedBox(height: 16),
                Text(emailError == null ? "" : emailError,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white)),
                Text(passwordError == null ? "" : passwordError,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white)),
                SizedBox(height: 16),
                Container(
                  height: 50,
                  margin: EdgeInsets.only(left: 40, right: 40),
                  child: AppButton(
                    label: "INICIAR SESIÓN",
                    width: double.infinity,
                    onPressed: handleSignIn,
                  ),
                ),
                SizedBox(height: 16),
                Center(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          CupertinoPageRoute(
                              builder: (BuildContext context) =>
                                  NewCount1Page()));
                    },
                    child: Text(
                      'Crear nueva cuenta',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          decoration: TextDecoration.underline,
                          decorationThickness: 0.5),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                Center(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          CupertinoPageRoute(
                              builder: (BuildContext context) =>
                                  VerifyEmailPage()));
                    },
                    child: Text(
                      'Recuperar contraseña',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          decoration: TextDecoration.underline,
                          decorationThickness: 0.5),
                    ),
                  ),
                ),
                SizedBox(height: 16),
              ],
            ),
          ),
          Consumer<AccessProvider>(
            builder: (_, provider, __) {
              return provider.isLoggingIn ? LoaderModal() : Container();
            },
          )
        ],
      ),
    ));
  }
}
