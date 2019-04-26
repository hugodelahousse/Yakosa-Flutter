import 'package:flutter/material.dart';

class SignInButton extends StatelessWidget {
  
  final String _text;
  final Color _backgroundColor;
  final Color _textColor;
  final Function _onPressed;

  SignInButton(this._text, this._backgroundColor, this._textColor, this._onPressed);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.9, // match_parent
      child: RaisedButton(
        color: _backgroundColor,
        padding: const EdgeInsets.symmetric(vertical: 15),
        child: Text(_text,
          style: TextStyle(
            fontFamily: 'SF Pro Text', 
            fontWeight: FontWeight.w100, 
            color: _textColor, fontSize: 20, )), 
            onPressed: _onPressed, 
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0))),
    );
  }
}
