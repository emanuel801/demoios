import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:after_layout/after_layout.dart';
import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cast_video/flutter_cast_video.dart';
import 'package:provider/provider.dart';
import 'package:tv_streaming/constants.dart';
import 'package:tv_streaming/main.dart';
import 'package:tv_streaming/models/channel.dart';
import 'package:tv_streaming/pages/about_page.dart';
import 'package:tv_streaming/pages/profile_page.dart';
import 'package:tv_streaming/pages/search_page.dart';
import 'package:tv_streaming/pages/segunda_page.dart';
import 'package:tv_streaming/providers/access_provider.dart';
import 'package:tv_streaming/providers/player_provider.dart';
import 'package:tv_streaming/providers/programming_provider.dart';
import 'package:tv_streaming/widgets/canales.dart';
import 'package:tv_streaming/widgets/canalescat.dart';
import 'package:tv_streaming/widgets/canaleshori.dart';
import 'package:tv_streaming/widgets/canalesmat.dart';
import 'package:tv_streaming/widgets/programming_guide.dart';
import 'package:tv_streaming/widgets/round_icon_button.dart';
import 'package:tv_streaming/widgets/time_picker.dart';
import 'package:wakelock/wakelock.dart';
import 'package:dart_date/dart_date.dart';
import 'package:native_device_orientation/native_device_orientation.dart';
import 'package:http/http.dart' as http;

import 'conectivity_page.dart';

List<DateTime> getTimes(DateTime startTime, DateTime endTime, Duration step) {
  final output = <DateTime>[];
  var currentValue =
  DateTime(startTime.year, startTime.month, startTime.day, startTime.hour);
  while (currentValue.difference(endTime).isNegative) {
    output.add(currentValue);
    currentValue = currentValue.add(step);
  }
  return output;
}

String urlfinal = "tvvvv";

