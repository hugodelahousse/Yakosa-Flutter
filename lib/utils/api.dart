import 'dart:convert';

import 'package:http/http.dart' as http;

class Api {

  static String baseUrl = "http://yakosa.herokuapp.com";

  static String getUrl() {
    return baseUrl + '/';
  }

  static Future<http.Response> getTokenWithGoogleToken(String googleToken) async {
    return await http.get(getUrl() + 'auth/google/token?access_token=' + googleToken);
  }

  static Future<http.Response> getNewToken(String token) async {
    return await http.post(getUrl() + 'auth/token/refresh', headers: {'Content-Type': 'application/json; charset=utf-8'}, body: json.encode({'refresh_token': token}));
  }
}