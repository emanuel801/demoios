import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:tv_streaming/constants.dart';
import 'package:tv_streaming/pages/carrito_page.dart';
import 'package:tv_streaming/pages/home_page.dart';
import 'package:tv_streaming/pages/login_page.dart';
import 'package:tv_streaming/providers/access_provider.dart';
import 'package:tv_streaming/providers/player_provider.dart';
import 'package:tv_streaming/widgets/app_button.dart';

class NuevoPage extends StatefulWidget {
  static final String routeName = 'nuevo';
  NuevoPage({Key key}) : super(key: key);

  @override
  State<NuevoPage> createState() => _NuevoPageState();
}

class _NuevoPageState extends State<NuevoPage> {
  @override
  Widget build(BuildContext context) {
    //accessProvider.urlcore = "https://tv2.yottalan.com";
    final accessProvider = Provider.of<AccessProvider>(context);
    final playerProvider = Provider.of<PlayerProvider>(context, listen: false);
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            child: Image.asset(
              'assets/images/conectivity.jpg',
              width: 400.0,
              height: 200.0,
              scale: 1.0,
            ),
            alignment: Alignment.center,
          ),
          Text(
            "Hola",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          SizedBox(
            height: 10,
          ),
          Text("El contenido no está disponible en su red"),
          SizedBox(
            height: 20,
          ),
          SizedBox(
            height: 20,
          ),
          AppButton(
                    label: 'Cerrar sesión',
                    onPressed: () {
                      Navigator.pushNamedAndRemoveUntil(
                          context, LoginPage.routeName, (route) {
                        print(route.runtimeType);
                        return route.runtimeType == HomePage;
                      });
                      //se agrega el provider
                      playerProvider.controller.videoPlayerController.pause();
                      accessProvider.logout(accessProvider.token);
                    },
                  ),
        ],
      )),
    );
  }
}
