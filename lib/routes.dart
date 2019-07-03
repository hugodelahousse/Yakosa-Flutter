import 'package:flutter/cupertino.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import './screens/login_page.dart';
import './screens/settings_page.dart';
import './screens/layout.dart';

import './utils/auth.dart';
import './utils/graphql.dart';

class Routes {
  final routes = <String, WidgetBuilder>{
      '/login': (context) => LoginPage(),
      '/settings': (context) => SettingsPage(),
      '/home': (context) => Layout(),
  };

  Routes() {

    Auth.isTokenDefined().then((signedIn) {
      runApp(GraphQLProvider(
          client: graphQLCLient,
          child: CupertinoApp(
            title: "Yakosa",
            home:  signedIn ? Layout() : LoginPage(),
            routes: routes,
          )
      ));
    });
  }
}
