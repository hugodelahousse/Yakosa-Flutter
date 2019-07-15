import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yakosa/models/promotion.dart';
import 'package:yakosa/utils/utils.dart';

class PromotionPage extends StatelessWidget {
  final Promotion promotion;

  const PromotionPage(this.promotion);

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            backgroundColor: Color(0xFF780B7C),
            expandedHeight: 180.0,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(getVisibleString(32, promotion.product.info.product_name_fr ?? "No name")),
              background: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(image: NetworkImage(promotion.product.info.image_url), fit: BoxFit.cover)
                )
              ),
            ),
            actions: <Widget>[
              IconButton(
                padding: EdgeInsets.only(bottom: 10),
                icon: Icon(CupertinoIcons.add_circled_solid, size: 35),
                onPressed: () => print("pressed"),
              )
            ],
          ),
        ],
      ),
    );
  }
}