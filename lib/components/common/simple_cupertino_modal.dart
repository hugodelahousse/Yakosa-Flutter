import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';

class SimpleCupertinoModal extends StatelessWidget {
  final String _title;
  final String _description;
  final String _successButton;
  final Function() _callback;

  SimpleCupertinoModal(this._title, this._description, this._successButton, this._callback);

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: Text(_title),
      content: Text(_description),
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