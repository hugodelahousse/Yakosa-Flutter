import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yakosa/components/promotions_map/promotion_info_card.dart';
import 'package:yakosa/components/promotions_map/vote_card.dart';
import 'package:yakosa/models/promotion.dart';

class PromotionPage extends StatelessWidget {
  final Promotion promotion;

  const PromotionPage(this.promotion);

  @override
  Widget build(BuildContext context) {
    print(promotion.product.barcode);
    return CupertinoPageScaffold(
      child: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            backgroundColor: Color(0xFF780B7C),
            expandedHeight: 180.0,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Container(
                  width: MediaQuery.of(context).size.width * 0.6,
                  child: Text(
                      promotion.product.info.product_name_fr ?? "No name",
                      softWrap: false,
                      overflow: TextOverflow.fade)),
              background: Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: NetworkImage(promotion.product.info.image_url),
                          fit: BoxFit.cover))),
            ),
            actions: <Widget>[
              IconButton(
                padding: EdgeInsets.only(bottom: 10),
                icon: Icon(CupertinoIcons.add_circled_solid, size: 35),
                onPressed: () => print("pressed"),
              )
            ],
          ),
          SliverSafeArea(
            top: false,
            sliver: SliverToBoxAdapter(
              child: Column(
                children: <Widget>[
                  Container(
                    height: MediaQuery.of(context).size.width / 2,
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Card(
                            margin: EdgeInsets.all(10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                            key: Key(UniqueKey().toString()),
                            child: Center(
                                child: Text(
                              '${(promotion.promotion).toStringAsFixed(2)}€',
                              style:
                                  TextStyle(fontSize: 30, color: Colors.green),
                            )),
                          ),
                        ),
                        Expanded(
                            child: VoteCard(10, 4, (v) => print('Vote $v'))),
                      ],
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(
                          child: PromotionInfoCard(
                              promotion.brand.name,
                              promotion.price + promotion.promotion,
                              promotion.price,
                              promotion.product.info.brands)),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Card(
                            margin: EdgeInsets.all(10),
                            child: Padding(
                              padding: EdgeInsets.all(10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text("Details",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20)),
                                ],
                              ),
                            )),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
