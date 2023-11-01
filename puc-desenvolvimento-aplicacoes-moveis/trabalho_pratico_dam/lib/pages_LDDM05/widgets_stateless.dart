
import 'package:flutter/material.dart';
import '../menu/menu_lateral.dart';
import '../menu/menu_footer.dart';

class WidgetsStatelessDuDudu extends StatelessWidget {
  const WidgetsStatelessDuDudu({super.key});

  @override
  Widget build(BuildContext context) {
    var _titulo = "Pensamentos Positivos";

    return Scaffold(
        appBar: AppBar(
          title: Text(_titulo),
        ),
        drawer: const MenuLateralDuDudu(),
        body: ListView(
            children: const <Widget>[
              Text("Exemplo 01: 'Widgets Stateless' "),
              SizedBox(height: 20),
            ]
        ),
        bottomNavigationBar: const BarraDeNavegacaoDuDudu()
    );
  }
}