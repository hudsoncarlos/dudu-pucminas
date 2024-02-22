import 'package:flutter/material.dart';

Future<void> ShowDialog(BuildContext context, AlertDialog alert) async {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}