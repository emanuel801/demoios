import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tv_streaming/constants.dart';
import 'package:tv_streaming/models/user.dart';
import 'package:tv_streaming/pages/home_page.dart';
import 'package:tv_streaming/pages/login_page.dart';
import 'package:tv_streaming/preferencias/preferencias_usuario.dart';
import 'package:tv_streaming/providers/access_provider.dart';
import 'package:tv_streaming/providers/user_provider.dart';
import 'package:tv_streaming/widgets/app_button.dart';
import 'package:tv_streaming/widgets/outlined_input.dart';

class NewCount3Page extends StatefulWidget {
  static final routeName = 'newCount3';

  final String email;
  final String token;
  final User usuario;

  const NewCount3Page({this.email, this.token, this.usuario});

  @override
  _NewCount3PageState createState() => _NewCount3PageState();
}

class _NewCount3PageState extends State<NewCount3Page> {
  String nombres = "";
  String nombresError;
  String apellidos = "";
  String apellidosError;
  String celular = "";
  String celularError;
  String documento = "77777777";
  String errorDocumento;
  String tipoDocumento = "0";
  String erroTipoDoc;
  String serverError;

  List _listTipoDoc = ['Dni', 'Carnet de extranjeria', 'Pasaporte'];

  List<DropdownMenuItem<String>> getTipoDoct() {
    List<DropdownMenuItem<String>> lista = [];
    _listTipoDoc.asMap().forEach((indice, element) {
      lista.add(DropdownMenuItem(
        child: Text(element),
        value: indice.toString(),
      ));
    });
    return lista;
  }

  void updateAcount(String correo) async {
    if (nombres.isEmpty) {
      setState(() {
        nombresError = "Ingrese sus nombres";
      });
      return;
    }
    if (apellidos.isEmpty) {
      setState(() {
        apellidosError = "Ingrese sus apellidos";
      });
      return;
    }
    if (celular.isEmpty) {
      setState(() {
        celularError = "Ingrese tu celular nombres";
      });
      return;
    } else if (!RegExp(
      "^[0-9]*\$",
    ).hasMatch(celular)) {
      setState(() {
        celularError = "Celular inválido";
      });
      return;
    } else {
      setState(() {
        celularError = null;
      });
    }

    final accessProvider = Provider.of<AccessProvider>(context, listen: false);
    final _prefs = new PreferenciasUsuario();
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final response = await userProvider.updateAcount(_prefs.email,nombres, apellidos,
        celular, documento, tipoDocumento, accessProvider.token, null);
    if (response == '1') {
      setState(() {
        serverError = null;
      });
      Navigator.pushReplacementNamed(context, LoginPage.routeName);
    } else {
      print(response);
      setState(() {
        serverError = 'Error al completar los datos';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    String email = this.widget.email;

    List _listTipoDoc = ['Dni', 'Carnet de extranjeria', 'Pasaporte'];

    List<DropdownMenuItem<String>> getTipoDoct() {
      List<DropdownMenuItem<String>> lista = [];
      _listTipoDoc.asMap().forEach((indice, element) {
        lista.add(DropdownMenuItem(
          child: Text(element),
          value: indice.toString(),
        ));
      });
      return lista;
    }

    return Scaffold(
      backgroundColor: epgColor,
      floatingActionButton: FloatingActionButton(
        child: Container(
          width: 60,
          height: 60,
          child: Icon(
            Icons.home,
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
          Navigator.pushReplacementNamed(context, HomePage.routeName);
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
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 20),
                      Text('PASO 3 DE 3',
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w800,
                              color: primaryTextColor)),
                      SizedBox(height: 5),
                      Text(
                        'Completa los datos de tu cuenta.',
                        style: TextStyle(fontSize: 20, color: primaryTextColor),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 15),
                      OutlinedInput(
                        valor: email,
                        soloLeer: true,
                        onChanged: (value) {
                          email = email;
                        },
                        labelText: 'Correo electrónico*',
                        keyboardType: TextInputType.emailAddress,
                      ),
                      SizedBox(height: 16),
                      OutlinedInput(
                        pageView: 'newCount',
                        labelText: 'Nombres*',
                        onChanged: (value) {
                          nombres = value;
                          setState(() {
                            nombresError = null;
                          });
                        },
                        errorText: nombresError,
                      ),
                      SizedBox(height: 16),
                      OutlinedInput(
                        pageView: 'newCount',
                        labelText: 'Apellidos*',
                        onChanged: (value) {
                          apellidos = value;
                          setState(() {
                            apellidosError = null;
                          });
                        },
                        errorText: apellidosError,
                      ),
                      SizedBox(height: 16),
                      OutlinedInput(
                        pageView: 'newCount',
                        labelText: 'Celular*',
                        onChanged: (value) {
                          celular = value;
                          setState(() {
                            celularError = null;
                          });
                        },
                        errorText: celularError,
                      ),
                      SizedBox(height: 16),
                      erroTipoDoc != null
                          ? Container(
                              width: double.infinity,
                              padding: EdgeInsets.only(top: 10, left: 26),
                              child: Text('$erroTipoDoc',
                                  style: TextStyle(
                                      color: Colors.red, fontSize: 12),
                                  textAlign: TextAlign.left))
                          : Container(),
                      SizedBox(height: 16),
                      AppButton(
                        label: "COMPLETA TUS DATOS",
                        width: double.infinity,
                        onPressed: () {
                          updateAcount(email);
                        },
                      ),
                      SizedBox(height: 10),
                      serverError != null
                          ? Text(
                              serverError,
                              style: TextStyle(color: Colors.red),
                            )
                          : Container(),
                      SizedBox(height: 70)
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
