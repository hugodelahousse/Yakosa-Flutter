import 'package:flutter/cupertino.dart';

class SettingsGroup extends StatelessWidget {
  final List<Widget> _items;
  final Widget label;

  SettingsGroup(this._items, { this.label });

  @override
  Widget build(BuildContext context) {
    final List<Widget> dividedItems =_items.map<Widget>((item) {
      if (_items.last == item) {
        return item;
      }
      return Stack(
        children: <Widget>[
          Positioned(
            bottom: 0,
            right: 0,
            left: 15,
            child: Container(
              color: Color(0xFFBCBBC1),
              height: 0.3,
            ),
          ),
          item
        ],
      );
    }).toList();

    final List<Widget> itemsGroup = [];

    if (this.label != null) {
      itemsGroup.add(
        DefaultTextStyle(
          style: TextStyle(
            color: CupertinoColors.inactiveGray,
            fontSize: 13.5,
            letterSpacing: -0.5,
          ),
          child: Padding(
            padding: EdgeInsets.only(
              left: 15.0,
              right: 15.0,
              bottom: 6.0,
            ),
            child: this.label,
          ),
        )
      );
    }

    itemsGroup.add(
      Container(
        decoration: BoxDecoration(
          color: CupertinoColors.white,
          border: Border(
            top: const BorderSide(
              color: Color(0xFFBCBBC1),
              width: 0.0,
            ),
            bottom: const BorderSide(
              color: Color(0xFFBCBBC1),
              width: 0.0,
            ),
          )
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: dividedItems,
        ),
      )
    );

    return Padding(
      padding: EdgeInsets.only(
        top: this.label == null ? 35 : 22,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: itemsGroup,
      ),
    );
  }
}