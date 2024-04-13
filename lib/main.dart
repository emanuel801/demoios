import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:tv_streaming/constants.dart';
import 'package:tv_streaming/pages/about_page.dart';
import 'package:tv_streaming/pages/carrito_page.dart';
import 'package:tv_streaming/pages/conectivity_page.dart';
import 'package:tv_streaming/pages/home_page.dart';
import 'package:tv_streaming/pages/intermedio_page.dart';
import 'package:tv_streaming/pages/ios_page.dart';
import 'package:tv_streaming/pages/login_page.dart';
import 'package:tv_streaming/pages/new_count/new_count_1.dart';
import 'package:tv_streaming/pages/new_count/new_count_2.dart';
import 'package:tv_streaming/pages/nuevo_page.dart';
import 'package:tv_streaming/pages/profile_page.dart';
import 'package:tv_streaming/pages/renovar_page.dart';
import 'package:tv_streaming/pages/segunda_page.dart';
import 'package:tv_streaming/pages/splash_page.dart';
import 'package:tv_streaming/preferencias/preferencias_usuario.dart';
import 'package:tv_streaming/providers/access_provider.dart';
import 'package:tv_streaming/providers/player_provider.dart';
import 'package:tv_streaming/providers/programming_provider.dart';
import 'package:tv_streaming/providers/user_provider.dart';
import 'package:tv_streaming/utilities.dart';

void main() async {
  final AccessProvider accessProvider = AccessProvider();
  final ProgrammingProvider programmingProvider = ProgrammingProvider();
  final PlayerProvider playerProvider = PlayerProvider();
  final UserProvider userProvider = UserProvider();
  final prefs = new PreferenciasUsuario();
  await prefs.initPrefs();

  accessProvider.init();
  runApp(MyApp(
    accessProvider: accessProvider,
    programmingProvider: programmingProvider,
    userProvider: userProvider,
    playerProvider: playerProvider,
  ));
}

final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

class MyApp extends StatelessWidget {
  final AccessProvider accessProvider;
  final ProgrammingProvider programmingProvider;
  final PlayerProvider playerProvider;
  final UserProvider userProvider;

  const MyApp(
      {Key key,
      this.accessProvider,
      this.programmingProvider,
      this.playerProvider,
      this.userProvider})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: accessProvider,
        ),
        ChangeNotifierProvider.value(
          value: programmingProvider,
        ),
        ChangeNotifierProvider.value(
          value: playerProvider,
        ),
        ChangeNotifierProvider.value(
          value: userProvider,
        ),
      ],
      child: MaterialApp(
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: [
          const Locale('en', 'US'),
          const Locale('es', 'ES'),
          const Locale.fromSubtags(languageCode: 'zh'),
        ],
        debugShowCheckedModeBanner: false,
        title: 'YottaTV',
        theme: ThemeData(
          fontFamily: 'Comfortaa',
          primarySwatch: createMaterialColor(fondoColor),
          textTheme: TextTheme(
            headline4: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        routes: {
          SplashPage.routeName: (BuildContext context) => SplashPage(),
          ConectivityPage.routeName: (BuildContext context) =>
              ConectivityPage(),
          ProfilePage.routeName: (BuildContext context) => ProfilePage(),
          LoginPage.routeName: (BuildContext context) => LoginPage(),
          HomePage.routeName: (BuildContext context) => HomePage(),
          AboutPage.routeName: (BuildContext context) => AboutPage(),
          NewCount1Page.routeName: (BuildContext context) => NewCount1Page(),
          NewCount2Page.routeName: (BuildContext context) => NewCount2Page(),
          SegundaPage.routeName: (BuildContext context) => SegundaPage(),
          IntermedioPage.routeName: (BuildContext context) => IntermedioPage(),
          NuevoPage.routeName: (BuildContext context) => NuevoPage(),
          RenovarPage.routeName: (BuildContext context) => RenovarPage(),
          CarritoPage.routeName: (BuildContext context) => CarritoPage(),
          IosPage.routeName: (BuildContext context) => IosPage(),
        },
        navigatorObservers: [routeObserver],
        home: SplashPage(),
      ),
    );
  }
}
