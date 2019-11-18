import 'package:flutter/material.dart';

class BigButton extends StatelessWidget {
  final double _height;
  final double _size;
  final double _borderRadius;
  final List<Color> colors;
  final String _text;
  final Function _onPressed;

  BigButton(
      this._height, this._size, this._borderRadius, this._text, this._onPressed,
      {this.colors});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: _onPressed,
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(_borderRadius)),
              color: Colors.white,
              gradient: colors != null
                  ? LinearGradient(
                      begin: FractionalOffset.bottomLeft,
                      end: FractionalOffset.topRight,
                      colors: colors,
                    )
                  : LinearGradient(colors: [Colors.white, Colors.white]),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 7)
              ]),
          padding: EdgeInsets.symmetric(vertical: _height, horizontal: 10),
          child: Center(
            child: Text(_text,
                style: TextStyle(
                    fontSize: _size,
                    color: colors != null ? Colors.white : Colors.black,
                    fontWeight: FontWeight.w600)),
          ),
        ));
  }
}
