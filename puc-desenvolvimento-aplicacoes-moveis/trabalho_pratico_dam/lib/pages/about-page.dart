
import 'package:flutter/material.dart';
import '../menu/menu_footer.dart';
import '../menu/menu_lateral.dart';
import 'home_page.dart';

class AboutPageDuDudu extends StatefulWidget {
  const AboutPageDuDudu({super.key});

  @override
  State<AboutPageDuDudu> createState() => _AboutPageDuDudu();
}

class _AboutPageDuDudu extends State<AboutPageDuDudu> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context){
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            title: const Text('App do Dudu')
        ),
        drawer: const MenuLateralDuDudu(),
        body: Container(
          color: Colors.white,
          child: Center(
            child: _imagemCao(),
          ),
        ),
        bottomNavigationBar: const BarraDeNavegacaoDuDudu()
    );
  }
}

Image _imagemCao(){
  return Image.asset('../assets/img/cao02.jpg',
    // width: 350,
    // height: 350,
    // fit: BoxFit.cover,
    fit: BoxFit.fill,
  );
}