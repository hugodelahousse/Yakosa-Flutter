import 'package:json_annotation/json_annotation.dart';
import 'package:yakosa/models/promotion.dart';
import 'package:yakosa/models/shopping_list.dart';

part 'shopping_route.g.dart';

@JsonSerializable()
class ShoppingRoute {
  final ShoppingList shoppingList;
  final List<Store> stores;
  final List<Promotion> promotions;
  final double economie;

  ShoppingRoute(
      {this.shoppingList, this.stores, this.promotions, this.economie});

  factory ShoppingRoute.fromJson(Map<String, dynamic> json) =>
      _$ShoppingRouteFromJson(json);
}
