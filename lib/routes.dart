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
    WidgetsFlutterBinding.ensureInitialized();
    Auth.isTokenDefined().then((signedIn) {
      runApp(GraphQLProvider(
          client: graphQLCLient,
          child: CupertinoApp(
            theme: CupertinoThemeData(brightness: Brightness.light, barBackgroundColor: Colors.black),
            localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
                DefaultMaterialLocalizations.delegate,
                DefaultWidgetsLocalizations.delegate,
            ],
            title: "Yakosa",
            navigatorKey: navigatorKey,
            debugShowCheckedModeBanner: false,
            home:  signedIn ? Layout() : LoginPage(),
            routes: routes,
          )
      ));
    });
  }
}
