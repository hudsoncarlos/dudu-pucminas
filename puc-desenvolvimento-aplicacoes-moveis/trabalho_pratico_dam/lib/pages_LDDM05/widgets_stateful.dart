
import 'package:flutter/material.dart';
import '../menu/menu_lateral.dart';
import '../menu/menu_footer.dart';

class WidgetsStatefulDuDudu extends StatefulWidget {

  @override
  _WidgetsStatefulDuDudu createState() => _WidgetsStatefulDuDudu();
}

class _WidgetsStatefulDuDudu extends State<WidgetsStatefulDuDudu> {
  var _frase = "Seja feliz, hoje e sempre.";

  @override
  Widget build(BuildContext context) {
    print("chamado");

    return Scaffold(
        appBar: AppBar(
          title: const Text("Pensamento do dia"),
        ),
        drawer: const MenuLateralDuDudu(),
        body: Container(
            alignment: Alignment.center,
            child: Column(
                children: <Widget>[
                  ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _frase = "Substitua pensamentos negativos por pensamentos positivos.";
                        });
                      },
                      child: const Text("Clique aqui")
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text("Frase: $_frase"),
                  )
                ]
            )
        ),
        bottomNavigationBar: const BarraDeNavegacaoDuDudu()
    );
  }
}