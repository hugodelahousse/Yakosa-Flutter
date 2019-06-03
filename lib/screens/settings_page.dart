import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yakosa/utils/size_config.dart';

class SettingsPage extends StatefulWidget {
@override
  State<StatefulWidget> createState() {
    return SettingsPageState();
  }
}

class SettingsPageState extends State<SettingsPage> {

  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFEEEEEE),
      body: SafeArea(
        child: Container(
          color: Color(0xFFEEEEEE),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(padding: EdgeInsets.only(left: 15.0, top: 20.0, bottom: 10.0),child: Text("Settings", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25.0, color: Colors.black))),
              SizedBox(child: FlatButton(color: Colors.white, child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text("Delete account"),
                  Icon(Icons.arrow_right)
              ],), onPressed: () {}), width: double.infinity,),
            ],
          )
        )
      )
    );
  }
}