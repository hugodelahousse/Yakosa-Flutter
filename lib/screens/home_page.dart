import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:yakosa/utils/size_config.dart';

import 'package:yakosa/components/home_page/big_button.dart';

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
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: Color(0xFFFFFFFF),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.only(top: 20, left: 20, right: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                FlatButton(child: Text("Sign Out"), color: Colors.black, textColor: Colors.white, onPressed: signOut),
                Text("Hello Adrien,", style: TextStyle(fontSize: SizeConfig.blockSizeHorizontal * 10.0, color: Colors.black, fontWeight: FontWeight.bold)),
                Padding(padding: EdgeInsets.all(10)),
                BigButton(SizeConfig.blockSizeVertical * 10.0, SizeConfig.blockSizeHorizontal * 10.0, SizeConfig.blockSizeHorizontal * 5.0, "Shopping Lists", null, colors: [ Color(0xFFFC6076), Color(0xFFFF9944)]),
                Padding(padding: EdgeInsets.all(10)),
                BigButton(SizeConfig.blockSizeVertical * 10.0, SizeConfig.blockSizeHorizontal * 10.0, SizeConfig.blockSizeHorizontal * 5.0, "Promotions", null, colors: [ Color(0xFF30D2BE), Color(0xFF473B7B)]),
                Padding(padding: EdgeInsets.all(10)),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: BigButton(SizeConfig.blockSizeVertical * 2.0, SizeConfig.blockSizeHorizontal * 8.0, SizeConfig.blockSizeHorizontal * 3.0, "Account", null, colors: [ Colors.grey, Colors.grey.withOpacity(0.5)]),
                    ),
                    Padding(padding: EdgeInsets.all(5)),
                    Expanded(
                      child: BigButton(SizeConfig.blockSizeVertical * 2.0, SizeConfig.blockSizeHorizontal * 8.0, SizeConfig.blockSizeHorizontal * 3.0,"Settings", () => Navigator.pushNamed(context, "/settings")),
                    ),
                  ]
                ),
                Padding(padding: EdgeInsets.all(10)),
              ],
            )
          )
        )
      )
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