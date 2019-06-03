import 'package:flutter/material.dart';
import 'package:yakosa/utils/size_config.dart';

class SettingButton extends StatelessWidget {
  
  final String _text;
  final Function _onPressed;
  final IconData icon;

  SettingButton(this._text, this._onPressed, {this.icon});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Center(
        child: SizedBox(
          width: SizeConfig.screenWidth * 0.90,
          child: RaisedButton(
            shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(5.0)),
            color: Colors.white, 
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(_text),
                Icon(icon)
              ]),
              onPressed: _onPressed
          )
        ),
      )
    );
  }
}
