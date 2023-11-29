
import 'package:flutter/material.dart';
import '../menu/menu_lateral.dart';
import 'about-page.dart';

class HomePageDuDudu extends StatefulWidget {
  const HomePageDuDudu({super.key});

  @override
  State<HomePageDuDudu> createState() => _HomePageDuDudu();
}

class _HomePageDuDudu extends State<HomePageDuDudu> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context){
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            title: const Text('App do Dudu')
        ),
        drawer: const MenuLateralDuDudu(),
        body: IndexedStack(index: _currentIndex, children: const [HomePageDuDudu(), AboutPageDuDudu()]),
        bottomNavigationBar: BottomNavigationBar(
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
        )
    );
  }
}