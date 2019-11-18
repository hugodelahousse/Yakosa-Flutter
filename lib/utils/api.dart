import 'dart:convert';
import 'package:http/http.dart' as http;

class Api {
  static String baseUrl = 'https://yakosa.herokuapp.com';

  static String getUrl() {
    return baseUrl + '/';
  }

  static Future<http.Response> getTokenWithGoogleToken(
      String googleToken) async {
    return await http
        .get(getUrl() + 'auth/google/token?access_token=' + googleToken);
  }

  static Future<http.Response> getNewToken(String token) async {
    return await http.post(getUrl() + 'auth/token/refresh',
        headers: {'Content-Type': 'application/json; charset=utf-8'},
        body: json.encode({'refresh_token': token}));
  }

  static Future<http.Response> searchProducts(String terms) async {
    return await http.get(
        'https://world.openfoodfacts.org/cgi/search.pl?search_terms=$terms&search_simple=1&action=process&json=1&page_size=40&sort_by=unique_scan_n',
        headers: {'User-Agent': 'Yakosa - IOS - Version 1.0'});
  }

  static Future<http.Response> searchBarcode(String barcode) async {
    return await http.get(
        'https://world.openfoodfacts.org/api/v0/product/$barcode.json',
        headers: {'User-Agent': 'Yakosa - IOS - Version 1.0'});
  }
}
