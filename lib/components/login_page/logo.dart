import 'package:flutter/material.dart';

class Logo extends StatelessWidget {
  final double _size;
  final String _imagePath;

  Logo(this._size, this._imagePath);

  @override
  Widget build(BuildContext context) {
    return Column(
        //FIXME: Alignement : Space between instead of hard coded values
        children: <Widget>[
          Image.asset(
            _imagePath,
            height: _size,
          ),
          Text(
            "YAKOSA",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 0.75 * _size,
                fontFamily: 'SF Pro Display',
                color: Color.fromARGB(255, 255, 255, 255)),
          ),
        ]);
  }
}
