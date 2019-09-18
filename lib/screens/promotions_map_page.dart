import 'dart:async';
import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:yakosa/components/promotions_map/promotions_list.dart';
import 'package:yakosa/components/promotions_map/promotions_store_list.dart';
import 'package:yakosa/components/promotions_map/switcher.dart';
import 'package:yakosa/models/promotion.dart';
import 'package:yakosa/utils/shared_preferences.dart';
import 'package:yakosa/utils/utils.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:location/location.dart' as location;
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:yakosa/utils/graphql.dart';

class PromotionsMapPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return PromotionsMapPageState();
  }
}

class PromotionsMapPageState extends State<PromotionsMapPage>
    with SingleTickerProviderStateMixin {
  var centerLocation = LatLng(48.853188, 2.349213);
  LatLng lastFetchLocation;

  GoogleMapController mapController;

  var _location = location.Location();

  Map<String, Marker> markers = {};
  List<Store> stores;
  BitmapDescriptor mapIcon;

  bool mapMode = true;

  AnimationController controller;
  Animation<Offset> offset;

  Store selectedStore;

  String searchDistance;

  static const fetchNearbyStores = r"""
    query NearbyStores($position: String!, $distance: String!, $limit: Int!){
      nearbyStore(
        position: $position,
        distance: $distance,
        limit: $limit
      ){
        id,
        name,
        address,
        position{
          coordinates
        },
        brand{
          name
          promotions {
            id
          }
        },
        promotions {
          id
        }
      }
    }
    """;

  Future<Uint8List> getBytesFromAsset(String path) async {
    ByteData data = await rootBundle.load(path);
    Codec codec = await instantiateImageCodec(data.buffer.asUint8List());
    FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ImageByteFormat.png))
        .buffer
        .asUint8List();
  }

  void initState() {
    super.initState();
    _location.getLocation().then((value) {
      setState(() {
        centerLocation = LatLng(value.latitude, value.longitude);
      });
      Future.delayed(
          Duration(seconds: 1),
          () => mapController
                  .animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
                target: centerLocation,
                zoom: 14,
              ))));
    });
    _refreshPreferences();
    if (mapIcon == null) {
      getBytesFromAsset('assets/images/map-icon/3.0x/map-icon.png')
          .then((asset) {
        mapIcon = BitmapDescriptor.fromBytes(asset);
      });
    }
    controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 200));

    offset = Tween<Offset>(begin: Offset(-2, 0.0), end: Offset.zero)
        .animate(controller);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: <Widget>[
      mapMode
          ? Stack(
              children: <Widget>[
                GoogleMap(
                  initialCameraPosition:
                      CameraPosition(target: centerLocation, zoom: 14),
                  minMaxZoomPreference: MinMaxZoomPreference(13, 16),
                  tiltGesturesEnabled: false,
                  onCameraIdle: _onCameraIdle,
                  onCameraMove: _onCameraMove,
                  compassEnabled: true,
                  myLocationButtonEnabled: true,
                  myLocationEnabled: true,
                  markers: Set<Marker>.of(markers.values),
                  onMapCreated: _onMapCreated,
                  onTap: _onMapTapped,
                ),
                Center(child: Icon(Icons.center_focus_strong))
              ],
            )
          : PromotionsList(
              centerLocation.latitude, centerLocation.longitude, 200),
      Padding(
        padding: const EdgeInsets.only(right: 10.0, top: 40.0),
        child: Align(
            alignment: Alignment.topRight,
            child: Switcher(
              Icons.list,
              Icons.map,
              () {
                setState(() {
                  mapMode = !mapMode;
                });
                LocalPreferences.setBool("promotions_page_map", mapMode);
                if (mapMode) _refreshPreferences();
                controller.reverse();
              },
              mapMode,
            )),
      ),
      selectedStore != null
          ? Align(
              alignment: Alignment.bottomCenter,
              child: Dismissible(
                key: Key(UniqueKey().toString()),
                onDismissed: (direction) {
                  controller.reverse();
                  setState(() {
                    selectedStore = null;
                  });
                },
                child: SlideTransition(
                  position: offset,
                  child: Card(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        ListTile(
                          leading: Icon(Icons.store, size: 40.0),
                          title: Text(selectedStore != null
                              ? selectedStore.name
                              : "Unknown"),
                          subtitle: Text(selectedStore != null
                              ? '${selectedStore.address}'
                              : "Unknown address"),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Text(
                                  '${selectedStore.promotions.length + selectedStore.brand.promotions.length}'),
                              Icon(Icons.chevron_right, size: 40),
                            ],
                          ),
                          onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => PromotionsStoreList(
                                      selectedStore.id, selectedStore.name))),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )
          : Container()
    ]);
  }

  _onCameraMove(CameraPosition position) {
    centerLocation =
        LatLng(position.target.latitude, position.target.longitude);
  }

  _onTapMarker(String id) {
    setState(() {
      selectedStore = stores.firstWhere((s) => s.id == id);
    });
    controller.forward();
  }

  _onMapTapped(LatLng position) {
    if (controller.status == AnimationStatus.completed) {
      controller.reverse();
      setState(() {
        selectedStore = null;
      });
    }
  }

  fetchStores(double long, double lat, String dist, int limit) {
    lastFetchLocation = LatLng(lat, long);
    graphQLCLient.value
        .query(
      QueryOptions(
        document: fetchNearbyStores,
        variables: {
          "position": "{\"type\": \"Point\", \"coordinates\": [$long, $lat]}",
          "distance": dist,
          "limit": limit,
        },
      ),
    )
        .then((result) {
      if (result.errors == null && result.data != null) {
        List resultList = result.data['nearbyStore'];
        List<Store> newStores = [];
        for (var i = 0; i < resultList.length; i++) {
          newStores.add(Store.fromJson(resultList[i]));
        }
        var newMarkers = Map<String, Marker>();
        newStores.forEach((s) {
          if (s.brand.promotions.length + s.promotions.length > 0) {
            var marker = Marker(
                markerId: MarkerId(s.id),
                position: LatLng(
                    s.position.coordinates[1], s.position.coordinates[0]),
                icon: mapIcon,
                onTap: () => _onTapMarker(s.id));
            newMarkers.putIfAbsent(s.id, () => marker);
          }
        });
        setState(() {
          markers = newMarkers;
          stores = newStores;
        });
      }
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: centerLocation,
      zoom: 14,
    )));
  }

  _onCameraIdle() {
    var distance = 1.0;
    if (lastFetchLocation != null)
      distance = LatLngDistance(
          lastFetchLocation.latitude,
          lastFetchLocation.longitude,
          centerLocation.latitude,
          centerLocation.longitude);
    if (distance >= 0.1) {
      fetchStores(centerLocation.longitude, centerLocation.latitude,
          searchDistance, 200);
    }
  }

  _refreshPreferences() {
    LocalPreferences.getString("search_distance", "1000")
        .then((x) => setState(() {
              searchDistance = x;
            }));
    LocalPreferences.getBool("promotions_page_map", true)
        .then((x) => setState(() {
              mapMode = x;
              if (mapMode) controller.reverse();
            }));
  }
}
