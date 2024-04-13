import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cast_video/flutter_cast_video.dart';
import 'package:provider/provider.dart';
import 'package:tv_streaming/api/programming.dart';
import 'package:tv_streaming/models/channel.dart';
import 'package:tv_streaming/pages/about_page.dart';
import 'package:tv_streaming/providers/access_provider.dart';
import 'package:tv_streaming/providers/player_provider.dart';
import 'package:tv_streaming/providers/programming_provider.dart';
import 'package:tv_streaming/widgets/mini_player.dart';
import 'package:tv_streaming/pages/profile_page.dart';
import 'package:tv_streaming/widgets/field_card.dart';

import '../constants.dart';


class SearchPage extends StatefulWidget {
  static final routeName = 'SearchPage';
  SearchPage({Key key}) : super(key: key);
  static const _iconSize = 50.0;
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  List<Channel> _allChannels = [];
  List<Channel> _filteredChannels = [];
  Future<List<Channel>> _futureChannels;
  ChromeCastController _controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _futureChannels = fetchData();
    _loadChannels();
    _searchController.addListener(_onSearchChanged);

  }
  Future<void> _onButtonCreated(ChromeCastController controller) async {
    _controller = controller;
    await _controller.addSessionListener();
  }


  Future<void> _loadChannels() async {

    final programmingProvider = Provider.of<ProgrammingProvider>(context);
    List<Channel> channels = await programmingProvider.programmingGuidetotal;
    setState(() {
      _allChannels = channels;
      _filteredChannels = channels;
    });
  }
  void _onSearchChanged() {
    String query = _searchController.text.toLowerCase();
    setState(() {
      _filteredChannels = _allChannels
          .where((channel) => channel.name.toLowerCase().contains(query))
          .toList();
    });
  }

  void handleSelectTab(index) {
    if (index == 3) {
      Navigator.pushReplacementNamed(context, AboutPage.routeName);
    }
    if (index == 2) {
      Navigator.pushReplacementNamed(context, ProfilePage.routeName);
    }

    if (index == 0) {
      Navigator.popUntil(context, (Route route) => route.isFirst);
    }

  }

  Future<List<Channel>> fetchData() async {
    // Simula una tarea asíncrona que devuelve una lista de canales
    final accessProvider = Provider.of<AccessProvider>(context, listen: false);

    final ChannelsResponse channelsResponse =
    await getChannelsCall(accessProvider.token);

    List<Channel>_fijo = channelsResponse.channels;

    return _fijo;
  }
  Future<List<Channel>> filterChannels(String query) async {
    // Filtra la lista de canales según el término de búsqueda
    List<Channel> allChannels = await fetchData();
    query = query.toLowerCase();
    return allChannels
        .where((channel) => channel.name.toLowerCase().contains(query))
        .toList();
  }

  Future<void> cambiarcanal(Channel canal) async {
    setState(() => {

    });
    await _controller.loadMedia(canal.stream,
    title: canal.number +" "+ canal.name,
      image: canal.image
    );
  }
  Future<void> _onRequestCompleted() async {
    final playing = await _controller.isPlaying();
    setState(() {

    });
  }

  Future<void> _onRequestFailed(String error) async {
    setState((){});
    print(error);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    final programmingProvider = Provider.of<ProgrammingProvider>(context);

    final accessProvider = Provider.of<AccessProvider>(context, listen: false);

    final playerProvider = Provider.of<PlayerProvider>(context);
    Future<void> _onSessionStarted() async {
      setState((){});
      await _controller.loadMedia(programmingProvider.selectedChannel.stream,
        title: programmingProvider.selectedChannel.number+" "+programmingProvider.selectedChannel.name,
        image: programmingProvider.selectedChannel.image
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(''),
        elevation: 0.0,
        actions: <Widget>[
          AirPlayButton(
            size: SearchPage._iconSize,
            color: Colors.white,
            activeColor: Colors.amber,
            onRoutesOpening: () => print('opening'),
            onRoutesClosed: () => print('closed'),
          ),
          ChromeCastButton(
            size: SearchPage._iconSize,
            color: Colors.white,
            onButtonCreated: _onButtonCreated,
            onSessionStarted: _onSessionStarted,
            onSessionEnded: () => setState((){}),
            onRequestCompleted: _onRequestCompleted,
            onRequestFailed: _onRequestFailed,
          ),
        ],
      ),

      body: Container(
        decoration: BoxDecoration(
        gradient: LinearGradient(
        colors: [fondoColor, startcolor],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
    )),

        height: double.infinity,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(1.0),
              child: TextField(
                style: TextStyle(color: Colors.white70),
                  decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white10, // Color de fondo gris
                      hintText: 'Busqueda de canales', // Texto de sugerencia
                      hintStyle: TextStyle(color: Colors.white70), // Color del texto de sugerencia
                      contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 20), // Espaciado interno
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10), // Bordes redondeados
                        borderSide: BorderSide.none, // Elimina el borde predeterminado
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(1),
                        borderSide: BorderSide(color: Colors.black26), // Borde cuando el TextField está enfocado
                      ),
                    prefixIcon: Icon(
                      Icons.search,
                      color: Colors.white70,
                    ),
                  ),
                onChanged: (query) {
                  // Actualiza la lista de canales según el término de búsqueda
                  setState(() {
                    _futureChannels = filterChannels(query);
                  });
                },
              ),
            ),

            Expanded(
              child: FutureBuilder<List<Channel>>(
                // La tarea asíncrona que quieres realizar
                future: _futureChannels,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    // Muestra un indicador de carga mientras espera
                    return  CupertinoActivityIndicator(animating: true,radius: 15,);
                  } else if (snapshot.hasError) {
                    // Muestra un mensaje de error si la tarea falla
                    return Text('Error: ${snapshot.error}');
                  } else if (!snapshot.hasData || snapshot.data.isEmpty) {
                    // Muestra un mensaje si la lista de canales está vacía
                    return Text('No hay canales disponibles');
                  } else {
                    // Muestra la lista de canales
                    List<Channel> channels = snapshot.data;
                    return ListView.builder(
                      itemCount: channels.length,
                      itemBuilder: (context, index) {
                        return Container(
                          height: (size.height) / 7,
                          width: ((size.width) ) / 4,

                          child: FlatButton(
                            padding: EdgeInsets.all(0),
                            onPressed: () {
                              playerProvider.controller.pause();
                              programmingProvider.selectedChannel = channels[index];
                              playerProvider.changeChannel(channels[index], accessProvider.token);
                              cambiarcanal(channels[index]);
                              playerProvider.controller.pause();
                            },
                            child: Row(
                              children: [
                                // Image inside a blue background container on the right
                                Container(
                                  height: ((size.height) )/ 7,
                                  width: ((size.width) -50) / 3,
                                  decoration: BoxDecoration(
                                    //borderRadius: BorderRadius.circular(14),
                                    color: epgColor,
                                    border: Border.all(
                                      color: Colors.white10,
                                    ),
                                  ),
                                  child: channels[index].image != null
                                      ? ClipRRect(
                                    borderRadius: BorderRadius.circular(5),
                                    child: Image.network(
                                      channels[index].image,
                                      width: (size.width) / 10,
                                      fit: BoxFit.contain,
                                    ),
                                  )
                                      : Container(),
                                ),

                                // Text information inside a blue background container on the left
                                Expanded(
                                  child: Container(
                                    padding: EdgeInsets.all(8.0),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(0),
                                      color: epgColor,
                                      border: Border.all(
                                        color: epgColor,
                                      ),
                                        gradient: LinearGradient(
                                            begin: Alignment.topCenter,
                                            end:Alignment.bottomCenter,
                                            colors: [
                                              startcolor,
                                              epgColor

                                            ]
                                        )
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [

                                        Text(
                                          '${channels[index].number} | ${channels[index].name} ',
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 3,
                                          style: TextStyle(fontSize: 16, color: Colors.white),
                                        ),
                                        SizedBox(height: 8.0),

                                        Text(
                                          'Descripción: ${channels[index].description}',
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 3,
                                          style: TextStyle(fontSize: 14, color: Colors.white54),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );

                  }
                },
              ),
            ),
          /*  Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: MiniPlayer2(),
            )*/
          ],
        )
      ),
      bottomNavigationBar: BottomNavigationBar(
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
        currentIndex: 1,
        selectedItemColor: theme.primaryColor,
        unselectedItemColor: Colors.grey,
        onTap: handleSelectTab,
      ),

    );

  }
}
