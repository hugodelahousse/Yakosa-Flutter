import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graphql/client.dart';
import 'package:yakosa/components/promotions_map/promotion_item.dart';
import 'package:yakosa/models/promotion.dart';
import 'package:yakosa/screens/filter_page.dart';
import 'package:yakosa/utils/graphql.dart';
import 'package:yakosa/utils/shared_preferences.dart';

class Pair {
  final dynamic left;
  final dynamic right;

  Pair(this.left, this.right);
}

class PromotionsList extends StatefulWidget {
  final double positionLat;
  final double positionLong;
  final int limit;

  PromotionsList(this.positionLat, this.positionLong, this.limit);

  _PromotionsListState createState() => _PromotionsListState();
}

class _PromotionsListState extends State<PromotionsList> {
  bool loading = false;
  List<Pair> promotions = [];

  String searchDistance;

  static const fetchNearbyStores = r"""
    query NearbyStores($position: String!, $distance: String!, $limit: Int!){
      nearbyStore(
        position: $position,
        distance: $distance,
        limit: $limit
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

    _refreshPreferences();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        child: CustomScrollView(
      slivers: <Widget>[
        CupertinoSliverNavigationBar(
          middle: Text(""),
          key: UniqueKey(),
          largeTitle: Text('Promotions'),
        ),
        SliverPadding(
          padding: EdgeInsets.symmetric(vertical: 2, horizontal: 10),
          sliver: SliverToBoxAdapter(
            child: FlatButton(
              child: Text("Filters"),
              color: Colors.grey[200],
              onPressed: () async {
                await Navigator.push(context, PageRouteBuilder(
                    pageBuilder: (BuildContext context, _, __) {
                  return FilterPage();
                }));
                _refreshPreferences();
              },
            ),
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
              : (promotions.length > 0
                  ? SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          return PromotionItem(
                              promotion: promotions[index].right,
                              store: promotions[index].left);
                        },
                        childCount: promotions.length,
                      ),
                    )
                  : SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.only(top: 50, left: 60, right: 60),
                        child: Text(
                          "No nearby promotions :(",
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

  fetchStoresPromotions() {
    setState(() => loading = true);
    graphQLCLient.value
        .query(
      QueryOptions(
        document: fetchNearbyStores,
        variables: {
          "position":
              "{\"type\": \"Point\", \"coordinates\": [${widget.positionLong}, ${widget.positionLat}]}",
          "distance": searchDistance,
          "limit": widget.limit,
        },
      ),
    )
        .then((result) {
      if (result.errors == null && result.data != null) {
        List stores = result.data['nearbyStore'];
        var newPromotions = List<Pair>();
        stores.forEach((s) {
          s['brand']['promotions'].forEach((p) {
            final promotion = Promotion.fromJson(p);
            newPromotions.add(Pair(s['brand']['name'], promotion));
          });
        });
        setState(() {
          promotions = newPromotions;
        });
      }
      setState(() => loading = false);
    });
  }

  _refreshPreferences() {
    LocalPreferences.getString("search_distance", "1000")
        .then((x) {
          setState(() {
            searchDistance = x;
          });
          fetchStoresPromotions();
        });
  }
}
