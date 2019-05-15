import 'package:flutter/material.dart';

import './screens/login_page.dart';
import './screens/home_page.dart';

import './utils/auth.dart';

class Routes {
  final routes = <String, WidgetBuilder>{
      '/login': (context) => LoginPage(),
      '/home': (context) => HomePage(),
  };

  Routes() {
    Auth.isTokenDefined().then((signedIn) {
      runApp(MaterialApp(
        title: "Yakosa",
        home: signedIn ? HomePage() : LoginPage(),
        routes: routes,
      ));
    });
  }
}
