import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graphql/client.dart';
import 'package:yakosa/components/promotions_map/promotion_item.dart';
import 'package:yakosa/components/promotions_map/search_bar.dart';
import 'package:yakosa/models/promotion.dart';
import 'package:yakosa/screens/filter_page.dart';
import 'package:yakosa/utils/graphql.dart';
import 'package:yakosa/utils/shared_preferences.dart';
import 'package:diacritic/diacritic.dart';

class PromotionsList extends StatefulWidget {
  final double positionLat;
  final double positionLong;
  final int limit;

  PromotionsList(this.positionLat, this.positionLong, this.limit);

  _PromotionsListState createState() => _PromotionsListState();
}

class _PromotionsListState extends State<PromotionsList> {
  bool loading = false;
  List<Promotion> promotions = [];
  List<Promotion> displayedPromotions = [];

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
            brand {
              name
            }
            store {
              name
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
        backgroundColor: Colors.white,
        child: CustomScrollView(
          slivers: <Widget>[
            CupertinoSliverNavigationBar(
              backgroundColor: Colors.white,
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
            SliverPadding(
              padding: EdgeInsets.symmetric(vertical: 2, horizontal: 10),
              sliver: SliverToBoxAdapter(
                child: FlatButton(
                  child: Text("Filters"),
                  color: Colors.grey[200],
                  onPressed: () async {
                    await Navigator.push(context,
                        MaterialPageRoute(builder: (context) => FilterPage()));
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
                  : (displayedPromotions.length > 0
                      ? SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              return PromotionItem(
                                  promotion: displayedPromotions[index],
                                  store: displayedPromotions[index].brand !=
                                          null
                                      ? displayedPromotions[index].brand.name
                                      : "No store");
                            },
                            childCount: displayedPromotions.length,
                          ),
                        )
                      : SliverToBoxAdapter(
                          child: Padding(
                            padding:
                                EdgeInsets.only(top: 50, left: 60, right: 60),
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
            SliverPadding(padding: EdgeInsets.all(8)),
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
        var newPromotions = List<Promotion>();
        stores.forEach((s) {
          s['brand']['promotions'].forEach((p) {
            final promotion = Promotion.fromJson(p);
            newPromotions.add(promotion);
          });
        });
        setState(() {
          promotions = newPromotions;
          displayedPromotions = promotions;
        });
      }
      setState(() => loading = false);
    });
  }

  _refreshPreferences() {
    LocalPreferences.getString("search_distance", "1000").then((x) {
      setState(() {
        searchDistance = x;
      });
      fetchStoresPromotions();
    });
  }

  _searchTerms(String terms) {
    String trimmed = removeDiacritics(terms.trim().toLowerCase());
    if (trimmed.isNotEmpty)
      setState(() {
        displayedPromotions = promotions
            .where((x) =>
                (x.brand.name != null &&
                    removeDiacritics(x.brand.name.toLowerCase())
                        .contains(trimmed)) ||
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
