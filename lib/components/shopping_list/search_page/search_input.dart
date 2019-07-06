import 'package:flutter/cupertino.dart';

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
  
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(8)),
        color: CupertinoColors.lightBackgroundGray.withOpacity(0.5)
      ),
      padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      child: Row(
        children: <Widget>[
          Icon(
            CupertinoIcons.search, 
            color: CupertinoColors.inactiveGray,
          ),
          Expanded(
            child: CupertinoTextField(
              controller: _controller,
              focusNode: _focusNode,
            )
          ),
          showClearIcon ?
            GestureDetector(
              onTap: _controller.clear,
              child: Icon(
                CupertinoIcons.clear_thick_circled,
                color: CupertinoColors.inactiveGray,
              ),
            )
            : Text(''),
        ],
      )
    );
  }
}