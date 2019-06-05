import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:location/location.dart';

class PromotionsMapPage extends StatefulWidget {
@override
  State<StatefulWidget> createState() {
    return PromotionsMapPageState();
  }
}

class PromotionsMapPageState extends State<PromotionsMapPage> {
  var location = new Location();
  LatLng userLocation = LatLng(48.853188, 2.349213);

  void initState() {
    super.initState();
    location.getLocation().then((x) {
      setState(() {
        userLocation.latitude = x.latitude;
        userLocation.longitude = x.longitude;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
     options: MapOptions(
       center: userLocation,
       zoom: 13.0,
     ) ,
     layers: [
       TileLayerOptions(
         urlTemplate: "https://api.mapbox.com/v4/{id}/{z}/{x}/{y}@2x.png?access_token={accessToken}",
         additionalOptions: {
           'accessToken': 'pk.eyJ1IjoiYWRyaWVuaGVsbGVjIiwiYSI6ImNpbDl1ZDkxdjAwMDd3cW0yZnpkbmJrd2gifQ.DMnVXVlm_M3tgwa86S-VpA',
           'id': 'mapbox.streets',
           },
       ),
       MarkerLayerOptions(
         markers: [
           Marker(
             width: 40.0,
             height: 40.0,
             point:  LatLng(48.853188, 2.349213),
             builder: (ctx) =>
             Container(
               decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 5.0)]
               ),
               child: IconTheme(data: IconThemeData(color: Colors.purple), child: new Icon(Icons.store)),
             )
           ),
           Marker(
             width: 40.0,
             height: 40.0,
             point:  LatLng(48.822372, 2.352175),
             builder: (ctx) =>
             Container(
               decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 5.0)]
               ),
               child: IconTheme(data: IconThemeData(color: Colors.purple), child: new Icon(Icons.store)),
             )
           ),
           Marker(
             width: 40.0,
             height: 40.0,
             point:  LatLng(48.813074, 2.361432),
             builder: (ctx) =>
             Container(
               decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 5.0)]
               ),
               child: IconTheme(data: IconThemeData(color: Colors.purple), child: new Icon(Icons.store)),
             )
           ),
           Marker(
             width: 40.0,
             height: 40.0,
             point:  LatLng(48.823832, 2.361737),
             builder: (ctx) =>
             Container(
               decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 5.0)]
               ),
               child: IconTheme(data: IconThemeData(color: Colors.purple), child: new Icon(Icons.store)),
             )
           )
         ]
       )
     ]
    );
  }
}