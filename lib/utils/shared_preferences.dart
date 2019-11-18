import 'package:shared_preferences/shared_preferences.dart';

class LocalPreferences {
  static Future<bool> contains(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(key);
  }

  static Future<String> getString(String key, String _default) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(key) ? prefs.get(key) : _default;
  }

  static Future<bool> getBool(String key, bool _default) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(key) ? prefs.getBool(key) : _default;
  }

  static Future<int> getInt(String key, int _default) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(key) ? prefs.getInt(key) : _default;
  }

  static Future<List<String>> getStringList(
      String key, List<String> _default) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(key) ? prefs.getStringList(key) : _default;
  }

  static Future<bool> setBool(String key, bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setBool(key, value);
  }

  static Future<bool> setString(String key, String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(key, value);
  }

  static Future<bool> setInt(String key, int value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setInt(key, value);
  }

  static Future<bool> setStringList(String key, List<String> value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setStringList(key, value);
  }
}
