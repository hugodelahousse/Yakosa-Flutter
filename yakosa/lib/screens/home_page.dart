import 'package:flutter/material.dart';

class HomePage extends StatelessWidget{
  @override Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFFFFF),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text("Connected"),
          ],
        ),
      ),
    );
  }

}