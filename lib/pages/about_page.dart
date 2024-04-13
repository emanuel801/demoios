import 'package:flutter/material.dart';
import 'package:tv_streaming/widgets/mini_player.dart';
import 'package:tv_streaming/pages/profile_page.dart';
import 'package:tv_streaming/widgets/field_card.dart';

class AboutPage extends StatefulWidget {
  static final routeName = 'AboutPage';
  AboutPage({Key key}) : super(key: key);

  @override
  _AboutPageState createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  void handleSelectTab(index) {
    if (index == 1) {
      Navigator.pushReplacementNamed(context, ProfilePage.routeName);
    }
    if (index == 0) {
      Navigator.popUntil(context, (Route route) => route.isFirst);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Acerca de'),
      ),
      body: Container(
        color: Colors.black,
        height: double.infinity,
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: EdgeInsets.all(10.0),
              child: Column(
                children: [
                  FieldCard(
                    icon: Icons.info_outline,
                    field: 'Empresa',
                    value: 'YOTTALAN',
                  ),
                  FieldCard(
                    icon: Icons.email_outlined,
                    field: 'Email',
                    value: 'tv@yottalan.com',
                  ),
                  FieldCard(
                    icon: Icons.phone,
                    field: 'Contacto',
                    value: '+51 937 466 317',
                  ),
                  Container(
                    height: 75,
                    width: MediaQuery.of(context).size.width * 1,
                    padding: EdgeInsets.all(16.0),
                    margin: EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Acerca de nosotros',
                          style: TextStyle(
                            color: Colors.black87,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(height: 5),
                        SizedBox(
                          child: Text(
                            "Únete a la experiencia Yottalan y accede a los mejores contenidos del Perú.",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            softWrap: false,
                            style: TextStyle(color: Colors.black54),
                          ),
                        ),
                      ],
                    ),
                  ),
                  FieldCard(
                    icon: Icons.person,
                    field: 'Política de privacidad',
                    value: 'web.yottalan.com/privacy',
                  ),
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
        currentIndex: 2,
        selectedItemColor: theme.primaryColor,
        onTap: handleSelectTab,
      ),
    );
  }
}
