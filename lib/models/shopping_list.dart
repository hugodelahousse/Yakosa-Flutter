import 'package:json_annotation/json_annotation.dart';
import 'package:yakosa/models/product.dart';

part 'shopping_list.g.dart';

@JsonSerializable()
class ShoppingList {
  final String id;
  final List<ListProduct> products;

  ShoppingList({
    this.id,
    this.products,
  });

  factory ShoppingList.fromJson(Map<String, dynamic> json) => _$ShoppingListFromJson(json);
}
