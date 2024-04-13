import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_field/phone_number.dart';
import 'package:provider/provider.dart';
import 'package:tv_streaming/models/user.dart';
// import 'package:tv_streaming/preferencias/preferenciasdart';
import 'package:tv_streaming/providers/access_provider.dart';
import 'package:tv_streaming/providers/user_provider.dart';
import 'package:tv_streaming/widgets/app_button.dart';
import 'package:tv_streaming/widgets/outlined_input.dart';
import 'package:country_codes/country_codes.dart';

import '../constants.dart';
import 'home_page.dart';

class UpdateUserPage extends StatefulWidget {
  final String email1;
  final String firstName1;
  final String lastName1;
  final String cellPhone1;
  final String documentNumber1;
  final String documentType1;
  final String avatar1;

  const UpdateUserPage(this.email1, this.firstName1, this.lastName1,
      this.cellPhone1, this.documentNumber1, this.documentType1, this.avatar1);

  @override
  _UpdateUserPageState createState() => _UpdateUserPageState();
}

class _UpdateUserPageState extends State<UpdateUserPage> {
  TextEditingController _firstNameController = new TextEditingController();
  TextEditingController _lastNameController = new TextEditingController();
  TextEditingController _cellPhoneController = new TextEditingController();
  TextEditingController _documentNumberController = new TextEditingController();
  TextEditingController _documentTypeController = new TextEditingController();
  TextEditingController _avatarController = new TextEditingController();

  User usuario = new User();
  File foto;
  String avatar;

  String _editFirstName;
  String _editLastName;
  String _editCellPhone;
  String _editDocumentNumber;
  String _editDocumentType;
  String _editAvatar;
  String codigo = "";
  String celular = "";
  String celularError;

 
  String nombresError;
  String apellidosError;
  String errorDocumento;
  String erroTipoDoc;
  String serverError;

  final scaffoldKey = GlobalKey<ScaffoldState>();

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

