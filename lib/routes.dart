import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:yakosa/screens/profile_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yakosa/utils/api.dart';

import './screens/login_page.dart';
import './screens/layout.dart';

import './utils/auth.dart';

class Routes {
  final routes = <String, WidgetBuilder>{
      '/login': (context) => LoginPage(),
      '/home': (context) => Layout(),
  };

  Routes() {

    final HttpLink httpLink = HttpLink(uri: '${Api.baseUrl}/graphql');
    final AuthLink authLink = AuthLink(
      getToken: () async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        return 'JWT ${prefs.getString('token')}';
      },
    );

    final Link link = authLink.concat(httpLink as Link);

    final ValueNotifier<GraphQLClient> client = ValueNotifier(
        GraphQLClient(
          cache: InMemoryCache(),
          link: link,
        )
    );

    Auth.isTokenDefined().then((signedIn) {
      runApp(GraphQLProvider(
          client: client,
          child: MaterialApp(
            title: "Yakosa",
            home:  signedIn ? Layout() : LoginPage(),
            routes: routes,
          )
      ));
    });
  }
}
