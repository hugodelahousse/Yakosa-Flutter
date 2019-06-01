import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class ProfilePage extends StatefulWidget {
@override
  State<StatefulWidget> createState() {
    return ProfilePageState();
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



class ProfilePageState extends State<ProfilePage> {

  void initState() {
    super.initState();
  }

  final query = r"""
    query Profile($id: ID!) {
      user(id: $id) {
        firstName
        lastName
        age
      }
    }
  """;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFFFFF),
      appBar: AppBar(
        title: Text("Profile"),
      ),
      body: Query(
        options: QueryOptions(document: query, variables: {"id": 12}),
        builder: (QueryResult result, { VoidCallback refetch }) {
          if (result.loading) {
            return Center(child: CircularProgressIndicator());
          }
          if (result.data == null) {
            return Center(child : Text("An error has occured"));
          }

          ProfileData profile = ProfileData.fromMap(result.data['user']);

          return Column(children: [
              Text("First Name: ${profile.firstName}"),
              Text("Last Name: ${profile.lastName}"),
              Text("Age: ${profile.age ?? "unknown"}"),
          ]);
        },
      )
    );
  }
}