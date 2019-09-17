import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graphql/client.dart';
import 'package:yakosa/components/promotions_map/promotion_item.dart';
import 'package:yakosa/models/promotion.dart';
import 'package:yakosa/utils/graphql.dart';

class PromotionsStoreList extends StatefulWidget {
  final String storeId;
  final String storeName;

  PromotionsStoreList(this.storeId, this.storeName);

  _PromotionsStoreListState createState() => _PromotionsStoreListState();
}

class _PromotionsStoreListState extends State<PromotionsStoreList> {
  bool loading = false;

  List<Promotion> promotions = [];

  static const storePromotionsQuery = r"""
    query StorePromotions($id: ID!){
      store(
        id: $id,
      ){
        id,
        brand{
          name,
          promotions {
            id,
            price,
            promotion,
            type,
            product {
              barcode,
              info {
                image_url,
                product_name_fr
                brands
              }
            }
          }
        }
      }
    }
    """;

  @override
  void initState() {
    super.initState();

    fetchStorePromotions();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        child: CustomScrollView(
      slivers: <Widget>[
        CupertinoSliverNavigationBar(
          middle: Text(widget.storeName),
          key: UniqueKey(),
          largeTitle: Text('Promotions'),
        ),
        SliverSafeArea(
          top: false,
          sliver: loading
              ? SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.only(top: 50),
                    child: Center(
                      child: CircularProgressIndicator(
                        valueColor:
                            AlwaysStoppedAnimation<Color>(Colors.purple),
                      ),
                    ),
                  ),
                )
              : (promotions.length > 0
                  ? SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          return PromotionItem(
                              promotion: promotions[index],
                              store: widget.storeId);
                        },
                        childCount: promotions.length,
                      ),
                    )
                  : SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.only(top: 50, left: 60, right: 60),
                        child: Text(
                          "No Promotions",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 30,
                              color: CupertinoColors.inactiveGray,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    )),
        ),
      ],
    ));
  }

  fetchStorePromotions() {
    setState(() => loading = true);
    graphQLCLient.value
        .query(
      QueryOptions(
        document: storePromotionsQuery,
        variables: {
          "id": widget.storeId,
        },
      ),
    )
        .then((result) {
      if (result.errors == null && result.data != null) {
        List promotionsResult = result.data['store']['brand']['promotions'];
        List<Promotion> newPromotions = [];
        promotionsResult.forEach((p) {
          final promotion = Promotion.fromJson(p);
          newPromotions.add(promotion);
        });
        setState(() {
          promotions = newPromotions;
        });
      }
      setState(() => loading = false);
    });
  }
}
