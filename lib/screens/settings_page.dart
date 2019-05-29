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
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text("Settings", style: TextStyle(color: Colors.black, fontSize: 22.0, fontWeight: FontWeight.bold)),
      ),
      child: SafeArea(
        child: Column(
          children: <Widget>[
          ],
        ),
      )
    );
  }
}