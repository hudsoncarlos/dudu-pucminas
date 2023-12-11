import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LDDM 12 - Web Service, Mídias, Gerenciamento de Estados',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'LDDM 12 - Web Service, Mídias, Gerenciamento de Estados'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _BuscaCepState();
}

class _BuscaCepState extends State<MyHomePage> {
  int _counter = 0;
  String _cep = "32341210";
  String _resultadoBusca = "";

  void _incrementCounter() {
    setState(() {
      _counter++;

      _recuperaCep(_cep);
      //_cep = _cep + 10;
    });
  }

  void _incrementCep() {
    setState(() {
      _counter++;
    });
  }

  void _recuperaCep(String cep) async{
    var uri = Uri.https('viacep.com.br', 'ws/$cep/json/');
    http.Response response = await http.get(uri);
    print(response.body);

    Map<String, dynamic> retorno = json.decode(response.body);
    String logradouro = retorno["logradouro"];
    String complemento = retorno["complemento"];
    String bairro = retorno["bairro"];
    String localidade = retorno["logradouro"];
    String uf = retorno["uf"];

    print("Logradouro: $logradouro \n"
        "Compremento: $complemento \n"
        "Bairro: $bairro \n"
        "Localidade: $localidade \n"
        "UF: $uf "
    );

    _incrementRetornoBuscaCep("Logradouro: $logradouro "
        "Compremento: $complemento "
        "Bairro: $bairro "
        "Localidade: $localidade "
        "UF: $uf ");
  }

  void _incrementRetornoBuscaCep(String resultado) {
    setState(() {
      _resultadoBusca = resultado;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Digíte o CEP ex: 32341210: ",
              ),
              style: const TextStyle(
                  fontSize: 20,
                  color: Colors.red
              ),
              onChanged: (String value) {
                print("Texto digitado onChanged: " + value);
              },
              onSubmitted: (String value) {
                setState(() {
                  _cep = value;
                });
                _incrementCounter();
                print("Texto digitado onSubmitted: " + value);
              },
            ),
            Text(
              "$_resultadoBusca",
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

Future<String> _recuperaCep1(String cep) async {
  var uri = Uri.https('viacep.com.br', 'ws/$cep/json/');
  http.Response response = await http.get(uri);

  print(response.body);

  return response.body;
}



