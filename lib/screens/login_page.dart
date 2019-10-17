import 'package:flutter/material.dart';

import 'package:yakosa/components/login_page/background_overlay.dart';
import 'package:yakosa/components/login_page/logo.dart';
import 'package:yakosa/components/login_page/login_slider.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';

import 'package:yakosa/utils/auth.dart';

class LoginPage extends StatefulWidget {
@override
  State<StatefulWidget> createState() {
    return LoginPageState();
  }
}

class LoginPageState extends State<LoginPage> {

  Auth auth;
  bool _isLoading = false;
  set isLoading(bool value) {
    this.setState(() => _isLoading = value);
  }

  void initState() {
    super.initState();
    auth = Auth(this);
    auth.listenLogin(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF780B7C),
      resizeToAvoidBottomPadding: false,
      body: Stack(
        children: <Widget>[
          BackgroundOverlay(Color(0xFF780B7C), 'assets/images/yakosa_login.jpg'),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Logo(100, 'assets/images/yakosa_logo.png'),
                LoginSlider(),
                SizedBox(
                  width: 32,
                  height: 32,
                  child: _isLoading ? 
                    CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.white),)
                    : Container(),
                ),
                SizedBox(
                  width: 300,
                  child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    GoogleSignInButton(text: 'Sign in with Google', onPressed: _googleConnect,),
                    Divider(height: 10,),
                    FacebookSignInButton(text: 'Sign in with Facebook', onPressed: _facebookConnect,),
                  ]
                ),
                )
              ],
            ),
        ),
        ],
      ),
      );
  }

  _googleConnect() {
    isLoading = true;
    auth.googleConnect();
  }

  _facebookConnect() {
    isLoading = true;
    auth.facebookConnect();
  }
}