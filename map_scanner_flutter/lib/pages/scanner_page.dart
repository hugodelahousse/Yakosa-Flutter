import 'dart:async';

import 'package:flutter/material.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/services.dart';

class ScannerPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ScannerPageState();
  }
}

class ScannerPageState extends State<ScannerPage> {

  String _result = "";

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
        ],
      ),
    );
  }

  Future _scanQR() async {
    try {
      String qrResult = await BarcodeScanner.scan();
      this.setState(() {
        _result = qrResult;
      });
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