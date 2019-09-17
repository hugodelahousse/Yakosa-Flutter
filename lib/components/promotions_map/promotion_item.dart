import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:yakosa/components/promotions_map/promotion_page.dart';
import 'package:yakosa/models/promotion.dart';

class PromotionItem extends StatelessWidget {
  final Promotion promotion;
  final String store;

  PromotionItem({@required this.promotion, this.store = ""});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            contentPadding: EdgeInsets.all(10),
            dense: true,
            onTap: () => Navigator.push(
              context,
              CupertinoPageRoute(
                builder: (context) => PromotionPage(promotion),
              ),
            ),
            leading: Padding(
              padding: EdgeInsets.zero,
              child: Container(
                width: 55,
                height: 55,
                decoration: BoxDecoration(
                  image: promotion.product.info.image_url != null
                      ? DecorationImage(
                          image: NetworkImage(promotion.product.info.image_url),
                          fit: BoxFit.cover)
                      : null,
                  color: Colors.grey,
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                ),
              ),
            ),
            title: Text(promotion.product.info.product_name_fr),
            subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(promotion.product.info.brands != null
                      ? promotion.product.info.brands
                      : "No brand"),
                  store.isNotEmpty
                      ? Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                          ),
                          padding:
                              EdgeInsets.symmetric(vertical: 1, horizontal: 5),
                          child: Text(store))
                      : Container()
                ]),
            trailing: Container(
              width: 50,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: FractionalOffset.topLeft,
                  end: FractionalOffset.bottomRight,
                  colors: [
                    Color(0xFF780B7C),
                    Color(0xFF780B7C).withRed(200),
                  ],
                ),
                color: Colors.orangeAccent,
                shape: BoxShape.circle,
              ),
              child: Center(
                  child: Text(
                promotion.promotion.toString() + "€",
                style: TextStyle(color: Colors.white, fontSize: 12),
              )),
            ),
          ),
        ],
      ),
    );
    /*
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
    );*/
  }
}
