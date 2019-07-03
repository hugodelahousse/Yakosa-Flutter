import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
            localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
              DefaultMaterialLocalizations.delegate,
              DefaultWidgetsLocalizations.delegate,
            ],
            title: "Yakosa",
            debugShowCheckedModeBanner: false,
            home:  signedIn ? Layout() : LoginPage(),
            routes: routes,
          )
      ));
    });
  }
}
