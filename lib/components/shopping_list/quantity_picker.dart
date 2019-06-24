import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:yakosa/models/graphql.dart';

class QuantityPicker extends StatefulWidget {
  final ListProduct product;
  final ValueChanged<int> onUpdateQuantity;

  QuantityPicker({
    this.product,
    this.onUpdateQuantity,
  });

  @override
  State<StatefulWidget> createState() => _QuantityPickerState(
      product,
      onUpdateQuantity,
  );
}

class _QuantityPickerState extends State<QuantityPicker> {
  ListProduct _product;
  int _currentQuantity;
  ValueChanged<int> _onUpdateQuantity;

  _QuantityPickerState(this._product, this._onUpdateQuantity) {
    _currentQuantity = this._product.quantity;
  }

  static const Color _color = const Color(0xff9c88ff);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: EdgeInsets.all(20),
          child: Text(
            _product.product.info.product_name_fr,
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.remove_circle_outline, color: _color,),
              onPressed: _decreaseQuantity,
            ),
            Text(
              _currentQuantity.toString(),
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18),
            ),
            IconButton(
              icon: Icon(Icons.add_circle_outline, color: _color,),
              onPressed: _increaseQuantity,
            )
          ],
        ),
        Divider(height: 0,),
        FlatButton(
          child: _currentQuantity > 0 ?
          Text(
            'Update',
            style: TextStyle(color: _color),
          ) : Text(
            'Remove',
            style: TextStyle(color: const Color(0xffff4118)),
          ),
          onPressed: () => _onUpdateQuantity(_currentQuantity),
        ),
      ]
    );
  }

  void _decreaseQuantity() {
    setState(() {
      _currentQuantity = max(0, _currentQuantity - 1);
    });
  }

  void _increaseQuantity() {
    setState(() {
      _currentQuantity += 1;
    });
  }
}
