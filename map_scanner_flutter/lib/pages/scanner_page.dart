import 'dart:async';

import 'package:flutter/material.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../dbo/product.dart';

class ScannerPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ScannerPageState();
  }
}

class ScannerPageState extends State<ScannerPage> {

  String _result = "";
  Product _product;

  @override
  Widget build(BuildContext context) {
    return new Center(
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new Container(
            child: new RaisedButton(
              onPressed: _scanQR,
              child: new Text("Capture image")),
            padding: const EdgeInsets.all(8.0),
          ),
          new Padding(
            padding: const EdgeInsets.all(8.0),
          ),
          new Text("Barcode number after scan: " + _result),
          new Padding(
            padding: const EdgeInsets.all(8.0),
          ),
          _product != null ? new Text("Product Name: " + _product.name) : (_result != "" ? new Text("Product not found") : new Container()),
          new Padding(
            padding: const EdgeInsets.all(8.0),
          ),
          _product != null ? new Text("Product Brand: " + _product.brand) : new Container(),
        ],
      ),
    );
  }

  Future<Product> getProductFromBarcode(String barcode) async {
    final response = await http.get("https://fr.openfoodfacts.org/api/v0/produit/$barcode.json");
    try {
      var jsonResponse = json.decode(response.body);
      print("BARCODE: " + barcode);
      if (jsonResponse["status_verbose"] != "product found" ||
          jsonResponse["product"]["product_name"] == null ||
          jsonResponse["product"]["brands"] == null)
        return null;
      return new Product(jsonResponse["product"]["product_name"], barcode, jsonResponse["product"]["brands"]);
    } catch (ex) {
      print(ex);
    }
    return null;
  }

  Future _scanQR() async {
    try {
      String qrResult = await BarcodeScanner.scan();
      this.setState(() {
        _result = qrResult;
      });
      getProductFromBarcode(_result).then((product) => this.setState(() {
        _product = product;
      }));
    } on PlatformException catch (ex) {
      if (ex.code ==BarcodeScanner.CameraAccessDenied) {
        this.setState(() {
          _result = "Camera permission was denied";
        });
      } else {
        this.setState(() {
          _result = "Unknown error $ex";
        });
      }
    } catch (ex) {
        this.setState(() {
          _result = "Unknown error $ex";
        });
      }
    }
  }