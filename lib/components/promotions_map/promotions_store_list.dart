import 'package:diacritic/diacritic.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graphql/client.dart';
import 'package:yakosa/components/promotions_map/promotion_item.dart';
import 'package:yakosa/components/promotions_map/search_bar.dart';
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
  List<Promotion> displayedPromotions = [];

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
        SliverPadding(padding: EdgeInsets.all(4)),
        SliverPadding(
          padding: EdgeInsets.symmetric(vertical: 2, horizontal: 10),
          sliver: SliverToBoxAdapter(
            child: SearchBar((terms) => _searchTerms(terms)),
          ),
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
              : (displayedPromotions.length > 0
                  ? SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          return PromotionItem(
                              promotion: displayedPromotions[index],
                              store: widget.storeId);
                        },
                        childCount: displayedPromotions.length,
                      ),
                    )
                  : SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.only(top: 50, left: 60, right: 60),
                        child: Text(
                          "No Promotions found",
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
          displayedPromotions = promotions;
        });
      }
      setState(() => loading = false);
    });
  }


  _searchTerms(String terms) {
    String trimmed = removeDiacritics(terms.trim().toLowerCase());
    if (trimmed.isNotEmpty)
      setState(() {
        displayedPromotions = promotions
            .where((x) =>
                (x.product.info.product_name_fr != null &&
                    removeDiacritics(
                            x.product.info.product_name_fr.toLowerCase())
                        .contains(terms)) ||
                (x.product.info.brands != null &&
                    removeDiacritics(x.product.info.brands.toLowerCase())
                        .contains(terms)))
            .toList();
      });
    else
      setState(() {
        displayedPromotions = promotions;
      });
  }
}
