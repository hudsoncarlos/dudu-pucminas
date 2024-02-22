import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:trabalho_pratico_dam/services/util.dart';
import '../menu/menu_lateral.dart';
import 'package:http/http.dart' as http;

class HomePageDuDudu extends StatefulWidget {
  const HomePageDuDudu({super.key});

  @override
  State<HomePageDuDudu> createState() => _HomePageDuDudu();
}

class _HomePageDuDudu extends State<HomePageDuDudu> {
  String _cep = "32341210";
  String _resultadoBusca = "";

  Future<void> _recuperaCep(String cep) async {
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
        "UF: $uf ");

    var button = TextButton(
      onPressed: () {
        Navigator.of(context).pop();
      },
      child: const Text('Fechar'),
    );

    var alert = AlertDialog(
      title: const Text(":) "),
      content: Text("Logradouro: $logradouro \n "
          "Compremento: $complemento \n"
          "Bairro: $bairro \n"
          "Localidade: $localidade \n"
          "UF: $uf "),
      actions: [button],
    );

    await ShowDialog(context, alert);

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
            title: const Text('App do Dudu > Home')),
        drawer: const MenuLateralDuDudu(),
        body: ListView(children: <Widget>[
          TextField(
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: "Digíte o CEP ex: 32341210: ",
            ),
            style: const TextStyle(fontSize: 20, color: Colors.red),
            onChanged: (String value) {
              print("Texto digitado onChanged: $value");
            },
            onSubmitted: (String value) async {
              setState(() {
                _cep = value;
              });
              await _recuperaCep(_cep);
              print("Texto digitado onSubmitted: $value");
            },
          ),
          Text(
            _resultadoBusca,
          ),
          const SizedBox(height: 10),
          const Text('''
              App do Dudu
    
              O "App do Dudu" é um projeto inovador construído com a linguagem de programação Dart e o framework Flutter.
              Este aplicativo foi desenvolvido em resposta ao pedido do professor Felipe de Castro Belém como parte de um trabalho escolar
              na disciplina de Desenvolvimento de Aplicativos Móveis da Pontifícia Católica de Minas Gerais.
    
              Recursos Principais:
              - Interface Intuitiva: Design amigável e fácil de usar para uma experiência agradável.
              - Funcionalidades Específicas: Desenvolvido para atender aos requisitos do trabalho acadêmico.
              - Compatibilidade Multiplataforma: Utilizando Dart e Flutter para garantir versatilidade em dispositivos móveis.
    
              Data de Entrega do Projeto: 12/12/2023
    
              Este aplicativo é uma demonstração do compromisso com a excelência no desenvolvimento de aplicativos móveis
              e reflete a dedicação ao aprendizado na área de Desenvolvimento de Aplicativos Móveis.'''),
          const SizedBox(height: 10),
          Center(
            child: _imagemCao(),
          ),
          const SizedBox(height: 30),
        ]));
  }
}

Image _imagemCao() {
  return Image.asset(
    '../assets/img/cao.jpg',
    //width: 350,
    //height: 350,
    //fit: BoxFit.cover,
    fit: BoxFit.fill,
  );
}
