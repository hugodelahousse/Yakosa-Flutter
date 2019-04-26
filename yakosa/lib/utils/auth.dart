import 'dart:convert';

import 'package:flutter/cupertino.dart';
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
        if (prefs.getString('token') == null || prefs.getString('token').length < 100) {
          try {
            var auth = await account.authentication;
            var server = await http.get('http://localhost:3000/auth/google/token?access_token=' + auth.idToken);
            if (server.statusCode == 200) {
              var jsonResponse = await json.decode(server.body);
              await prefs.setString('token', jsonResponse['token']);
              await prefs.setString('refresh', jsonResponse['refresh']);
              await prefs.setString('googleId', jsonResponse['googleId']);
              Navigator.pushNamed(context, '/home');
            }
          } catch (error) {
            print('Authentication request failed : ' + error.toString());
            await signOut();
            _showErrorDialog(context);
          }
        } else {
          Navigator.pushNamed(context, '/home');
        }
      }
    });
    try {
      _googleSignIn.signInSilently();
    } catch (error) {
      print('Google Sign in silenty failed : ' + error.toString());
    }
  }

  signOut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('refresh');
    await prefs.remove('googleId');
    _googleSignIn.signOut();
  }

  googleConnect() async {
    try {
      await _googleSignIn.signIn();
    } catch (error) {
      print('Google Sign in request failed : ' + error.toString());
      await signOut();
    }
  }

  facebookConnect() {
    print("FACEBOOK CONNECT");
  }  

  _showErrorDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return new CupertinoAlertDialog(
          title: new Text("Login failed"),
          content: new Text("Network error : Please retry later"),
          actions: <Widget>[
            CupertinoDialogAction(
              isDefaultAction: true,
              onPressed: () => Navigator.of(context).pop(),
              child: Text("OK"),
            ),
        ]);
      }
    );
  }
}