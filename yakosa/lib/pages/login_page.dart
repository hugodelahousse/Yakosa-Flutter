import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:carousel_slider/carousel_slider.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:yakosa/components/slide_item.dart';

class LoginPage extends StatefulWidget {
@override
  State<StatefulWidget> createState() {
    return LoginPageState();
  }
}

class LoginPageState extends State<LoginPage> {
  int _currentSlide = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF780B7C),
      body: new Stack(
        children: <Widget>[
        new Container(
          decoration: new BoxDecoration(
            image: new DecorationImage(
              image: new AssetImage('assets/images/yakosa_login.jpg'),
              fit: BoxFit.cover,
            )
          ),
        ),
        new Container(
          decoration: BoxDecoration(
            color: Colors.white,
            gradient: LinearGradient(
              begin: FractionalOffset.topCenter,
              end: FractionalOffset.bottomCenter,
              colors: [
                Color(0xFF780B7C).withOpacity(0.5),
                Color(0xFF780B7C),
              ],
              stops: [
                0.0,
                0.5
              ])),
        ),
        new Center(
          child: Column(//FIXME: Alignement : Space between instead of hard coded values
            children: <Widget>[
              new Padding(padding: const EdgeInsets.only(top: 100)),
              Image.asset('assets/images/yakosa_logo.png', height: 100,),
              new Text("YAKOSA", style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 75, fontFamily: 'SF Pro Display', color: Color.fromARGB(255, 255, 255, 255)),),
              new Padding(padding: const EdgeInsets.only(top: 40)),
              CarouselSlider(
                height: 160,
                enlargeCenterPage: true,
                autoPlay: false,
                items: <Widget>[
                  new SlideItem("Fill your shopping list", "Add your all your products prefereneces within the app in a few touches"),
                  new SlideItem("Find near promotions", "Your nearly grocery shops will list every promotions related to your shopping list"),
                  new SlideItem("Follow the guide", "YAKOSA provides you with an intelligent shops itinerary for the cheapest basket")
                  ],
                onPageChanged: (index) {
                  setState(() {
                    _currentSlide = index;
                  });
                },
              ),
              new Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [0,1,2].map((i) {
                    return Builder(
                      builder: (BuildContext context) {
                        return Container(
                          width: 10.0,
                          height: 10.0,
                          margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 5.0),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _currentSlide == i ? Color.fromRGBO(0, 0, 0, 0.8) : Color.fromRGBO(255, 255, 255, 1)
                          ),
                    );
                  });
                  }).toList(),),
              new Padding(padding: EdgeInsets.only(top: 10),),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.9, // match_parent
                child: new RaisedButton(color: const Color(0xFFF3465B), padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 75),child: new Text("Sign in with Google", style: new TextStyle(fontFamily: 'SF Pro Text', fontWeight: FontWeight.w100, color: const Color(0xFFFFFFFF), fontSize: 20, )), onPressed: _googleConnect, shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(10.0))),
              ),
              new Padding(padding: EdgeInsets.only(top: 10),),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.9, // match_parent
                child: new RaisedButton(color: const Color(0xFF3A5997), padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 75),child: new Text("Sign in with Facebook", style: new TextStyle(fontFamily: 'SF Pro Text', fontWeight: FontWeight.w100, color: const Color(0xFFFFFFFF), fontSize: 20, )), onPressed: _facebookConnect, shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(10.0)))
              ),
            ],
          ),
        ),
        ],
      ),
      );
  }

  void initState() {
    initLogin();
  }

  GoogleSignIn _googleSignIn = new GoogleSignIn(
    scopes: [
      'email',
    ],
  );

  initLogin() {
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

  void _googleConnect() async {
    await _googleSignIn.signIn();
  }

  void _facebookConnect() {
    print("FACEBOOK CONNECT");
  }
}