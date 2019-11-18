import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:yakosa/components/promotions_map/promotion_item.dart';
import 'package:yakosa/models/promotion.dart';
import 'package:yakosa/models/shopping_route.dart';
import 'package:yakosa/utils/graphql.dart';
import 'package:location/location.dart' as location;

class SmartRoute extends StatefulWidget {
  final String shoppingListId;

  SmartRoute({
    @required this.shoppingListId,
  });

  @override
  State<StatefulWidget> createState() {
    return SmartRouteState();
  }
}

class SmartRouteState extends State<SmartRoute> {
  ShoppingRoute _shoppingRoute;
  List<Promotion> _currentPromotions;
  int _currentStore = 0;
  bool _loading = true;

  var _location = location.Location();

  static const shoppingRouteQuery = r"""
    query shoppingRoute($id: ID!, $maxStores: Int, $position: String!, $maxTravel: Float){
      shoppingRoute(
        shoppingListId: $id, numMaxOfStore: $maxStores, position: $position, maxDistTravel: $maxTravel
      ){
        stores {
          id,
          brand {
            id
          }
          name,
          address,
        }
        promotions {
          id,
            price,
            promotion,
            type,
            store {
              id
            }
            brand {
              id
            }
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
    """;

  @override
  void initState() {
    super.initState();
    _loadRoute(widget.shoppingListId);
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: Colors.white,
      navigationBar: CupertinoNavigationBar(
        middle: Text("Smart Route", style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFF780B7C),
        actionsForegroundColor: Colors.white,
      ),
      child: _loading
          ? Padding(
              padding: EdgeInsets.only(top: 50),
              child: Center(
                  child: CircularProgressIndicator(
                      valueColor:
                          AlwaysStoppedAnimation<Color>(Colors.purple))))
          : _shoppingRoute == null ||
                  _shoppingRoute.stores.length == 0 ||
                  _shoppingRoute.promotions.length == 0
              ? Center(
                  child: Text(
                      "No route found for this shopping list.\n(An error occured)",
                      style: TextStyle(fontSize: 25),
                      textAlign: TextAlign.center),
                )
              : Column(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.all(10),
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
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          CupertinoButton(
                            disabledColor: Colors.black54,
                            child: Icon(Icons.chevron_left,
                                color: Colors.black, size: 35),
                            padding: EdgeInsets.zero,
                            onPressed: _currentStore == 0
                                ? null
                                : () => changeStore(_currentStore - 1),
                          ),
                          Text(
                              "Shop $_currentStore of ${_shoppingRoute.stores.length}",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 22)),
                          CupertinoButton(
                              disabledColor: Colors.black54,
                              child: Icon(Icons.chevron_right,
                                  color: _currentStore ==
                                          _shoppingRoute.stores.length
                                      ? Colors.black54
                                      : Colors.black,
                                  size: 35),
                              padding: EdgeInsets.zero,
                              onPressed:
                                  _currentStore == _shoppingRoute.stores.length
                                      ? null
                                      : () => changeStore(_currentStore + 1)),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 2),
                      child: Text(
                          "Go to ${_shoppingRoute.stores[_currentStore].name}",
                          style: TextStyle(
                              fontSize: 40, fontWeight: FontWeight.w700),
                          textAlign: TextAlign.center),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(25)),
                        boxShadow: [
                          BoxShadow(
                              color: Color(0x40000000),
                              blurRadius: 5,
                              spreadRadius: 2)
                        ],
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                      child: SizedBox(
                        width: 200,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Text("${_shoppingRoute.stores[_currentStore].name}",
                                style: TextStyle(color: Colors.black54),
                                overflow: TextOverflow.ellipsis),
                            Icon(Icons.chevron_right, color: Colors.black),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 15),
                      child: Text("and Find these:",
                          style: TextStyle(
                              fontSize: 40, fontWeight: FontWeight.w700),
                          textAlign: TextAlign.center),
                    ),
                    _currentPromotions.length > 0
                        ? CustomScrollView(
                            slivers: <Widget>[
                              SliverList(
                                delegate: SliverChildBuilderDelegate(
                                  (context, index) {
                                    return PromotionItem(
                                      promotion: _currentPromotions[index],
                                    );
                                  },
                                  childCount: _currentPromotions.length,
                                ),
                              )
                            ],
                          )
                        : Text("Error loading promotions")
                  ],
                ),
    );
  }

  changeStore(int offset) {
    setState(() {
      _currentStore += offset;
    });
  }

  _loadRoute(String shoppingListId) {
    print("loading route");
    _location.getLocation().then((position) {
      LatLng latlng = LatLng(position.latitude, position.longitude);
      print(latlng.toString());
      print({
            "id": widget.shoppingListId,
            "maxStores": 6,
            "position":
                "{\"type\": \"Point\", \"coordinates\": [${latlng.longitude}, ${latlng.latitude}]}",
            "maxTravel": 1500,
          });
      graphQLCLient.value
          .query(
        QueryOptions(
          fetchPolicy: FetchPolicy.noCache,
          document: shoppingRouteQuery,
          variables: {
            "id": widget.shoppingListId,
            "maxStores": 6,
            "position":
                "{\"type\": \"Point\", \"coordinates\": [${latlng.longitude}, ${latlng.latitude}]}",
            "maxTravel": 1500,
          },
        ),
      )
          .then((result) {
        print("data:" + result.data.toString());
        print("errors:" + result.errors.toString());
        if (result.errors == null && result.data != null) {
          ShoppingRoute shoppingRoute =
              ShoppingRoute.fromJson(result.data['shoppingRoute']);
          print("shoproute:" + shoppingRoute.toString());
          List<Promotion> promotions = List<Promotion>();
          if (shoppingRoute.stores.length > 0)
            shoppingRoute.promotions.forEach((p) {
              if (p.store.id == shoppingRoute.stores[_currentStore].id ||
                  p.brand.id == shoppingRoute.stores[_currentStore].brand.id)
                promotions.add(p);
            });
          setState(() {
            _shoppingRoute = shoppingRoute;
            _currentPromotions = promotions;
          });
          print(_currentPromotions);
        }
        setState(() => _loading = false);
      });
    });
  }
}
