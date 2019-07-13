import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:yakosa/models/promotion.dart';

class PromotionItem extends StatelessWidget {
  final Promotion promotion;
  final String store;

  PromotionItem({
    @required this.promotion,
    @required this.store,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => print("pressed"),
      child: Container(
        height: 140,
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Container(
              height: 100,
              margin: EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                color: Colors.redAccent,
                borderRadius: BorderRadius.all(Radius.circular(10)),
                boxShadow: [BoxShadow(color: Color(0x40000000), blurRadius: 5, spreadRadius: 2)],
              ),
            ),
            Positioned(
              bottom: 0,
              child: Container(
                height: 40,
                width: MediaQuery.of(context).size.width * 0.7,
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  boxShadow: [BoxShadow(color: Color(0x40000000), blurRadius: 5, spreadRadius: 2)],
                ),
                child: Center(child: Text(promotion.brand.name, style: TextStyle(fontSize: 15))),
              ),
            )
          ],
        )
      ),
    );
  }
}