import 'package:flutter/material.dart';

class AlertBoxes {
  Future<Widget> simpleAlertBox(context, Text title, Text description,
      Function onPressed) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: title,
            content: description,
            actions: [
              TextButton(onPressed: onPressed,
                  child: Text('Ok', style: TextStyle(color: Colors.black),))
            ],
          );
        });
  }
}