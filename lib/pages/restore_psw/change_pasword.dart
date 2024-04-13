import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tv_streaming/providers/access_provider.dart';
import 'package:tv_streaming/providers/user_provider.dart';
import 'package:tv_streaming/widgets/app_button.dart';
import 'package:tv_streaming/widgets/outlined_input.dart';

import '../../constants.dart';

class ChangePasswordPage extends StatefulWidget {
  @override
  _ChangePasswordPageState createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  String psw = "";
  String errorPsw;
  String errorResponse = "";
  String successResponse = "";

  void sendNewPsw() async {
    setState(() {
      errorResponse = "";
    });
    FocusScope.of(context).requestFocus(new FocusNode());
    if (psw.isEmpty) {
      setState(() {
        errorPsw = "Ingrese su contraseña";
      });
      return;
    } else if (psw.length < 6) {
      setState(() {
        errorPsw = "Mínimo 6 caracteres";
      });
      return;
    } else {
      setState(() {
        errorPsw = null;
      });
    }

    final accessProvider = Provider.of<AccessProvider>(context, listen: false);
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final response = await userProvider.sendNewPsw(psw, accessProvider.token);

    if (response != 'ok') {
      setState(() {
        errorResponse = 'Error: ' + response;
      });
    } else {
      mostrarSnackbar(' Contraseña cambiada correctamente enviado',
          Colors.green, Icons.check);
      Future.delayed(Duration(seconds: 2), () {
        onCloseChangePsw();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: epgColor,
        key: scaffoldKey,
        appBar: AppBar(
          title: Text('Cambiar contraseña',
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  color: primaryTextColor)),
        ),
        body: SafeArea(
          child: Stack(
            children: [
              Positioned(
                  right: 10,
                  top: 10,
                  child: Image.asset(
                    'assets/images/logoyotta.png',
                    width: 80,
                    color: secondaryColor,
                  )),
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 20),
                    SizedBox(height: 5),
                    Text(
                      'Coloca la nueva contraseña, debe tener minimo 6 caracteres entre números y letras',
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          color: primaryTextColor),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 15),
                    OutlinedInput(
                      onChanged: (value) {
                        psw = value;
                        setState(() {
                          errorPsw = null;
                        });
                      },
                      pageView: 'newCount',
                      obscureText: false,
                      errorText: errorPsw,
                      labelText: 'Nueva contraseña',
                      keyboardType: TextInputType.emailAddress,
                    ),
                    SizedBox(height: 10),
                    AppButton(
                      label: "CAMBIAR CONTRASEÑA",
                      width: double.infinity,
                      onPressed: sendNewPsw,
                    ),
                    SizedBox(height: 10),
                    errorResponse != ""
                        ? Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              '$errorResponse',
                              style: TextStyle(color: Colors.red),
                            ),
                          )
                        : Container(),
                    SizedBox(height: 40),
                  ],
                ),
              ),
            ],
          ),
        ));
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

  void onCloseChangePsw() {
    Navigator.of(context).pop();
  }
}
