import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:tv_streaming/api/programming.dart';
import 'package:tv_streaming/models/category.dart';
import 'package:tv_streaming/models/channel.dart';
import 'package:tv_streaming/pages/login_page.dart';

import 'access_provider.dart';

class ProgrammingProvider extends ChangeNotifier {
  bool _isGettingProgrammingGuide = false;
  List<Channel> _programmingGuide = [];
  List<Channel> _fijo = [];
  List<Category> _categories = [];
  Channel _selectedChannel;

  Future<List<Channel>> getProgrammingGuide(BuildContext context) async {
    final accessProvider = Provider.of<AccessProvider>(context, listen: false);

    final ChannelsResponse channelsResponse =
    await getChannelsCall(accessProvider.token);

    _programmingGuide = channelsResponse.channels;
    _categories = channelsResponse.categories;
    _selectedChannel = programmingGuide.first;
    if (channelsResponse.code == 'Forbidden') {
      accessProvider.logout(accessProvider.token);
      Navigator.pushReplacementNamed(context, LoginPage.routeName);
    }

    notifyListeners();
    return _programmingGuide;
  }
  Future<List<Channel>> getProgrammingGuidetotal(BuildContext context) async {
    final accessProvider = Provider.of<AccessProvider>(context, listen: false);

    final ChannelsResponse channelsResponse =
    await getChannelsCall(accessProvider.token);

    _fijo = channelsResponse.channels;
    if (channelsResponse.code == 'Forbidden') {
      accessProvider.logout(accessProvider.token);
      Navigator.pushReplacementNamed(context, LoginPage.routeName);
    }

    notifyListeners();
    return _fijo;
  }

  Future<List<Channel>> getChannelsByCategory(
      BuildContext context, String category) async {
    final accessProvider = Provider.of<AccessProvider>(context, listen: false);
    _isGettingProgrammingGuide = true;
    notifyListeners();
    final ChannelsResponse channelsResponse =
    await getFilteredChannelsCall(accessProvider.token, category);

    _programmingGuide = channelsResponse.channels;
    _isGettingProgrammingGuide = false;

    if (channelsResponse.code == 'Forbidden') {
      accessProvider.logout(accessProvider.token);
      Navigator.pushReplacementNamed(context, LoginPage.routeName);
    }

    notifyListeners();
    return _programmingGuide;
  }

  bool get isGettingProgrammingGuide => _isGettingProgrammingGuide;
  List<Channel> get programmingGuide => _programmingGuide;
  List<Channel> get programmingGuidetotal => _fijo;
  List<Category> get categories => _categories;
  Channel get selectedChannel => _selectedChannel;

  set selectedChannel(channel) {
    _selectedChannel = channel;
    notifyListeners();
  }
}
