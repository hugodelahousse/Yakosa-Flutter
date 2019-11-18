import 'package:json_annotation/json_annotation.dart';

part 'product.g.dart';

@JsonSerializable()
class ProductInfo {
  final String image_url;
  final String brands;
  final String product_name_fr;

  ProductInfo({
    this.image_url,
    this.brands,
    this.product_name_fr,
  });

  factory ProductInfo.fromJson(Map<String, dynamic> json) =>
      _$ProductInfoFromJson(json);
}

@JsonSerializable()
class Product {
  final String barcode;
  final ProductInfo info;

  Product({
    this.barcode,
    this.info,
  });

  factory Product.fromJson(Map<String, dynamic> json) =>
      _$ProductFromJson(json);
}

@JsonSerializable()
class ListProduct {
  final String id;
  final int quantity;
  final Product product;

  ListProduct({
    this.id,
    this.quantity,
    this.product,
  });

  factory ListProduct.fromJson(Map<String, dynamic> json) =>
      _$ListProductFromJson(json);
}
