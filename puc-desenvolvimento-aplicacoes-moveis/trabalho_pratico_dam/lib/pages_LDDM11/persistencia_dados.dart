import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  //var _textoSalvo;
  var _nomeDigitado = " - ";

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    String textoSalvo;

    void salvarDados() async {
      String valorDigitado = _nomeDigitado;
      final perfs = await SharedPreferences.getInstance();
      await perfs.setString("nome", valorDigitado);
      print("Operação salva: $valorDigitado");
    }

    void RecuperarDados() async {
      final perfs = await SharedPreferences.getInstance();
      setState(() {
        textoSalvo = perfs.getString("nome") ?? "Sem valor";
      });
      //print("Operação recuperar: $textoSalvo");
    }

    void removerDados() async {
      final perfs = await SharedPreferences.getInstance();
      perfs.remove("nome");
      print("Operação remover");
    }

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
        ),
        body: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: <Widget>[
              TextField(
                  decoration: const InputDecoration(
                    labelText: "Digíte o nome: ",
                  ),
                  onSubmitted: (String value) {
                    setState(() {
                      _nomeDigitado = value;
                    });
                    print("Texto digitado onSubmitted: $value");
                  }),
              const SizedBox(
                height: 16,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  ElevatedButton(
                      onPressed: salvarDados, child: const Text("Salvar")),
                  const SizedBox(
                    width: 16,
                  ),
                  ElevatedButton(
                      onPressed: RecuperarDados,
                      child: const Text("Recuperar")),
                  const SizedBox(
                    width: 16,
                  ),
                  ElevatedButton(
                      onPressed: removerDados, child: const Text("Remover")),
                ],
              ),
              const SizedBox(
                width: 16,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[Text(_nomeDigitado)],
              ),
            ],
          ),
        ));
  }
}
