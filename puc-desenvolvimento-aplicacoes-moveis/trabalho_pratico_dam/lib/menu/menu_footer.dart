
import 'package:flutter/material.dart';

class BarraDeNavegacaoDuDudu extends StatelessWidget {
  const BarraDeNavegacaoDuDudu({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem> [
        BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home'
        ),
        BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Minha conta'
        ),
      ],
    );
  }
}