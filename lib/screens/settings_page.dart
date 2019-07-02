import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yakosa/models/user.dart';

import 'package:yakosa/components/settings_page/settings_group.dart';
import 'package:yakosa/components/settings_page/setting_item.dart';

class SettingsPage extends StatefulWidget {
@override
  State<StatefulWidget> createState() {
    return SettingsPageState();
  }
}

class SettingsPageState extends State<SettingsPage> {

  final query = r"""
    query Profile{
      user: currentUser {
        firstName
        lastName
        age
      }
    }
  """;

  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: Container(
        color: Color(0xFFEFEFF4),
        child: CustomScrollView(
          slivers: <Widget>[
            CupertinoSliverNavigationBar(
              largeTitle: Text('Settings'),
            ),
            SliverSafeArea(
              top: false,
              sliver: SliverList(
                delegate: SliverChildListDelegate(
                  <Widget>[
                    SettingsGroup(
                      [
                        Query(
                          options: QueryOptions(document: query, variables: {"id": 12}),
                          builder: (QueryResult result, { VoidCallback refetch }) {
                            if (result.loading) {
                              return SettingItem(
                                'Name',
                              );
                            }
                            if (result.data == null || result.data['user'] == null) {
                              return SettingItem(
                                'Name',
                                value: 'An error occured',
                              );
                            }

                            User profile = User.fromJson(result.data['user']);

                            return SettingItem(
                              'Name',
                              value: '${profile.firstName} ${profile.lastName}',
                            );
                          },
                        ),
                      ],
                      label: Text('Profile'),
                    ),
                    SettingsGroup(
                      [
                        SettingItem(
                          'Sign Out',
                          hasAction: true,
                          action: signOut,
                        )
                      ],
                      label: Text('Advanced'),
                    )

                  ]
                ),
              ),
            )
          ],
        )
      )
    );
  }

  signOut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('refresh');

    GoogleSignIn googleSignIn = GoogleSignIn();
    await googleSignIn.signOut();
    Navigator.pushReplacementNamed(context, '/login');
  }
}