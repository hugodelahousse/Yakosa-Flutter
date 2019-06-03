import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  final int id;
  final String firstName;
  final String lastName;
  final int age;

  User({
    this.id,
    this.firstName,
    this.lastName,
    this.age
  });

  factory User.fromJson(Map<String, dynamic> json) => _$User(json);
}