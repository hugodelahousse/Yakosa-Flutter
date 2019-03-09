class Product {
  String _name;
  String _barcode;
  String _brand;

  set name(name) => _name;
  String get name => _name;

  set barcode(barcode) => _barcode;
  String get barcode => _barcode;

  set brand(brand) => _brand;
  String get brand => _brand;

  Product(this._name, this._barcode, this._brand);
}