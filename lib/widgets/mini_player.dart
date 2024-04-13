import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tv_streaming/providers/player_provider.dart';
import 'package:tv_streaming/providers/programming_provider.dart';

class MiniPlayer extends StatefulWidget {
  const MiniPlayer({Key key}) : super(key: key);

  @override
  _MiniPlayerState createState() => _MiniPlayerState();
}

class _MiniPlayerState extends State<MiniPlayer> {
  @override
  void initState() {
    super.initState();
    final playerProvider = Provider.of<PlayerProvider>(context, listen: false);
    playerProvider.controller.setControlsEnabled(false);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final playerProvider = Provider.of<PlayerProvider>(context);
    final programmingProvider = Provider.of<ProgrammingProvider>(context);
    final theme = Theme.of(context);

    return FlatButton(
      padding: EdgeInsets.all(0),
      onPressed: () {
        Navigator.popUntil(context, (Route route) => route.isFirst);
      },
      child: Container(
        height: 100,
        width: double.infinity,
        child: Stack(
          children: [
            Positioned(
              top: 0,
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: EdgeInsets.only(left: 200, top: 20),
                width: double.infinity,
                height: 100,
                color: Colors.grey[900],
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      programmingProvider.selectedChannel.number,
                      style: theme.primaryTextTheme.headline6,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      programmingProvider.selectedChannel.name,
                      style: theme.primaryTextTheme.bodyText1,
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 0,
              bottom: 0,
              left: 0,
              child: Container(
                height: 100,
                width: 180,
                color: Colors.grey,
                child: Stack(
                  children: [
                    BetterPlayer(
                      controller: playerProvider.controller,
                    ),
                    Positioned(
                      child: FlatButton(
                        onPressed: () {
                          Navigator.popUntil(
                              context, (Route route) => route.isFirst);
                        },
                        child: Container(
                          height: 100,
                          width: 180,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
