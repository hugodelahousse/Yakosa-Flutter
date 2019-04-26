import 'package:flutter/material.dart';

import 'package:yakosa/components/login_page/background_overlay.dart';
import 'package:yakosa/components/login_page/logo.dart';
import 'package:yakosa/components/login_page/login_slider.dart';
import 'package:yakosa/components/login_page/sign_in_button.dart';

import 'package:yakosa/utils/auth.dart';

class LoginPage extends StatefulWidget {
@override
  State<StatefulWidget> createState() {
    return LoginPageState();
  }
}

class LoginPageState extends State<LoginPage> {

  final Auth auth = Auth();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF780B7C),
      body: Stack(
        children: <Widget>[
          BackgroundOverlay(Color(0xFF780B7C), 'assets/images/yakosa_login.jpg'),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Logo(100, 'assets/images/yakosa_logo.png'),
                LoginSlider(),
                new Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                  SignInButton("Sign in with Google", Color(0xFFF3465B), Color(0xFFFFFFFF), auth.googleConnect),
                  Padding(padding: EdgeInsets.only(top: 10),),
                  SignInButton("Sign in with Facebook", Color(0xFF3A5997), Color(0xFFFFFFFF), auth.facebookConnect),
                  ]
                )
              ],
            ),
        ),
        ],
      ),
      );
  }

  void initState() {
    super.initState();
    auth.signOut();
    auth.listenLogin(context);
  }
}