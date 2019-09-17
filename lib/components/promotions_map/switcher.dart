import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Switcher extends StatefulWidget {
  final IconData firstIcon;
  final IconData secondIcon;
  final Function callback;
  final firstSelected;

  Switcher(this.firstIcon, this.secondIcon, this.callback, this.firstSelected);

  _SwitcherState createState() => _SwitcherState();
}

class _SwitcherState extends State<Switcher> {

  void _onPressed() {
    widget.callback();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 55,
      width: 55,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(50)),
        boxShadow: [BoxShadow(color: Color(0x40000000), blurRadius: 5, spreadRadius: 0)],
      ),
      child: IconButton(
        color: Colors.black54,
        icon: Icon(widget.firstSelected ? widget.firstIcon : widget.secondIcon),
        onPressed: _onPressed,
      )
    );
  }
}
