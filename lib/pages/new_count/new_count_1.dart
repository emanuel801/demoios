import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_field/phone_number.dart';
import 'package:provider/provider.dart';
import 'package:tv_streaming/constants.dart';
import 'package:tv_streaming/pages/login_page.dart';
import 'package:tv_streaming/pages/new_count/correo_page.dart';
import 'package:tv_streaming/providers/user_provider.dart';
import 'package:tv_streaming/widgets/app_button.dart';
import 'package:tv_streaming/widgets/outlined_input.dart';

import 'dart:ui';

import 'new_count_2.dart';

class NewCount1Page extends StatefulWidget {
  static final routeName = 'newCount1';

  @override
  _NewCountPageState createState() => _NewCountPageState();
}

class _NewCountPageState extends State<NewCount1Page> {
  String email = "";
  String emailError;
  String password = "";
  String passwordError;
  String nombre = "";
  String nombreError;
  String apellido = "";
  String apellidoError;
  String celular = "";
  String celularError;
  String fecha = "";
  String fechaError;
  String _date = "Fecha de cumpleaños";
  String _dateError = "";
  String _time = "Not set";

  bool cargando = false;
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

    if (nombre.isEmpty) {
      setState(() {
        nombreError = "Ingrese su nombre";
      });
      return;
    } else {
      setState(() {
        nombreError = null;
      });
    }
    if (apellido.isEmpty) {
      setState(() {
        apellidoError = "Ingrese sus apellidos";
      });
      return;
    } else {
      setState(() {
        apellidoError = null;
      });
    }

    if (celular.isEmpty) {
      setState(() {
        celularError = "Ingrese su celular ";
      });
      return;
    } else if (!RegExp(
      "^[0-9]*\$",
    ).hasMatch(celular)) {
    } else {
      setState(() {
        celularError = null;
      });
    }

  /*
    if (_date == "Fecha de cumpleaños") {
      setState(() {
        _date ='2020-01-01';
      });
      return;
    } else {
      setState(() {
        _dateError = null;
      });
    }
  */
  
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    setState(() {
      cargando = true;
    });
    final response = await userProvider.createAcount(
        email, password, nombre, apellido, celular, '2020-01-01');
    print("aquiiiiiii");
    print(response.toString());
    if (response == '1') {
      Navigator.push(
          context,
          CupertinoPageRoute(
              builder: (BuildContext context) =>
                  CorreoPage(nombree: nombre, emaill: email)));
    } else {
      setState(() {
        cargando = false;
        _dateError = response;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: epgColor,
      body: SafeArea(
          child: cargando == true
              ? Center(
                  child: CircularProgressIndicator(
                    backgroundColor: epgColor,
                    valueColor: AlwaysStoppedAnimation(Colors.blue),
                    strokeWidth: 4,
                  ),
                )
              : Stack(
                  children: [
                    Positioned(
                        right: 10,
                        top: 10,
                        child: Image.asset(
                          'assets/images/logoyotta.png',
                          width: 50,
                          color: Colors.white,
                        )),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(horizontal: 25),
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(height: 30),
                            Text('Disfruta donde quieras,regístrate',
                                style: TextStyle(
                                    fontSize: 22, color: primaryTextColor)),
                            SizedBox(height: 25),
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
                            OutlinedInput(
                              onChanged: (value) {
                                password = value;
                                setState(() {
                                  passwordError = null;
                                });
                              },
                              pageView: 'newCount',
                              errorText: passwordError,
                              labelText: 'Contraseña',
                              keyboardType: TextInputType.name,
                            ),
                            SizedBox(height: 10),
                            OutlinedInput(
                              onChanged: (value) {
                                nombre = value;
                                setState(() {
                                  nombreError = null;
                                });
                              },
                              pageView: 'newCount',
                              errorText: nombreError,
                              labelText: 'Nombre',
                              keyboardType: TextInputType.name,
                            ),
                            SizedBox(height: 10),
                            SizedBox(
                              height: 10,
                            ),
                            OutlinedInput(
                              onChanged: (value) {
                                apellido = value;
                                setState(() {
                                  apellidoError = null;
                                });
                              },
                              pageView: 'newCount',
                              errorText: apellidoError,
                              labelText: 'Apellido',
                              keyboardType: TextInputType.name,
                            ),
                            SizedBox(height: 10),
                            IntlPhoneField(
                              searchText: "Seleccione su país",
                              style:
                                  TextStyle(fontSize: 18, color: Colors.white),
                              countryCodeTextColor: Colors.white,
                              decoration: InputDecoration(
                                errorText: celularError,
                                fillColor: Colors.white,
                                labelText: 'Número telefónico',
                                labelStyle: TextStyle(color: Colors.white),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Color(0xff96979b), width: 2.0),
                                  borderRadius: BorderRadius.circular(25.0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Colors.white, width: 2.0),
                                  borderRadius: BorderRadius.circular(25.0),
                                ),
                                border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(30)),
                                    borderSide:
                                        BorderSide(color: Colors.white)),
                              ),
                              initialCountryCode: 'PE',
                              onChanged: (phone) {
                                print(phone.completeNumber);
                                celular = phone.countryCode.toString() +
                                    "-" +
                                    phone.number.toString();
                                setState(() {
                                  celularError = null;
                                });
                                print("aquiiii");
                                print(celular);
                              },
                              onCountryChanged: (phone) {
                                print('Country code changed to: ' +
                                    phone.countryCode);
                              },
                            ),
                            SizedBox(height: 10),
                            RaisedButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25.0),
                                  side: BorderSide(
                                      color: Color(0xff96979b), width: 2.0)),
                              elevation: 4.0,
                              onPressed: () {
                                DatePicker.showDatePicker(context,
                                    showTitleActions: true,
                                    minTime: DateTime(1800, 1, 1),
                                    maxTime: DateTime(2022, 12, 31),
                                    onConfirm: (date) {
                                  print('confirm $date');
                                  _date =
                                      '${date.year}-${date.month}-${date.day}';
                                  setState(() {});
                                },
                                    currentTime: DateTime.now(),
                                    locale: LocaleType.es);
                              },
                              child: Container(
                                alignment: Alignment.center,
                                height: 60.0,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Row(children: <Widget>[
                                      Container(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Icon(
                                              Icons.calendar_today,
                                              size: 18.0,
                                              color: Colors.white,
                                            ),
                                            Text(
                                              " $_date",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 18.0),
                                            ),
                                          ],
                                        ),
                                      )
                                    ]),
                                  ],
                                ),
                              ),
                              color: epgColor,
                            ),
                            Text(_dateError == null ? "" : _dateError,
                                style: TextStyle(color: Colors.red)),
                            SizedBox(height: 10),
                            SizedBox(height: 10),
                            AppButton(
                              label: "CREAR CUENTA",
                              width: double.infinity,
                              onPressed: verifiEmail,
                            ),
                            SizedBox(height: 40),
                          ],
                        ),
                      ),
                    ),
                  ],
                )),
    );
  }
}
