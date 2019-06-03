import 'package:flutter/material.dart';

import './screens/login_page.dart';
import './screens/layout.dart';

import './utils/auth.dart';

class Routes {
  final routes = <String, WidgetBuilder>{
      '/login': (context) => LoginPage(),
      '/home': (context) => Layout(),
  };

  Routes() {
    Auth.isTokenDefined().then((signedIn) {
      runApp(MaterialApp(
        title: "Yakosa",
        home: signedIn ? Layout() : LoginPage(),
        //home: HomePage(),
        routes: routes,
      ));
    });
  }
}
