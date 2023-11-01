
import 'package:flutter/material.dart';

class AppBarDuDudu extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('App do Dudu')
    );
  }
}