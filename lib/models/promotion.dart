import 'package:json_annotation/json_annotation.dart';
import 'package:yakosa/models/product.dart';

part 'promotion.g.dart';

@JsonSerializable()
class Position {
  final String type;
  final List<double> coordinates;

  Position({
    this.type,
    this.coordinates,
  });

  factory Position.fromJson(Map<String, dynamic> json) => _$PositionFromJson(json);
}

@JsonSerializable()
class Brand {
  final String id;
  final String name;
  final List<Promotion> promotions;

  Brand({
    this.id,
    this.name,
    this.promotions,
  });

  factory Brand.fromJson(Map<String, dynamic> json) => _$BrandFromJson(json);
}

@JsonSerializable()
class Store {
  final String id;
  final Position position;
  final Brand brand;
  final List<Promotion> promotions;

  Store({
    this.id,
    this.position,
    this.brand,
    this.promotions,
  });

  factory Store.fromJson(Map<String, dynamic> json) => _$StoreFromJson(json);
}

@JsonSerializable()
class Promotion {
  final String id;
  final Product product;
  final Brand brand;
  final Store store;

  Promotion({
    this.id,
    this.product,
    this.brand,
    this.store,
  });

  factory Promotion.fromJson(Map<String, dynamic> json) => _$PromotionFromJson(json);
}

