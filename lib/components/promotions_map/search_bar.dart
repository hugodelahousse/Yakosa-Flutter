import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SearchBar extends StatefulWidget {
  final Function _onTextChanged;

  SearchBar(this._onTextChanged);

  @override
  State<StatefulWidget> createState() {
    return SearchBarState();
  }
}

class SearchBarState extends State<SearchBar> {
  TextEditingController _controller;

  bool showClearIcon = false;

  @override
  void initState() {
    super.initState();
    this._controller = TextEditingController()..addListener(_onTextChanged);
    showClearIcon = _controller.text.length > 0;
  }

  @override
  void dispose() {
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
              color: Colors.white,
              border: Border(),
              boxShadow: [
                BoxShadow(
                    blurRadius: 1, color: Colors.black26, offset: Offset(0, 1))
              ],
              borderRadius: BorderRadius.all(Radius.circular(10)),
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
            autofocus: false,
            placeholder: "Carottes...",
            controller: _controller,
          ),
        ),
      ],
    );
  }
}
