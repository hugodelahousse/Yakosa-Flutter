import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:yakosa/models/product.dart';

class ProductTile extends StatelessWidget {
  final ListProduct product;
  final VoidCallback onPressed;

  ProductTile({
    @required this.product,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return new GestureDetector(
      onTap: onPressed,
        child: ListTile(
          leading: Image.network(
            product.product.info.image_url,
            width: 100,
            height: 100,
            fit: BoxFit.fitHeight,
          ),
          title: Text(
            product.product.info.product_name_fr,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          trailing: Text('${product.quantity}x'),
        )
    );
  }
}