import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:tv_streaming/constants.dart';
import 'package:tv_streaming/models/category.dart';
import 'package:tv_streaming/models/channel.dart';

Future<ChannelsResponse> getChannelsCall(token) async {
  try {
    final response = await http.get(
      Uri.parse('$baseUrl/channels/'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    final Map<String, dynamic> decodedData =
        json.decode(utf8.decode(response?.bodyBytes));
    print("aqui");
    print(decodedData);
    ChannelsResponse output = new ChannelsResponse.fromJson(decodedData);
    return output;
  } catch (error) {
    return ChannelsResponse(code: '-1', message: 'Error interno');
  }
}

Future<ChannelsResponse> getFilteredChannelsCall(token, category) async {
  try {
    final response = await http.get(
      Uri.parse(category != null
          ? '$baseUrl/channels?category=$category'
          : '$baseUrl/channels/'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    final body = json.decode(utf8.decode(response?.bodyBytes));
    print(body);
    final output = ChannelsResponse.fromJson(body);
    return output;
  } catch (error) {
    return ChannelsResponse(code: '-1', message: 'Error interno');
  }
}

class ChannelsResponse {
  final List<Channel> channels;
  final List<Category> categories;
  final String code;
  final String message;

  ChannelsResponse({
    this.channels,
    this.code,
    this.message,
    this.categories,
  });

  factory ChannelsResponse.fromJson(Map<String, dynamic> json) =>
      ChannelsResponse(
        channels: json['channels'] != null
            ? json['channels'].map<Channel>((item) {
                final channel = Channel.fromJson(item);
                print(channel.programs.toString());
                return channel;
              }).toList()
            : null,
        categories: json['categories'] != null
            ? json['categories'].map<Category>((item) {
                final category = Category.fromJson(item);
                return category;
              }).toList()
            : null,
        message: json['message'],
        code: json['code'],
      );

  String toString() => '$code,  $message';
}
