import 'dart:async';
import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:yakosa/components/promotions_map/promotions_list.dart';
import 'package:yakosa/components/promotions_map/switcher.dart';
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

class PromotionsMapPageState extends State<PromotionsMapPage> {
  var centerLocation = LatLng(48.853188, 2.349213);
  LatLng lastFetchLocation;

  var _location = location.Location();

  Map<String, Marker> markers = {};
  BitmapDescriptor mapIcon;

  bool mapMode = true;

  static const fetchNearbyStores = r"""
    query NearbyStores($position: String!, $distance: String!, $limit: Int!){
      nearbyStore(
        position: $position,
        distance: $distance,
        limit: $limit
      ){
        id,
        position{
          coordinates
        },
        brand{
          name
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
    });
    if (mapIcon == null) {
      getBytesFromAsset('assets/images/map-icon/3.0x/map-icon.png')
          .then((asset) {
        mapIcon = BitmapDescriptor.fromBytes(asset);
      });
    }
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
                ),
                Center(child: Icon(Icons.center_focus_strong))
              ],
            )
          : PromotionsList(centerLocation.latitude, centerLocation.longitude, 200, "500"),
      Padding(
        padding: const EdgeInsets.only(top: 40.0),
        child: Align(
            alignment: Alignment.topCenter,
            child: Switcher(
                "Map",
                "List",
                () => setState(() {
                      mapMode = true;
                    }),
                () => setState(() {
                      mapMode = false;
                    }))),
      ),
    ]);
  }

  _onCameraMove(CameraPosition position) {
    centerLocation =
        LatLng(position.target.latitude, position.target.longitude);
  }

  _onTapMarker(String id) {
    print(id + " TAPPED");
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
        List stores = result.data['nearbyStore'];
        var newMarkers = Map<String, Marker>();
        stores.forEach((s) {
          if (!markers.containsKey(s['id']) || true) {
            var marker = Marker(
              infoWindow: InfoWindow(title: s['brand']['name']),
                markerId: MarkerId(s['id']),
                position: LatLng(s['position']['coordinates'][1],
                    s['position']['coordinates'][0]),
                icon: mapIcon,
                onTap: () => _onTapMarker(s['id']));
            newMarkers.putIfAbsent(s['id'], () => marker);
          }
        });
        setState(() {
          markers = newMarkers;
        });
      }
    });
  }

  _onCameraIdle() {
    var distance = 1.0;
    if (lastFetchLocation != null)
      distance = LatLngDistance(
          lastFetchLocation.latitude,
          lastFetchLocation.longitude,
          centerLocation.latitude,
          centerLocation.longitude);
    if (distance >= 0.1)
      fetchStores(
          centerLocation.longitude, centerLocation.latitude, "500", 200);
  }
}
