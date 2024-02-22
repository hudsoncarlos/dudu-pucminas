
import 'package:flutter/material.dart';

class AppBarDuDudu extends StatelessWidget {
  const AppBarDuDudu({super.key});


  @override
  Widget build(BuildContext context) {
    return AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('App do Dudu')
    );
  }
}