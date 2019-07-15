import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:yakosa/components/promotions_map/promotion_page.dart';
import 'package:yakosa/models/promotion.dart';
import 'package:yakosa/utils/utils.dart';

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
      onTap: () => Navigator.push(
            context,
            CupertinoPageRoute(
              builder: (context) => PromotionPage(promotion),
            ),
          ),
      child: Container(
          height: 140,
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Container(
                  height: 100,
                  margin: EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    image: promotion.product.info.image_url != null
                        ? DecorationImage(
                            fit: BoxFit.cover,
                            image:
                                NetworkImage(promotion.product.info.image_url),
                          )
                        : null,
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
                        child: Text(promotion.promotion.toString() + "€",
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
                      child: Text(
                          getVisibleString(
                              30, promotion.product.info.product_name_fr ?? ""),
                          style: TextStyle(fontSize: 15))),
                ),
              )
            ],
          )),
    );
  }
}
