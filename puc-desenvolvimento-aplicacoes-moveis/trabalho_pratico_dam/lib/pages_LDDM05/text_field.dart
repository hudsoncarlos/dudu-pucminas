import 'package:flutter/material.dart';
import '../menu/menu_footer.dart';
import '../menu/menu_lateral.dart';

class TextFieldDuDudu extends StatefulWidget{
  const TextFieldDuDudu({super.key});

  @override
  _TextFieldDuDudu createState() => _TextFieldDuDudu();
}

class _TextFieldDuDudu extends State<TextFieldDuDudu> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Entrada de dados'),
      ),
      drawer: const MenuLateralDuDudu(),
      body: ListView(
        children: <Widget>[
          const Padding(
              padding: EdgeInsets.all(32),
              child: TextField(
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  labelText: "keyboardType: TextInputType.text "
                ),
                enabled: true,
                maxLength: 20,
              ),
          ),
          const Padding(
            padding: EdgeInsets.all(32),
            child: TextField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                  labelText: "keyboardType: TextInputType.number "
              ),
              enabled: true,
              maxLength: 20,
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(32),
            child: TextField(
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                  labelText: "keyboardType: TextInputType.emailAddress "
              ),
              enabled: true,
              maxLength: 20,
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(32),
            child: TextField(
              keyboardType: TextInputType.datetime,
              decoration: InputDecoration(
                  labelText: "keyboardType: TextInputType.datetime "
              ),
              enabled: true,
              maxLength: 20,
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(32),
            child: TextField(
              keyboardType: TextInputType.datetime,
              decoration: InputDecoration(
                  labelText: "keyboardType: TextInputType.datetime com obscureText: true"
              ),
              obscureText: true,
              enabled: true,
              maxLength: 20,
            ),
          ),
          TextField(
            keyboardType: TextInputType.datetime,
            decoration: const InputDecoration(
                labelText: "Recuperar o valor digitado com 'onChanged', 'onSubmitted', 'onPressed',  "
            ),
            style: const TextStyle(
                fontSize: 30,
                color: Colors.red
            ),
            onChanged: (String value) {
              print("Texto digitado onChanged: " + value);
            },
            onSubmitted: (String value) {
              print("Texto digitado onSubmitted: " + value);
            },
          )
        ],
      ),
      bottomNavigationBar: const BarraDeNavegacaoDuDudu()
    );
  }
}