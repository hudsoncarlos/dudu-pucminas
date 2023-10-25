import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  final String texto;

  Home(this.texto);

  @override
  Widget build(BuildContext context)
  {
    return Container(
      child: Center(
        child: Text(texto),
      ),
    );
  }
}
