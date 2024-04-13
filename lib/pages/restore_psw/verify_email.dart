import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tv_streaming/constants.dart';
import 'package:tv_streaming/providers/user_provider.dart';
import 'package:tv_streaming/widgets/app_button.dart';
import 'package:tv_streaming/widgets/outlined_input.dart';

class VerifyEmailPage extends StatefulWidget {
  static final routeName = 'verifyEmail';

  @override
  _VerifyEmailPageState createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends State<VerifyEmailPage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  String email = "";
  String emailError;

  void verifiEmail() async {
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
    _showModalBottomSheet(context, email);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: epgColor,
      key: scaffoldKey,
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(child: Container()),
            Image.asset(
              'assets/images/logoyotta.png',
              width: 120,
              color: Colors.white,
            ),
            SizedBox(height: 10),
            Container(
              padding: EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 20),
                  Text('INGRESA TU CORREO ',
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          color: Colors.white)),
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
                      label: "RECUPERAR CONTRASEÑA",
                      width: double.infinity,
                      onPressed: () {
                        verifiEmail();
                        FocusScope.of(context).requestFocus(new FocusNode());
                      }),
                ],
              ),
            ),
            Expanded(child: Container())
          ],
        ),
      ),
    );
  }

  _showModalBottomSheet(BuildContext context, String email) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          int proceso = 0;
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter mystate) {
            return Container(
              height: 300,
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.refresh, color: secondaryColor),
                      SizedBox(width: 10),
                      Text('ACTUALIZAR CONTRASEÑA',
                          style: TextStyle(
                              color: secondaryColor,
                              fontWeight: FontWeight.w900,
                              fontSize: 16)),
                    ],
                  ),
                  SizedBox(height: 20),
                  Text(
                      'Al aceptar el cambio de contraseña se te enviará un correo con tu nueva contraseña',
                      style: TextStyle(fontSize: 16)),
                  SizedBox(height: 20),
                  Text(
                      'Nota: Debes tener en cuenta que tu contraseña actual sera reemplazada por la enviada a tu correo.',
                      style: TextStyle(fontSize: 14)),
                  SizedBox(height: 20),
                  proceso == 0
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            ElevatedButton.icon(
                                onPressed: () async {
                                  mystate(() {
                                    proceso = 1;
                                  });

                                  final userProvider =
                                      Provider.of<UserProvider>(context,
                                          listen: false);
                                  final response = await userProvider
                                      .verifyEmailChange(email);
                                  Timer(Duration(seconds: 1), () {
                                    if (response == 404) {
                                      mystate(() {
                                        proceso = 2;
                                      });
                                    } else if (response == 0) {
                                      mystate(() {
                                        proceso = 3;
                                      });
                                    } else {
                                      Navigator.pop(context);
                                      mostrarSnackbar(' Correo enviado',
                                          Colors.green, Icons.error);
                                      Future.delayed(Duration(seconds: 2), () {
                                        onCloseDialog();
                                      });
                                    }
                                  });
                                },
                                icon: Icon(Icons.check),
                                label: Text('Si aceptar')),
                            SizedBox(width: 20),
                            ElevatedButton.icon(
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.red),
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                  return 0;
                                },
                                icon: Icon(Icons.block),
                                label: Text('No ')),
                          ],
                        )
                      : proceso == 1
                          ? Container(
                              child: Text('Enviando correo, espere...',
                                  style: TextStyle(
                                      color: Colors.green,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600)),
                            )
                          : proceso == 2
                              ? Container(
                                  child: Text(
                                      'Hubo un error intentelo mas tarde.',
                                      style: TextStyle(
                                          color: Colors.orange,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600)),
                                )
                              : proceso == 3
                                  ? Container(
                                      child: Text(
                                          'El correo no se encuentra en nuestros registros.',
                                          style: TextStyle(
                                              color: Colors.red,
                                              fontSize: 20,
                                              fontWeight: FontWeight.w600)),
                                    )
                                  : Container()
                ],
              ),
            );
          });
        });
  }

  void mostrarSnackbar(String mensaje, Color color, IconData icon) {
    final snackbar = SnackBar(
      backgroundColor: color,
      content: Row(
        children: <Widget>[Icon(icon), Text(mensaje)],
      ),
      duration: Duration(milliseconds: 2000),
    );
    scaffoldKey.currentState.showSnackBar(snackbar);
  }

  void onCloseDialog() {
    Navigator.of(context).pop();
  }
}
