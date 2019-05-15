import 'package:flutter/material.dart';

class BackgroundOverlay extends StatelessWidget {
  
  final Color _color;
  final String _imagePath;

  BackgroundOverlay(this._color, this._imagePath);

  @override
  Widget build(BuildContext context) {
    return Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(_imagePath),
                fit: BoxFit.cover,
              )
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              gradient: LinearGradient(
                begin: FractionalOffset.topCenter,
                end: FractionalOffset.bottomCenter,
                colors: [
                  _color.withOpacity(0.5),
                  _color,
                ],
                stops: [
                  0.0,
                  0.5
                ])),
          ),
        ]
    );
  }
}
