import 'dart:convert';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:better_player/better_player.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tv_streaming/constants.dart';
import 'package:tv_streaming/models/channel.dart';
import 'package:http/http.dart' as http;

class PlayerProvider extends ChangeNotifier {
  BetterPlayerController _controller;
  BetterPlayerDataSource _dataSource;

  void initializeController() {
    _controller = BetterPlayerController(
      BetterPlayerConfiguration(
        fit: BoxFit.contain,
        handleLifecycle: true,
        autoPlay: true,
        autoDispose: false,
        deviceOrientationsOnFullScreen: [DeviceOrientation.landscapeLeft],
        controlsConfiguration: BetterPlayerControlsConfiguration(
            showControlsOnInitialize: false,
            enableSkips: false,
            enablePlayPause: false),
      ),
    );
  }

  void setChannel(Channel channel) {
    _dataSource = BetterPlayerDataSource(
      BetterPlayerDataSourceType.network,
      channel.stream,
      liveStream: true,
    );
    _controller = BetterPlayerController(
      BetterPlayerConfiguration(
        fit: BoxFit.contain,
        handleLifecycle: true,
        autoPlay: true,
        autoDispose: false,
        deviceOrientationsOnFullScreen: [DeviceOrientation.landscapeLeft],
        controlsConfiguration: BetterPlayerControlsConfiguration(
          showControlsOnInitialize: false,
          enableSkips: false,
          enablePlayPause: false,
        ),
      ),
      betterPlayerDataSource: _dataSource,
    );
  }

  void changeChannel(Channel channel, String token) async {
    String marca;
    String modelo;

    _dataSource = BetterPlayerDataSource(
      BetterPlayerDataSourceType.network,
      channel.stream,
      liveStream: true,
    );
    _controller.pause();
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      marca = androidInfo.brand;
      modelo = androidInfo.model;
      // Android-specific code
    } else if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      marca = iosInfo.utsname.machine;
      modelo = iosInfo.model;
      // iOS-specific code
    }

    try {
      _controller.setupDataSource(_dataSource);
    } catch (e) {
      print(e);
    }
    try {
      final url = '$baseUrl/channels/track/';
      var resp = await http.post(Uri.parse(url),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode(<String, String>{
            'channel': '${channel.id}',
            'deviceapp': 'movil',
            'modelo': '${marca} - ${modelo}'
          }));
    } catch (e) {}
  }

  void disposePlayer() {
    _controller.dispose(forceDispose: true);
  }

  BetterPlayerController get controller => _controller;
  BetterPlayerDataSource get dataSource => _dataSource;
}
