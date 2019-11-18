import 'dart:ui';

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
    final String name = product.product.info.product_name_fr ?? "No name";
    final String quantity =
        product.quantity != null ? product.quantity.toString() : "0";
    return GestureDetector(
      onTap: onPressed,
      child: Container(
          height: 140,
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Container(
                  height: 100,
                  margin: EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(product.product.info.image_url),
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    boxShadow: [
                      BoxShadow(
                          color: Color(0x40000000),
                          blurRadius: 5,
                          spreadRadius: 2)
                    ],
                  ),
                  child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.7),
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      child: Center(
                          child: Padding(
                        padding: EdgeInsets.only(bottom: 20),
                        child: Text(quantity,
                            style: TextStyle(
                                fontSize: 40,
                                fontWeight: FontWeight.bold,
                                color: Colors.white)),
                      )))),
              Positioned(
                bottom: 0,
                child: Container(
                  height: 40,
                  width: MediaQuery.of(context).size.width * 0.7,
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    boxShadow: [
                      BoxShadow(
                          color: Color(0x40000000),
                          blurRadius: 5,
                          spreadRadius: 2)
                    ],
                  ),
                  child: Center(
                      child: Text(name,
                          style: TextStyle(fontSize: 15),
                          overflow: TextOverflow.ellipsis)),
                ),
              )
            ],
          )),
    );
  }
}
