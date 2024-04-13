import 'package:flutter/material.dart';
import 'package:tv_streaming/constants.dart';

class OutlinedInput extends StatelessWidget {
  final String errorText;
  final void Function(String) onChanged;
  final String labelText;
  final TextInputType keyboardType;
  final bool obscureText;
  final String pageView;
  final String valor;
  final bool soloLeer;

  const OutlinedInput({
    this.errorText,
    this.onChanged,
    this.labelText,
    this.keyboardType,
    this.obscureText = false,
    this.pageView = 'login',
    this.valor,
    this.soloLeer = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: valor,
      readOnly: soloLeer,
      onChanged: onChanged,
      keyboardType: keyboardType,
      obscureText: obscureText,
      cursorColor: Colors.white,
      style: TextStyle(fontSize: 18, color: Colors.white),
      decoration: InputDecoration(
        fillColor: Colors.white,
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.white, width: 2.0),
          borderRadius: BorderRadius.circular(25.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Color(0xff96979b), width: 2.0),
          borderRadius: BorderRadius.circular(25.0),
        ),
        labelText: labelText,
        labelStyle: TextStyle(color: Colors.white),
        errorText: errorText,
        errorMaxLines: 3,
        errorStyle: (pageView == 'login')
            ? TextStyle(color: primaryTextColor)
            : TextStyle(color: Colors.red),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: (pageView == 'login')
              ? BorderSide(color: primaryTextColor)
              : BorderSide(color: Colors.red),
          borderRadius: BorderRadius.all(Radius.circular(30)),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: (pageView == 'login')
              ? BorderSide(color: primaryTextColor)
              : BorderSide(color: Colors.red),
          borderRadius: BorderRadius.all(Radius.circular(30)),
        ),
        contentPadding: EdgeInsets.only(
          left: 30,
          top: 20,
          bottom: 20,
        ),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(30)),
            borderSide: BorderSide(color: Colors.white)),
      ),
    );
  }
}

class OutlinedInput2 extends StatelessWidget {
  final String errorText;
  final void Function(String) onSaved;
  final String labelText;
  final TextInputType keyboardType;
  final bool obscureText;
  final String pageView;
  final String valor;
  final bool soloLeer;
  final TextEditingController controller;

  const OutlinedInput2(
      {this.errorText,
      this.onSaved,
      this.labelText,
      this.keyboardType,
      this.obscureText = false,
      this.pageView = 'login',
      this.valor,
      this.soloLeer = false,
      this.controller});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      initialValue: valor,
      readOnly: soloLeer,
      onSaved: onSaved,
      keyboardType: keyboardType,
      obscureText: obscureText,
      style: TextStyle(fontSize: 18, color: Colors.white),
      decoration: InputDecoration(
        fillColor: Colors.white,
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Color(0xff2e4053), width: 2.0),
          borderRadius: BorderRadius.circular(25.0),
        ),
        labelText: labelText,
        labelStyle: TextStyle(color: Colors.white),
        errorText: errorText,
        errorStyle: (pageView == 'login')
            ? TextStyle(color: primaryTextColor)
            : TextStyle(color: Colors.red),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: (pageView == 'login')
              ? BorderSide(color: primaryTextColor)
              : BorderSide(color: Colors.red),
          borderRadius: BorderRadius.all(Radius.circular(30)),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: (pageView == 'login')
              ? BorderSide(color: primaryTextColor)
              : BorderSide(color: Colors.red),
          borderRadius: BorderRadius.all(Radius.circular(30)),
        ),
        contentPadding: EdgeInsets.only(
          left: 30,
          top: 20,
          bottom: 20,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(30)),
        ),
      ),
    );
  }
}
