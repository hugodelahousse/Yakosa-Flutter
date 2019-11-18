import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:barcode_scan/barcode_scan.dart';

class SearchInput extends StatefulWidget {
  final Function _onTextChanged;

  SearchInput(this._onTextChanged);

  @override
  State<StatefulWidget> createState() {
    return SearchInputState();
  }
}

class SearchInputState extends State<SearchInput> {
  TextEditingController _controller;
  FocusNode _focusNode;

  bool showClearIcon = false;

  @override
  void initState() {
    super.initState();
    this._controller = TextEditingController()..addListener(_onTextChanged);
    this._focusNode = FocusNode();
    showClearIcon = _controller.text.length > 0;
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  _onTextChanged() {
    if (!this.mounted) return;
    widget._onTextChanged(_controller.text);
    setState(() {
      showClearIcon = _controller.text.length > 0;
    });
  }

  _scanBarcode() async {
    try {
      String barcode = await BarcodeScanner.scan();
      setState(() {
        _controller.text = barcode;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Flexible(
          fit: FlexFit.loose,
          child: CupertinoTextField(
            decoration: BoxDecoration(
              color: Colors.transparent,
              border: Border(),
            ),
            prefix: Icon(
              CupertinoIcons.search,
              color: CupertinoColors.inactiveGray,
            ),
            suffixMode: showClearIcon
                ? OverlayVisibilityMode.always
                : OverlayVisibilityMode.never,
            suffix: GestureDetector(
              onTap: _controller.clear,
              child: Icon(
                CupertinoIcons.clear_thick_circled,
                color: CupertinoColors.inactiveGray,
              ),
            ),
            maxLength: 32,
            autofocus: true,
            placeholder: "Carottes...",
            controller: _controller,
            focusNode: _focusNode,
          ),
        ),
        IconButton(
          icon: Icon(CupertinoIcons.photo_camera),
          onPressed: _scanBarcode,
        ),
      ],
    );
  }
}
