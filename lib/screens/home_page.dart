import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
@override
  State<StatefulWidget> createState() {
    return HomePageState();
  }
}

class HomePageState extends State<HomePage> {

  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFFFFF),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text("Connected"),
            FlatButton(onPressed: signOut,
              child: Text("Sign Out", style: TextStyle(fontSize: 25)),
              color: Colors.black87, textColor: Colors.white),
          ],
        ),
      ),
    );
  }

  signOut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('refresh');
    await prefs.remove('googleId');

    GoogleSignIn googleSignIn = GoogleSignIn();
    await googleSignIn.signOut();
    Navigator.pushReplacementNamed(context, '/login');
  }
}