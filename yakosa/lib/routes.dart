import 'package:flutter/material.dart';

import './screens/login_page.dart';
import './screens/home_page.dart';

class Routes {
  final routes = <String, WidgetBuilder>{
          '/login': (context) => new LoginPage(),
      '/home': (context) => new HomePage(),
  };

  Routes() {
    runApp(new MaterialApp(
      title: "Yakosa",
      home: new LoginPage(),
      routes: routes,
    ));
  }
}
