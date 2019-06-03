import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:yakosa/models/product.dart';

class ProductTile extends StatelessWidget {
  final ListProduct _product;

  ProductTile(this._product);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Image.network(
        _product.product.info.image_url,
        width: 100,
        height: 100,
        fit: BoxFit.fitHeight,
      ),
      title: Text(
          _product.product.info.product_name_fr,
          style: TextStyle(fontWeight: FontWeight.bold),
      ),
      trailing: Text('${_product.quantity}'),
    );
  }
}