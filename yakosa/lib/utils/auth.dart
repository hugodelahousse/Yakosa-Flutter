import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:yakosa/screens/login_page.dart';
import 'package:yakosa/utils/api.dart';

class Auth {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
    ],
  );

  final LoginPageState _instance;

  Auth(this._instance);

  listenLogin(BuildContext context) {
    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount account) async {
      if (account != null) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        if (prefs.getString('token') == null || prefs.getString('token').length < 100) {
          try {
            var auth = await account.authentication;
            var server = await Api.getTokenWithGoogleToken(auth.idToken);
            if (server.statusCode == 200) {
              var jsonResponse = await json.decode(server.body);
              await prefs.setString('token', jsonResponse['token']);
              await prefs.setString('refresh', jsonResponse['refresh']);
              await prefs.setString('googleId', jsonResponse['googleId']);
              _instance.isLoading =  false;
              Navigator.pushNamed(context, '/home');
            }
          } catch (error) {
            print('Authentication request failed : ' + error.toString());
            await signOut();
            _showErrorDialog(context);
          }
        } else {
          _instance.isLoading =  false;
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
    _instance.isLoading =  false;
  }

  googleConnect() async {
    try {
      GoogleSignInAccount account = await _googleSignIn.signIn();
      if (account == null)
        _instance.isLoading = false;
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