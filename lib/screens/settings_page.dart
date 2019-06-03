import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import 'package:yakosa/components/settings_page/setting_button.dart';

class SettingsPage extends StatefulWidget {
@override
  State<StatefulWidget> createState() {
    return SettingsPageState();
  }
}

class ProfileData {
  final String firstName;
  final String lastName;
  final int age;
  ProfileData({this.firstName, this.lastName, this.age});

  factory ProfileData.fromMap(Map<String, dynamic> parsedMap) {
    return new ProfileData(
      firstName: parsedMap['firstName'],
      lastName: parsedMap['lastName'],
      age: parsedMap['age'],
    );
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
              Padding(padding: EdgeInsets.only(left: 15.0, top: 20.0, bottom: 10.0),child: Text("Settings", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30.0, color: Colors.black))),
              Padding(padding: EdgeInsets.symmetric(horizontal: 15.0), child: Text("Profile", style: TextStyle(fontSize: 15.0, color: Colors.grey))),
              Query(
                options: QueryOptions(document: query, variables: {"id": 12}),
                builder: (QueryResult result, { VoidCallback refetch }) {
                  if (result.loading) {
                    return Center(child: CircularProgressIndicator(backgroundColor: Colors.purple));
                  }
                  if (result.data == null || result.data['user'] == null) {
                    return SettingButton("An error occured", () {});
                  }

                  ProfileData profile = ProfileData.fromMap(result.data['user']);

                  return Column(children: [
                    SettingButton("Firstname: ${profile.firstName}", () {}),
                    SettingButton("Lastname: ${profile.lastName}", () {}),
                    SettingButton("Age: ${profile.age ?? "unknown"}", () {}),
                  ]);
                },
              ),
              Padding(padding: EdgeInsets.symmetric(horizontal: 15.0), child: Text("Advanced", style: TextStyle(fontSize: 15.0, color: Colors.grey))),
              SettingButton("Delete account", () {}, icon: Icons.arrow_right),
            ],
          )
        )
      )
    );
  }
}