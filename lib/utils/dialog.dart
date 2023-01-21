import 'package:flutter/material.dart';

class Dialog {
  // alert dialog
  static alertDialog(context, width, title, content, buttonText) {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Container(width: width * 80 / 100, child: Text(title)),
        content: Text(content),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, buttonText),
            child: Text(buttonText),
          ),
        ],
      ),
    );
  }
}
