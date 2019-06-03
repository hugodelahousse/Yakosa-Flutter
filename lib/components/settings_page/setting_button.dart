import 'package:flutter/material.dart';
class SettingButton extends StatelessWidget {
  
  final String label;
  final String _text;
  final Function _onPressed;
  final IconData icon;

  SettingButton(this._text, this._onPressed, {this.icon, this.label});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: SizedBox(
        width: double.infinity,
        child: OutlineButton(
          padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
          onPressed: _onPressed,
          color: Colors.white, 
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              label != null ? Padding(padding: EdgeInsets.only(top: 0.0), child: Text(label, style: TextStyle(fontSize: 15.0, color: Colors.grey))) : Center(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(_text, style: TextStyle(color: Colors.black, fontSize: 20.0)),
                  Icon(icon)
                ]),
              ],)
        )
      ),
    );
  }
}