  void updateAcount(
      String email,
      String nombres,
      String apellidos,
      String celular,
      String tipoDocumento,
      String documento,
      dynamic avatar) async {
    setState(() {
      _editFirstName = nombres;
      _editLastName = apellidos;
      _editCellPhone = celular;
      _editDocumentNumber = documento;
    });

    print("fonoooooooooooooo");
    print(_editCellPhone);

    if (_editFirstName == "") {
      setState(() {
        nombresError = "Ingrese sus nombres";
      });
      return;
    } else {
      nombresError = null;
    }
    if (_editLastName == "") {
      setState(() {
        apellidosError = "Ingrese sus apellidos";
      });
      return;
    } else {
      apellidosError = null;
    }

    if (_editCellPhone == "") {
      setState(() {
        celularError = "Ingrese tu celular ";
      });
      return;
    } else if (!RegExp(
      "^[0-9]*\$",
    ).hasMatch(_editCellPhone)) {
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
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    String celufinal;
    celufinal = codigo + "-" + celular;
    print("celularporvidermas email");
    print(celufinal);
    print(email);
    final response = await userProvider.updateAcount(email,nombres, apellidos,
        celufinal, documento, tipoDocumento, accessProvider.token, avatar);

    if (response == 1) {
      setState(() {
        serverError = null;
      });
      Navigator.pushReplacementNamed(context, HomePage.routeName);
    } else {
      setState(() {
        serverError = 'Error al completar los datos';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    String email = this.widget.email1;
    String celularg = this.widget.cellPhone1;

    final splitted = celularg.split('-');
    var ca = paises[splitted[0]];
    print(ca);

    if (_firstNameController.text != "") {
      _editFirstName = _firstNameController.text;
    }
    if (_lastNameController.text != "") {
      _editLastName = _lastNameController.text;
    }
    if (_cellPhoneController.text != "") {
      _editCellPhone = _cellPhoneController.text;
    }
    if (_documentNumberController.text != "") {
      _editDocumentNumber = _documentNumberController.text;
    }

    if (_editFirstName == null) {
      _firstNameController.text = this.widget.firstName1;
    } else {
      _firstNameController.text = _editFirstName;
    }
    if (_editLastName == null) {
      _lastNameController.text = this.widget.lastName1;
    } else {
      _lastNameController.text = _editLastName;
    }
    if (_editCellPhone == null) {
      _cellPhoneController.text = (this.widget.cellPhone1).split('-')[1];
    } else {
      _cellPhoneController.text = _editCellPhone;
    }
    if (_editDocumentNumber == null) {
      _documentNumberController.text = this.widget.documentNumber1;
    } else {
      _documentNumberController.text = _editDocumentNumber;
    }
    if (_editDocumentType == null) {
      _documentTypeController.text = this.widget.documentType1;
    } else {
      _documentTypeController.text = _editDocumentType;
    }
    if (_editAvatar == null) {
      _avatarController.text = this.widget.avatar1;
    } else {
      _avatarController.text = _editAvatar;
    }
    // usuario=_prefs;

    if (_documentTypeController.text == 'DNI') {
      _editDocumentType = '0';
    }
    if (_documentTypeController.text == 'CE') {
      _editDocumentType = '1';
    }
    if (_documentTypeController.text == 'PASSPORT') {
      _editDocumentType = '2';
    }

    return Scaffold(
        backgroundColor: epgColor,
        key: scaffoldKey,
        appBar: AppBar(
          title: Text('Actualizar datos'),
          actions: <Widget>[
            /*IconButton(
              icon: Icon(Icons.photo_size_select_actual),
              onPressed: getImage,
            ),
            IconButton(
              icon: Icon(Icons.camera_alt),
              onPressed: getCamera,
            ),*/
          ],
        ),
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 100,
                    height: 100,
                  ),
                  Container(
                    width: 100,
                    height: 100,
                    decoration:
                        BoxDecoration(shape: BoxShape.circle, boxShadow: [
                      BoxShadow(
                          color: Colors.black.withOpacity(0.4),
                          offset: Offset(0, 10),
                          blurRadius: 20,
                          spreadRadius: 3)
                    ]),
                    margin: EdgeInsets.all(10),
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      child: ClipOval(
                        child: _avatarController.text != "" && avatar == null
                            ? CachedNetworkImage(
                                height: 100.0,
                                width: double.infinity,
                                fit: BoxFit.cover,
                                placeholder: (context, url) =>
                                    const CircularProgressIndicator(
                                  backgroundColor: Colors.black26,
                                ),
                                imageUrl: _avatarController.text,
                              )
                            : foto != null
                                ? Image.file(
                                    foto,
                                    fit: BoxFit.cover,
                                    height: 120.0,
                                    width: 120.0,
                                  )
                                : Image(
                                    image: AssetImage(
                                        'assets/images/user_profile.png'),
                                    height: 100,
                                    width: 100),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Image.asset('assets/images/logoyotta.png',
                        width: 80,
                        color: Colors.white,
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
                        Text(
                          'Completa los datos de tu cuenta.',
                          style: TextStyle(
                              fontSize: 21,
                              fontWeight: FontWeight.w800,
                              color: primaryTextColor),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 15),
                        OutlinedInput(
                          valor: email,
                          soloLeer: true,
                          onChanged: (value) {
                            email = value;
                          },
                          labelText: 'Correo electrónico*',
                          keyboardType: TextInputType.emailAddress,
                        ),
                        SizedBox(height: 16),
                        OutlinedInput2(
                          controller: _firstNameController,
                          labelText: 'Nombres*',
                          pageView: 'newCount',
                          onSaved: (valor) {
                            _editFirstName = valor;
                            setState(() {
                              nombresError = null;
                            });
                          },
                          errorText: nombresError,
                        ),
                        SizedBox(height: 16),
                        OutlinedInput2(
                          controller: _lastNameController,
                          labelText: 'Apellidos*',
                          pageView: 'newCount',
                          onSaved: (valor) {
                            _editLastName = valor;
                            setState(() {
                              apellidosError = null;
                            });
                          },
                          errorText: apellidosError,
                        ),
                        SizedBox(height: 16),
                        IntlPhoneField(
                          searchText: "Seleccione su país",
                          style: TextStyle(fontSize: 18, color: Colors.white),
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
                                borderSide: BorderSide(color: Colors.white)),
                          ),
                          initialCountryCode: ca,
                          onChanged: (phone) {
                            print(phone.completeNumber);
                            codigo = phone.countryCode.toString();
                            celular = phone.number.toString();
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
                        SizedBox(height: 20),
                        AppButton(
                          label: "Actualizar datos",
                          width: double.infinity,
                          onPressed: () {
                            print("presionnnnnnn");
                            print(celular);
                            updateAcount(
                                email,
                                _firstNameController.text,
                                _lastNameController.text,
                                celular,
                                _documentTypeController.text,
                                _documentNumberController.text,
                                avatar);
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
        ));
  }
}
