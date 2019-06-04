import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import './jwt.dart';
import './api.dart';

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
            }
          }
        } catch (error) {
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