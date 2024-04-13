import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tv_streaming/constants.dart';
import 'package:tv_streaming/pages/about_page.dart';
import 'package:tv_streaming/pages/home_page.dart';
import 'package:tv_streaming/pages/login_page.dart';
import 'package:tv_streaming/pages/restore_psw/change_pasword.dart';
import 'package:tv_streaming/pages/update_user.dart';
import 'package:tv_streaming/preferencias/preferencias_usuario.dart';
import 'package:tv_streaming/providers/user_provider.dart';
import 'package:tv_streaming/widgets/mini_player.dart';
import 'package:tv_streaming/providers/access_provider.dart';
import 'package:tv_streaming/widgets/app_button.dart';
import 'package:tv_streaming/widgets/field_card.dart';
import 'package:wakelock/wakelock.dart';
import 'package:tv_streaming/providers/player_provider.dart';

class ProfilePage extends StatefulWidget {
  static final routeName = 'Profile';
  const ProfilePage({Key key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int selectedIndex = 1;

  void handleSelectTab(index) {
    if (index == 2) {
      Navigator.pushReplacementNamed(context, AboutPage.routeName);
    }
    if (index == 0) {
      Navigator.popUntil(context, (Route route) => route.isFirst);
    }
  }

  final _prefs = new PreferenciasUsuario();

  @override
  Widget build(BuildContext context) {
    final accessProvider = Provider.of<AccessProvider>(context);
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final playerProvider = Provider.of<PlayerProvider>(context, listen: false);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Mi perfil'),
      ),
      body: Container(
        color: epgColor,
        height: double.infinity,
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: EdgeInsets.all(10.0),
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          decoration:
                              BoxDecoration(shape: BoxShape.circle, boxShadow: [
                            BoxShadow(
                                color: Colors.black.withOpacity(0.4),
                                offset: Offset(0, 10),
                                blurRadius: 10,
                                spreadRadius: 1)
                          ]),
                          margin: EdgeInsets.all(10),
                          child: CircleAvatar(
                            backgroundColor: Colors.white,
                            child: ClipOval(
                              child: _prefs.avatar != ""
                                  ? CachedNetworkImage(
                                      height: 100.0,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                      placeholder: (context, url) =>
                                          const CircularProgressIndicator(
                                        backgroundColor: Colors.black26,
                                      ),
                                      imageUrl: _prefs.avatar,
                                    )
                                  : Image(
                                      image: AssetImage(
                                          'assets/images/user_profile.png'),
                                      height: 100,
                                      width: 100),
                            ),
                          ),
                        ),
                        Container(
                          width: 1,
                          height: 40,
                          color: Colors.black38,
                          margin: EdgeInsets.only(left: 10, right: 10),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Nombre',
                              style: TextStyle(
                                color: Colors.black87,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              _prefs != null
                                  ? _prefs.firstName + ' ' + _prefs.lastName
                                  : '',
                              style: TextStyle(color: Colors.black54),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  FieldCard(
                    icon: Icons.email_outlined,
                    field: 'Email',
                    value: _prefs != null ? _prefs.email : '',
                  ),
                  FieldCard(
                    icon: Icons.phone,
                    field: 'Teléfono',
                    value: _prefs != null ? _prefs.cellphone : '-',
                  ),
                  SizedBox(height: 26),
                  AppButton(
                    label: 'Actualizar mis datos',
                    onPressed: () {
                      Navigator.push(
                          context,
                          CupertinoPageRoute(
                              builder: (BuildContext context) => UpdateUserPage(
                                  _prefs.email,
                                  _prefs.firstName,
                                  _prefs.lastName,
                                  _prefs.cellphone,
                                  _prefs.documentNumber,
                                  _prefs.documentType,
                                  _prefs.avatar)));
                    },
                  ),
                  SizedBox(height: 16),
                  AppButton(
                    label: 'Cambiar contraseña',
                    onPressed: () {
                      Navigator.push(
                          context,
                          CupertinoPageRoute(
                              builder: (BuildContext context) =>
                                  ChangePasswordPage()));
                    },
                  ),
                  SizedBox(height: 16),
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
                  SizedBox(height: 16),
                  AppButton(
                    label: 'Eliminar cuenta',
                    onPressed: () async {
                      Navigator.pushNamedAndRemoveUntil(
                          context, LoginPage.routeName, (route) {
                        print(route.runtimeType);
                        return route.runtimeType == HomePage;
                      });
                      //se agrega el provider
                      playerProvider.controller.videoPlayerController.pause();
                      accessProvider.logout(accessProvider.token);

                      final response = await userProvider.removeAccount(_prefs.email,_prefs.firstName,_prefs.lastName,accessProvider.token);
                      
                    },
                  )
                ],
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: MiniPlayer(),
            )
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.tv_outlined),
            label: 'TV',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Perfil',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.info_outline),
            label: 'Acerca de',
          ),
        ],
        currentIndex: 1,
        selectedItemColor: theme.primaryColor,
        onTap: handleSelectTab,
      ),
    );
  }

  logout() async {
    final accessProvider = Provider.of<AccessProvider>(context, listen: false);

    await accessProvider.logout(accessProvider.token);
    setState(() {
      Wakelock.disable();
    });
    Navigator.pushReplacementNamed(context, LoginPage.routeName);
  }
}
