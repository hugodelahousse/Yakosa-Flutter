import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yakosa/models/user.dart';

import 'package:yakosa/components/settings_page/setting_button.dart';

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
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(padding: EdgeInsets.only(left: 15.0, top: 20.0, bottom: 10.0),child: Text("Settings", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 35.0, color: Colors.black))),
              Padding(padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0), child: Text("Profile", style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold))),
              Query(
                options: QueryOptions(document: query, variables: {"id": 12}),
                builder: (QueryResult result, { VoidCallback refetch }) {
                  if (result.loading) {
                    return Center(child: CircularProgressIndicator(backgroundColor: Colors.purple));
                  }
                  if (result.data == null || result.data['user'] == null) {
                    return SettingButton("An error occured", () {});
                  }

                  User profile = User.fromJson(result.data['user']);

                  return Column(children: [
                    SettingButton("${profile.firstName}", () {}, label: "First Name"),
                    SettingButton("${profile.lastName}", () {}, label: "Last Name"),
                    SettingButton("${profile.age ?? "unknown"}", () {}, label: "Age"),
                  ]);
                },
              ),
              Padding(padding: EdgeInsets.all(15.0)),
              Padding(padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0), child: Text("Advanced", style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold))),
              SettingButton("Sign Out", signOut, icon: Icons.arrow_right),
            ],
          )
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