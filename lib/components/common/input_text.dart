import 'package:flutter/cupertino.dart';

class InputText extends StatefulWidget {
  final Function _onTextChanged;

  InputText(this._onTextChanged);

  _InputTextState createState() => _InputTextState();
}

class _InputTextState extends State<InputText> {
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
    return CupertinoTextField(
      decoration: BoxDecoration(
          color: CupertinoColors.white,
          border: Border(),
          borderRadius: BorderRadius.all(Radius.circular(8))),
      controller: _controller,
      focusNode: _focusNode,
    );
  }
}
