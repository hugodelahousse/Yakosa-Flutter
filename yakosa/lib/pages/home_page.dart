import 'package:flutter/material.dart';

class HomePage extends StatelessWidget{
  @override Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Color(0xFFFFFFFF),
      body: new Center(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            new Text("Connected"),
          ],
        ),
      ),
    );
  }

}