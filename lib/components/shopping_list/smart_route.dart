import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:yakosa/components/promotions_map/promotion_item.dart';
import 'package:yakosa/models/product.dart';
import 'package:yakosa/models/promotion.dart';
import 'package:yakosa/models/shopping_route.dart';
import 'package:yakosa/utils/graphql.dart';
import 'package:location/location.dart' as location;
import 'package:url_launcher/url_launcher.dart';

class SmartRoute extends StatefulWidget {
  final String shoppingListId;
  final List<ListProduct> products;

  SmartRoute({
    @required this.shoppingListId,
    @required this.products,
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
          position {
            coordinates
          }
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
        child: Stack(children: <Widget>[
          CustomScrollView(
            slivers: <Widget>[
              CupertinoSliverNavigationBar(
                backgroundColor: Color(0xFF780B7C),
                key: UniqueKey(),
                actionsForegroundColor: Colors.white,
                largeTitle:
                    Text('Smart Route', style: TextStyle(color: Colors.white)),
              ),
              SliverPadding(padding: EdgeInsets.all(4)),
              if (_readyToDisplay())
                SliverToBoxAdapter(
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 15, vertical: 2),
                    child: Text(
                        "Go to ${_shoppingRoute.stores[_currentStore].name}",
                        style: TextStyle(
                            fontSize: 40, fontWeight: FontWeight.w700),
                        textAlign: TextAlign.center),
                  ),
                ),
              if (_readyToDisplay())
                SliverToBoxAdapter(
                  child: GestureDetector(
                    onTap: () => _launchMap(
                        _shoppingRoute
                            .stores[_currentStore].position.coordinates[1],
                        _shoppingRoute
                            .stores[_currentStore].position.coordinates[0]),
                    child: Center(
                      child: Row(mainAxisSize: MainAxisSize.min, children: <
                          Widget>[
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
                          padding:
                              EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Text(
                                  "${_shoppingRoute.stores[_currentStore].name}",
                                  style: TextStyle(color: Colors.black54),
                                  overflow: TextOverflow.ellipsis),
                              Icon(Icons.chevron_right, color: Colors.black),
                            ],
                          ),
                        ),
                      ]),
                    ),
                  ),
                ),
              if (_readyToDisplay())
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 15),
                    child: Text("and Find these:",
                        style: TextStyle(
                            fontSize: 40, fontWeight: FontWeight.w700),
                        textAlign: TextAlign.center),
                  ),
                ),
              SliverSafeArea(
                top: false,
                sliver: _loading
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
                    : _readyToDisplay()
                        ? SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (context, index) {
                                return PromotionItem(
                                    promotion: _currentPromotions[index]);
                              },
                              childCount: _currentPromotions.length,
                            ),
                          )
                        : SliverToBoxAdapter(
                            child: Padding(
                              padding:
                                  EdgeInsets.only(top: 50, left: 60, right: 60),
                              child: Text(
                                "An error occured while fetching promotions.",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 30,
                                    color: CupertinoColors.inactiveGray,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
              ),
              SliverPadding(padding: EdgeInsets.all(8)),
            ],
          ),
          if (_readyToDisplay())
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.only(bottom: 10),
                child: Container(
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
                            color: _currentStore == 0
                                ? Colors.black54
                                : Colors.black,
                            size: 35),
                        padding: EdgeInsets.zero,
                        onPressed: _currentStore == 0
                            ? null
                            : () => changeStore(_currentStore - 1),
                      ),
                      Text(
                          "Shop ${_currentStore + 1} of ${_shoppingRoute.stores.length}",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 22)),
                      CupertinoButton(
                          disabledColor: Colors.black54,
                          child: Icon(Icons.chevron_right,
                              color: _currentStore >=
                                      _shoppingRoute.stores.length - 1
                                  ? Colors.black54
                                  : Colors.black,
                              size: 35),
                          padding: EdgeInsets.zero,
                          onPressed:
                              _currentStore >= _shoppingRoute.stores.length - 1
                                  ? null
                                  : () => changeStore(_currentStore + 1)),
                    ],
                  ),
                ),
              ),
            )
        ]));
  }

  _launchMap(double lat, double lng) async {
    var url = '';
    var urlAppleMaps = '';
    if (Platform.isAndroid) {
      url = "https://www.google.com/maps/search/?api=1&query=${lat},${lng}";
    } else {
      urlAppleMaps = 'https://maps.apple.com/?q=$lat,$lng';
      url = "comgooglemaps://?saddr=&daddr=$lat,$lng&directionsmode=driving";
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch $url';
      }
    }

    if (await canLaunch(url)) {
      await launch(url);
    } else if (await canLaunch(urlAppleMaps)) {
      await launch(urlAppleMaps);
    } else {
      throw 'Could not launch $url';
    }
  }

  _readyToDisplay() {
    return _shoppingRoute != null &&
        _shoppingRoute.stores != null &&
        _shoppingRoute.promotions != null &&
        _shoppingRoute.stores.length > 0 &&
        _shoppingRoute.promotions.length > 0 &&
        _currentPromotions != null &&
        _currentPromotions.length > 0;
  }

  changeStore(int newStoreIndex) {
    List<Promotion> promotions = List<Promotion>();
    if (_shoppingRoute.stores.length > 0)
      _shoppingRoute.promotions.forEach((p) {
        if (p.store != null &&
                _shoppingRoute.stores[newStoreIndex] != null &&
                p.store.id == _shoppingRoute.stores[newStoreIndex].id ||
            p.brand != null &&
                p.brand.id == _shoppingRoute.stores[newStoreIndex].brand.id)
          promotions.add(p);
      });
    setState(() {
      _currentStore = newStoreIndex;
      _currentPromotions = promotions;
    });
  }

  _loadRoute(String shoppingListId) {
    _location.getLocation().then((position) {
      LatLng latlng = LatLng(position.latitude, position.longitude);
      print(latlng.latitude);
      print(latlng.longitude);
      graphQLCLient.value
          .query(
        QueryOptions(
          fetchPolicy: FetchPolicy.noCache,
          documentNode: gql(shoppingRouteQuery),
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
        if (result.exception == null && result.data != null) {
          ShoppingRoute shoppingRoute =
              ShoppingRoute.fromJson(result.data['shoppingRoute']);
          List<Promotion> promotions = List<Promotion>();
          if (shoppingRoute.stores.length > 0)
            shoppingRoute.promotions.forEach((p) {
              if (p.store != null &&
                      p.store.id == shoppingRoute.stores[_currentStore].id ||
                  p.brand != null &&
                      p.brand.id ==
                          shoppingRoute.stores[_currentStore].brand.id)
                promotions.add(p);
            });
          setState(() {
            _shoppingRoute = shoppingRoute;
            _currentPromotions = promotions;
          });
        }
        setState(() => _loading = false);
      });
    });
  }
}
