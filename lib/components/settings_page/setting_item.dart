
import 'package:flutter/cupertino.dart';

typedef Future<void> Callback();

class SettingItem extends StatefulWidget {
  final String _label;
  final String value;

  final bool hasAction;
  final Function action;

  SettingItem(this._label, {this.value, this.hasAction = false, this.action});

  @override
  State<StatefulWidget> createState() => SettingItemState();
}

class SettingItemState extends State<SettingItem> {
  bool pressed = false;

  @override
  Widget build(BuildContext context) {
    final List<Widget> row = [];
    
    row.add(
      Expanded(
        child: Padding(
          padding: EdgeInsets.only(
            left: 15,
            top: 1.5,
          ),
          child: Text(widget._label)
        ),
      )
    );

    final List<Widget> rightRow = [];
    if (widget.value != null) {
      rightRow.add(
        Padding(
          padding: EdgeInsets.only(
            top: 1.5,
            left: 2.25
          ),
          child: Text(widget.value, style: TextStyle(color: CupertinoColors.inactiveGray)),
        )
      );
    }

    if (widget.hasAction) {
      rightRow.add(
        Padding(
          padding: EdgeInsets.only(
            top: 0.5,
            left: 2.25,
          ),
          child: Icon(
            CupertinoIcons.forward,
            color: Color(0xFFC7C7CC),
            size: 21,
          )
        )
      );
    }

    rightRow.add(
      Padding(
        padding: EdgeInsets.only(right: 8.5)
      )
    );

    row.add(
      Row(
        children: rightRow,
      )
    );

    return AnimatedContainer(
      duration: Duration(milliseconds: 200),
      color: this.pressed ? Color(0xFFD9D9D9) : Color(0x00FFFFFF),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          if (widget.action != null) {
            setState(() { pressed = true; });
            widget.action().whenComplete(() {
              Future.delayed(
                Duration(milliseconds: 150),
                () { setState(() { pressed = false; }); },
              );
            });
          }
        },
        child: SizedBox(
          height: 44.0,
          child: Row(
            children: row,
          )
        )
      )
    );
  }
}