import 'package:flutter/material.dart';

import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';

class MapPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new FlutterMap(
     options: new MapOptions(
       center: new LatLng(51.5, -0.09),
       zoom: 13.0,
     ) ,
     layers: [
       new TileLayerOptions(
         urlTemplate: "https://api.mapbox.com/v4/{id}/{z}/{x}/{y}@2x.png?access_token={accessToken}",
         additionalOptions: {
           'accessToken': 'pk.eyJ1IjoiYWRyaWVuaGVsbGVjIiwiYSI6ImNpbDl1ZDkxdjAwMDd3cW0yZnpkbmJrd2gifQ.DMnVXVlm_M3tgwa86S-VpA',
           'id': 'mapbox.streets',
           },
       ),
       new MarkerLayerOptions(
         markers: [
           new Marker(
             width: 80.0,
             height: 80.0,
             point: new LatLng(51.5, -0.09),
             builder: (ctx) =>
             new Container(
               child: new FlutterLogo(),
             )
           )
         ]
       )
     ]
    );
  }
}