import 'package:http/http.dart' as http;

class Api {

  static String baseUrl = "https://yakosa.herokuapp.com";

  static String getUrl() {
    return baseUrl + '/';
  }

  static Future<http.Response> getTokenWithGoogleToken(String googleToken) async {
    return await http.get(getUrl() + 'auth/google/token?access_token=' + googleToken);
  }
}