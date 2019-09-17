import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import './jwt.dart';
import './api.dart';

final GlobalKey<NavigatorState> navigatorKey =
      new GlobalKey<NavigatorState>();

final HttpLink httpLink = HttpLink(uri: '${Api.baseUrl}/graphql');
    final AuthLink authLink = AuthLink(
      getToken: () async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        try {
          final exp = parseJwt(prefs.getString('token'))['exp'];
          if (DateTime.now().difference(DateTime.fromMillisecondsSinceEpoch(exp * 1000)).inSeconds >= -5)
          {
            var req = await Api.getNewToken(prefs.getString('refresh'));
            if (req.statusCode == 200) {
              var reqBody = await json.decode(req.body);
              prefs.setString('token', reqBody['token']);
              prefs.setString('refresh', reqBody['refresh']);
            } else {
              print("Refreshing token failed (403) : ${req.body}");
              //signOut();
            }
          }
        } catch (error) {
          print("Refreshing token failed : ${error.message}");
          return '';
        }
        return 'JWT ${prefs.getString('token')}';
      },
    );

final Link link = authLink.concat(httpLink as Link);

final ValueNotifier<GraphQLClient> graphQLCLient = ValueNotifier(
    GraphQLClient(
      cache: InMemoryCache(),
      link: link,
    )
);

signOut() async {
  print("signout");
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.remove('token');
  await prefs.remove('refresh');

  GoogleSignIn googleSignIn = GoogleSignIn();
  await googleSignIn.signOut();
  navigatorKey.currentState.pushReplacementNamed('/login');
}
