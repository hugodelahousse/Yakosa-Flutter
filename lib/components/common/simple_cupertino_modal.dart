import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';

class SimpleCupertinoModal extends StatelessWidget {
  final String _title;
  final Widget _content;
  final String _successButton;
  final Function() _callback;

  SimpleCupertinoModal(this._title, this._content, this._successButton, this._callback);

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: Text(_title),
      content: Padding(
        padding: const EdgeInsets.only(top: 10.0),
        child: _content,
      ),
      actions: <Widget>[
        CupertinoDialogAction(
          isDefaultAction: true,
          onPressed: () => Navigator.of(context).pop(false),
          child: Text("Cancel"),
        ),
        CupertinoDialogAction(
          isDefaultAction: false,
          onPressed: () => _callback(),
          child: Text(_successButton),
        ),
      ],
    );
  }
}