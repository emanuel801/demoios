import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tv_streaming/constants.dart';
import 'package:tv_streaming/pages/new_count/new_count_3.dart';
import 'package:tv_streaming/providers/access_provider.dart';
import 'package:tv_streaming/providers/user_provider.dart';
import 'package:tv_streaming/widgets/app_button.dart';
import 'package:tv_streaming/widgets/outlined_input.dart';

// import 'new_count_3.dart';

class NewCount2Page extends StatefulWidget {
  static final routeName = 'newCount2';

  final String email;

  const NewCount2Page({this.email});

  @override
  _NewCount2PageState createState() => _NewCount2PageState();
}

class _NewCount2PageState extends State<NewCount2Page> {
  // String correo;
  String emailError;

  String password = "";
  String passwordError;
  bool estado = false;

  @override
  void initState() {
    super.initState();
    estado = false;
  }

  void createAcount(String correo) async {
    if (correo.isEmpty) {
      setState(() {
        emailError = "Ingrese su e-mail";
      });
      return;
    }
    if (password.isEmpty) {
      setState(() {
        passwordError = "Ingrese su contraseña";
      });
      return;
    } else if (password.length < 6) {
      setState(() {
        passwordError = "Minimo 6 digitos";
      });
      return;
    } else {
      setState(() {
        passwordError = null;
      });
    }
    setState(() {
      estado = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    String email = this.widget.email;

    return Scaffold(
      backgroundColor: epgColor,
      floatingActionButton: FloatingActionButton(
        child: Container(
          width: 60,
          height: 60,
          child: Icon(
            Icons.arrow_back,
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Image.asset('assets/images/logoyotta.png',
                      width: 80,
                      color: primaryTextColor,
                      alignment: Alignment.topRight),
                ),
              ],
            ),
            Expanded(
                child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Container(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('PASO 2 DE 3',
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                            color: primaryTextColor)),
                    SizedBox(height: 5),
                    Text(
                      'Crea una contraseña para que comiences tu membresía.',
                      style: TextStyle(fontSize: 24, color: primaryTextColor),
                      // textAlign: TextAlign.center
                    ),
                    SizedBox(height: 30),
                    OutlinedInput(
                      valor: email,
                      soloLeer: true,
                      onChanged: (value) {
                        email = email;
                        setState(() {
                          // emailError = null;
                        });
                      },
                      // errorText: emailError,
                      labelText: 'Correo electrónico',
                      keyboardType: TextInputType.emailAddress,
                    ),
                    SizedBox(height: 16),
                    OutlinedInput(
                      pageView: 'newCount',
                      labelText: 'Contraseña',
                      onChanged: (value) {
                        password = value;
                        setState(() {
                          passwordError = null;
                        });
                      },
                      errorText: passwordError,
                      obscureText: false,
                    ),
                    SizedBox(height: 16),
                    AppButton(
                      label: "SIGUIENTE",
                      width: double.infinity,
                      onPressed: () {
                        createAcount(email);
                      },
                    ),
                    SizedBox(height: 20),
                    estado
                        ? CircularProgressIndicator(
                            backgroundColor: primaryColor,
                            valueColor: AlwaysStoppedAnimation(secondaryColor),
                            strokeWidth: 7,
                          )
                        : Container()
                  ],
                ),
              ),
            ))
          ],
        ),
      ),
    );
  }
}
