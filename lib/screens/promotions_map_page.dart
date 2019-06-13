import 'dart:async';
import 'dart:typed_data';
import 'dart:ui';

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
  GoogleMapController _controller;
  var userLocation = LatLng(48.853188, 2.349213);

  var _location = location.Location();

  Map<String, Marker> markers = {};
  BitmapDescriptor mapIcon;

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
    return (await fi.image.toByteData(format: ImageByteFormat.png)).buffer.asUint8List();
  }

  void initState() {
    super.initState();
    _location.getLocation().then((value) {
      setState(() {
        userLocation = LatLng(value.latitude, value.longitude);
      });
    });
    if (mapIcon == null) {
      getBytesFromAsset('assets/images/map-icon/3.0x/map-icon.png').then((asset) {
        mapIcon = BitmapDescriptor.fromBytes(asset);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      initialCameraPosition: CameraPosition(
        target: userLocation,
        zoom: 14),
      onMapCreated: _onMapCreated,
      onCameraMove: _onCameraMove,
      compassEnabled: true,
      myLocationButtonEnabled: true,
      myLocationEnabled: true,
      markers: Set<Marker>.of(markers.values),
    );
  }

  _onMapCreated(GoogleMapController controller) {
    setState(() {
      _controller = controller;
    });
    //fetchStores(userLocation.longitude, userLocation.latitude, "10000", 100);
  }

  _onCameraMove(CameraPosition position) {
    fetchStores(position.target.longitude, position.target.latitude, "3000", 100);
  }

  _onTapMarker(String id) {
    print(id + " TAPPED");
  }

  fetchStores(double long, double lat, String dist, int limit) {
    graphQLCLient.value.query(
      QueryOptions(
        document: fetchNearbyStores,
        variables: {
          "position": "{\"type\": \"Point\", \"coordinates\": [$long, $lat]}",
          "distance": dist,
          "limit": limit,
        },
      ),
    ).then((result) {
      if (result.errors == null && result.data != null) {
        List stores = result.data['nearbyStore'];
        var newMarkers = Map<String, Marker>();
        stores.forEach((s) {
          var marker = Marker(
            markerId: MarkerId(s['id']),
            position: LatLng(s['position']['coordinates'][1], s['position']['coordinates'][0]),
            icon: mapIcon,
            onTap: () => _onTapMarker(s['id']));
          newMarkers.putIfAbsent(s['id'], () => marker);
        });
        setState(() {
            markers = newMarkers;
        });
      }
    });
  }
}