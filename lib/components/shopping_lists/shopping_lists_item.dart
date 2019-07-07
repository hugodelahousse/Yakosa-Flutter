import 'package:flutter/material.dart';
import 'package:yakosa/screens/shopping_list.dart';

class ShoppingListsItem extends StatelessWidget {
  final String _id;
  final Color _color;
  final String _title;
  final int _count;

 ShoppingListsItem(this._id, this._color, this._title, this._count);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: GestureDetector(
        child: Container(
          height: 100,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            color: Colors.orangeAccent,
            boxShadow: [BoxShadow(color: Color(0x40000000), blurRadius: 5, spreadRadius: 2)],
            gradient: LinearGradient(
              begin: FractionalOffset.topLeft,
              end: FractionalOffset.bottomRight,
              colors: [
                _color,
                _color.withRed(180),
              ],
              stops: [
                0.0,
                0.9
              ]),
            ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                width: 100,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Color(0x40000000),
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(10), bottomLeft: Radius.circular(10))
                  ),
                child: Text(_count.toString(), style: TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold))
              ),
              Flexible(
                child: Container(
                  padding: EdgeInsetsDirectional.only(start: 5),
                  child: Text(_title, style: TextStyle(fontWeight: FontWeight.w100, fontSize: 24.0, color: Colors.white)),
                  alignment: Alignment.center,
                )),
              Container(
                child: Icon(Icons.chevron_right, color: Colors.white, size: 40),
                padding: EdgeInsets.only(right: 10),
              ),
            ],
          )
        ),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ShoppingListPage(
            shoppingListId: _id,
          )),
        ),
      )
    );
  }
}