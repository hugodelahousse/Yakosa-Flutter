import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Auth {
    final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
    ],
  );

  listenLogin(BuildContext context) {
    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount account) async {
      if (account != null) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        if (prefs.getString('token') == null || prefs.getString("token").length < 100) {
          var auth = await account.authentication;
          var server = await http.get("http://localhost:3000/auth/google/token?access_token=" + auth.idToken);
          if (server.statusCode == 200) {
            var jsonResponse = await json.decode(server.body);
            await prefs.setString('token', jsonResponse['token']);
            await prefs.setString('refresh', jsonResponse['refresh']);
            await prefs.setString('googleId', jsonResponse['googleId']);
            Navigator.pushNamed(context, '/home');
          }
        } else {
          Navigator.pushNamed(context, '/home');
        }
      }
    });
    _googleSignIn.signInSilently();
  }

  signOut() {
    _googleSignIn.signOut();
  }

  googleConnect() async {
    await _googleSignIn.signIn();
  }

  facebookConnect() {
    print("FACEBOOK CONNECT");
  }  
}