class HomePage extends StatefulWidget {
  static final String routeName = 'home';
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with AfterLayoutMixin, RouteAware {
  int selectedTab = 0;
  bool togglingFS = false;
  final int initialPage = 48;
  bool showChannelButtons = false;
  Timer timer;

  List<DateTime> times = getTimes(
    DateTime.now().subHours(24),
    DateTime.now().addHours(24),
    Duration(minutes: 30),
  );

  Stream<NativeDeviceOrientation> orientationStream;

  DateTimeRange selectedRange;
  Future<bool> validar() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('connected');

        return true;
      }
    } on SocketException catch (_) {
      print('errrrrrrrrrrrrrrrrrrrrrrrrrrr tv11111111111111111111111111111');
      Navigator.pushReplacementNamed(context, ConectivityPage.routeName);
      return false;
    }
  }

  Future<bool> validarurl() async {
    String url;
    var response;
    url = "http://tv1.yottalan.com";
    print("validar url");
    try {
      response = await http
          .post(
        Uri.parse('$url/auth/login/'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          "email": "emanuel@emanuel.com",
          "password": "emanuel",
        }),
      )
          .timeout(
        const Duration(seconds: 5),
        onTimeout: () {
          // Time has run out, do what you wanted to do.
          return http.Response(
              'Error', 408); // Request Timeout response status code
        },
      );

      print("error codeeeeeeeeeeeeeeeeeeeeeeeeeeee");
      print(response.toString());
      print("mensajeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee");
      if (response.statusCode == 400) {
        urlfinal = "tv1";
        print("ifffffffffffffffftv1");
        return true;
      } else {
        urlfinal = "tv2";
        print("ifffffffffffffffftv2");

        Navigator.pushReplacementNamed(context, SegundaPage.routeName);
        return false;
      }
    } on SocketException catch (_) {
      print('errrrrrrrrrrrrrrrrrrrrrrrrrrr tv11111111111111111111111111111');
      //Navigator.pushReplacementNamed(context, ConectivityPage.routeName);
      return false;
    }
  }

  @override
  void initState() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    selectedRange = DateTimeRange(
      start: times[initialPage],
      end: times[initialPage + 4],
    );

    final playerProvider = Provider.of<PlayerProvider>(context, listen: false);

    playerProvider.initializeController();
    Wakelock.enable();
    super.initState();
    //validar();
    //validarurl();
  }

  @override
  void dispose() {
    Wakelock.disable();
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context));
  }

  @override
  void didPopNext() {
    final playerProvider = Provider.of<PlayerProvider>(context, listen: false);
    playerProvider.controller.setControlsEnabled(true);
    //SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  }

  Future<bool> handlePop() {
    Provider.of<PlayerProvider>(context, listen: false).controller.pause();
    Provider.of<PlayerProvider>(context, listen: false).disposePlayer();
    return Future.value(true);
  }

  void handleSelectTab(index) {
    if (index == 1) {
      Navigator.pushNamed(context, SearchPage.routeName);
    }
    if (index == 2) {
      Navigator.pushNamed(context, ProfilePage.routeName);
    }
    if (index == 3) {
      Navigator.pushNamed(context, AboutPage.routeName);
    }

  }

  @override
  Widget build(BuildContext context) {
    ChromeCastController _controller;
    final accessProvider = Provider.of<AccessProvider>(context, listen: false);

    final programmingProvider = Provider.of<ProgrammingProvider>(context);

    final playerProvider = Provider.of<PlayerProvider>(context);
    final theme = Theme.of(context);
    print("builddddddddddddddddddddddddddddddddddddddddd");
    print(urlfinal);
    final orientation = MediaQuery.of(context).orientation;
    double sizeh=MediaQuery.of(context).size.height;
    double sizew=MediaQuery.of(context).size.width;
    double a;
    double b;
    double ratio;
    a = MediaQuery.of(context).size.height / MediaQuery.of(context).size.width;
    b = MediaQuery.of(context).size.width / MediaQuery.of(context).size.height;
    if (a > b) {
      ratio = a;
    } else {
      ratio = b;
    }
    SystemChrome.setEnabledSystemUIOverlays([]);
    Wakelock.enable();
    Channel nextChannel;
    Channel previousChannel;
    int selectedChannelIndex =
    programmingProvider.programmingGuide?.indexWhere((channel) {
      return channel.number == programmingProvider.selectedChannel.number;
    });
    if (selectedChannelIndex != null &&
        selectedChannelIndex <
            programmingProvider.programmingGuide.length - 1) {
      nextChannel =
      programmingProvider.programmingGuide[selectedChannelIndex + 1];
    }
    if (selectedChannelIndex != null && selectedChannelIndex > 0) {
      previousChannel =
      programmingProvider.programmingGuide[selectedChannelIndex - 1];
    }

    Future<void> _change(url) async {
      print("lllllllllllllllllll"+url);
      await _controller?.loadMedia(url);

    }

    return WillPopScope(
      onWillPop: this.handlePop,
      child: Scaffold(
        backgroundColor: fondoColor,
        appBar: orientation == Orientation.portrait

            ? AppBar(
          title: Image.asset('assets/images/logoyotta.png',
              width: 55,
              color: Colors.white,
              alignment: Alignment.topRight),
          /*     actions: [

                  IconButton(
                    icon: Icon(Icons.cast), // Icono de cast
                    onPressed: () {
          // Navegar a otro lugar cuando se hace clic en el icono de cast
                    Navigator.push(
                      context,
                    MaterialPageRoute(builder: (context) => SearchPage()), // Reemplaza OtraPagina() con el nombre de tu clase de la página a la que deseas navegar
                    );
              }),
              ],*/)
            : null,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(color: Colors.black),
              child: Stack(
                children: [

                  GestureDetector(
                    onHorizontalDragEnd: (DragEndDetails details) {
                      if (details.primaryVelocity != null) {
                        if (details.primaryVelocity > 0) {
                          // Deslizar hacia la derecha
                          // Cambiar al canal anterior
                          if (previousChannel != null) {
                            programmingProvider.selectedChannel = previousChannel;
                            playerProvider.changeChannel(
                                previousChannel, accessProvider.token);
                            // Actualizar la transmisión
                            _change(programmingProvider.selectedChannel.stream);
                            Timer(Duration(milliseconds: 500), () {
                              setState(() {
                                showChannelButtons = true;
                              });
                            });

                            Timer(Duration(seconds: 3), () {
                              setState(() {
                                showChannelButtons = false;
                              });
                            });


                          }
                        } else if (details.primaryVelocity < 0) {
                          // Deslizar hacia la izquierda
                          // Cambiar al canal siguiente
                          if (nextChannel != null) {
                            programmingProvider.selectedChannel = nextChannel;
                            playerProvider.changeChannel(
                                nextChannel, accessProvider.token);
                            // Actualizar la transmisión
                            _change(programmingProvider.selectedChannel.stream);

                            Timer(Duration(milliseconds: 500), () {
                              setState(() {
                                showChannelButtons = true;
                              });
                            });

                            Timer(Duration(seconds: 3), () {
                              setState(() {
                                showChannelButtons = false;
                              });
                            });


                          }
                        }
                      }
                    },



                    child: AspectRatio(
                      aspectRatio: ratio,
                      child: BetterPlayer(
                        controller: playerProvider.controller,
                      ),
                    ),
                  ),


                  /*
                  showChannelButtons
                      ? Positioned(
                          top: orientation == Orientation.portrait?50:(sizeh-30)/2,
                          left: 20,
                          right: 20,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              previousChannel != null
                                  ? RoundIconButton(
                                      icon: Icons.arrow_back_ios,
                                      onTap: () {
                                        programmingProvider.selectedChannel =
                                            previousChannel;
                                        playerProvider.changeChannel(
                                            previousChannel,
                                            accessProvider.token);

                                        _change(programmingProvider.selectedChannel.stream);
                                      })
                                  : Container(),
                              nextChannel != null
                                  ? RoundIconButton(
                                      icon: Icons.arrow_forward_ios,
                                      onTap: () {
                                        programmingProvider.selectedChannel =
                                            nextChannel;
                                        playerProvider.changeChannel(
                                            nextChannel, accessProvider.token);

                                        _change(programmingProvider.selectedChannel.stream);
                                      },
                                    )
                                  : Container()
                            ],
                          ),
                        )
                      : Container()
                  ,*/
                  showChannelButtons
                      ? Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Material(
                            color: Colors.transparent,
                            child: Container(
                              height: orientation == Orientation.portrait ? 50 : (sizeh - 30) / 3,
                              width: orientation == Orientation.portrait ? sizew - 30 : (sizew - 30),
                              color: Colors.black.withOpacity(0.5),
                              padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
                              child: Row(
                                children: [
                                  // Imagen a la izquierda
                                  Container(
                                    margin: EdgeInsets.only(right: 8.0),
                                    child: Image.network(
                                      programmingProvider.selectedChannel.image,
                                      width: orientation == Orientation.portrait ? 35 : (sizeh - 30) / 4,
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                  // Nombre y Descripción
                                  Expanded(
                                    flex: 3, // Ajusta el valor según sea necesario
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          '${programmingProvider.selectedChannel.number}',
                                          style: TextStyle(fontSize: orientation == Orientation.portrait ? 9 : 13, color: Colors.white),
                                        ),
                                        Text(
                                          '${programmingProvider.selectedChannel.name}',
                                          style: TextStyle(fontSize: orientation == Orientation.portrait ? 9 : 13, color: Colors.white),
                                        ),
                                        Text(
                                          programmingProvider.selectedChannel.description,
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 2,
                                          style: TextStyle(fontSize: orientation == Orientation.portrait ? 9 : 13, color: Colors.white),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            )


                        ),


                      ],
                    ),
                  )
                      : Container(),

                ],
              ),
            ),

            Expanded(
              child: Column(
                children: [
                  Container(
                    child: Canalescat(
                      isLoading: programmingProvider.isGettingProgrammingGuide,
                      channels: programmingProvider.programmingGuide,
                      selectedRange: selectedRange,
                      onChannelChanged: (channel) {
                        if (programmingProvider.selectedChannel.stream !=
                            channel.stream) {
                          programmingProvider.selectedChannel = channel;
                          playerProvider.changeChannel(
                              channel, accessProvider.token);
                        }
                      },
                    ),
                    height: 90,

                  ),
                  Expanded(
                    child: Container(
                      child: Canalesmat(
                        isLoading: programmingProvider.isGettingProgrammingGuide,
                        channels: programmingProvider.programmingGuide,
                        selectedRange: selectedRange,
                        onChannelChanged: (channel) {
                          if (programmingProvider.selectedChannel.stream !=
                              channel.stream) {
                            programmingProvider.selectedChannel = channel;
                            playerProvider.changeChannel(
                                channel, accessProvider.token);
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        bottomNavigationBar: orientation == Orientation.portrait
            ? BottomNavigationBar(
          showUnselectedLabels: true,

          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.tv_outlined),
              label: 'TV',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.cast),
              label: 'Cast',
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
          currentIndex: selectedTab,
          unselectedItemColor: Colors.grey, // Color de íconos y etiquetas no seleccionados
          selectedItemColor: theme.primaryColor, // Color de ícono y etiqueta seleccionados
          selectedLabelStyle: TextStyle(color: theme.primaryColor), // Color de la etiqueta seleccionada
          unselectedLabelStyle: TextStyle(color: Colors.grey),
          onTap: handleSelectTab,
        )
            : null,
      ),
    );
  }

  @override
  void afterFirstLayout(BuildContext context) {
    final programmingProvider =
    Provider.of<ProgrammingProvider>(context, listen: false);
    final accessProvider = Provider.of<AccessProvider>(context, listen: false);

    print("afterrrrrrrrrrrrrrrrr");
    print(urlfinal);

    programmingProvider.getProgrammingGuide(context).then((channels) {
      final playerProvider =
      Provider.of<PlayerProvider>(context, listen: false);
      playerProvider.setChannel(programmingProvider.selectedChannel);
      playerProvider.controller.addEventsListener((event) {
        if (event.betterPlayerEventType ==
            BetterPlayerEventType.controlsHidden) {

          /*   setState(() {
            showChannelButtons = true;
          });
*/

        } else if (event.betterPlayerEventType ==
            BetterPlayerEventType.controlsVisible ||
            event.betterPlayerEventType == BetterPlayerEventType.exception) {

          /*
          setState(() {
            showChannelButtons = true;
          });
    */

        }
      });
    });
  }
}
