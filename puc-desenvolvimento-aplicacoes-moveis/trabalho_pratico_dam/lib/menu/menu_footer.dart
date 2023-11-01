
import 'package:flutter/material.dart';

class BarraDeNavegacaoDuDudu extends StatefulWidget {
  const BarraDeNavegacaoDuDudu({super.key});

  @override
  State<BarraDeNavegacaoDuDudu> createState() => _BarraDeNavegacaoDuDudu();
}

class _BarraDeNavegacaoDuDudu extends State<BarraDeNavegacaoDuDudu> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: _currentIndex,
      items: const <BottomNavigationBarItem> [
        BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home'
        ),
        BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Minha conta'
        ),
        BottomNavigationBarItem(
            icon: Icon(Icons.account_balance),
            label: 'About'
        ),
      ],
      onTap: (index){
        setState((){
          _currentIndex = index;
        });
      }
    );
  }
}