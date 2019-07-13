import 'package:flutter/cupertino.dart';

class Switcher extends StatefulWidget {
  String leftText;
  String rightText;
  Function leftCallback;
  Function rightCallback;

  Switcher(this.leftText, this.rightText, this.leftCallback, this.rightCallback);

  _SwitcherState createState() => _SwitcherState();
}

class _SwitcherState extends State<Switcher> {
  bool leftSelected = true;

  void leftTouch() {
    leftSelected = true;
    widget.leftCallback();
  }

  void rightTouch() {
    leftSelected = false;
    widget.rightCallback();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [BoxShadow(color: Color(0x40000000), blurRadius: 5, spreadRadius: 0)],
      ),
      child: 
        Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
          GestureDetector(
            onTap: leftTouch,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 2, horizontal: 25),
                decoration: BoxDecoration(
                  color: leftSelected ? CupertinoColors.black : CupertinoColors.white,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(8), bottomLeft: Radius.circular(8)),
                ),
                child: Text(widget.leftText, style: TextStyle(fontSize: 18, color: leftSelected ? CupertinoColors.white : CupertinoColors.black)),
              ),
          ),
          GestureDetector(
            onTap: rightTouch,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 2, horizontal: 25),
              decoration: BoxDecoration(
                color: leftSelected ? CupertinoColors.white : CupertinoColors.black,
                borderRadius: BorderRadius.only(topRight: Radius.circular(8), bottomRight: Radius.circular(8)),
              ),
              child: Text(widget.rightText, style: TextStyle(fontSize: 18, color: leftSelected ? CupertinoColors.black : CupertinoColors.white)),
            ),
          )
        ]),
    );
  }
}