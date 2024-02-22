import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'login.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  _SignupPage createState() => _SignupPage();
}

TextEditingController _nomeController = TextEditingController();
TextEditingController _emailController = TextEditingController();
TextEditingController _senhaController = TextEditingController();

class _SignupPage extends State<SignupPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.only(top: 60, left: 40, right: 40),
        color: Colors.white,
        child: ListView(
          children: <Widget>[
            SizedBox(width: 200, height: 200, child: Image.asset("../assets/img/arvore-branca-gondor.png")),
            const SizedBox(height: 20),
            TextField(
              autofocus: true,
              keyboardType: TextInputType.text,
              style: const TextStyle(fontSize: 20),
              controller: _nomeController,
              decoration: const InputDecoration(
                labelText: "Nome",
                labelStyle: TextStyle(color: Colors.black38, fontWeight: FontWeight.w400, fontSize: 20),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: "E-mail",
                labelStyle: TextStyle(color: Colors.black38, fontWeight: FontWeight.w400, fontSize: 20),
              ),
              style: const TextStyle(fontSize: 20),
              controller: _emailController,
            ),
            const SizedBox(height: 10),
            TextField(
              keyboardType: TextInputType.text,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: "Senha",
                labelStyle: TextStyle(color: Colors.black38, fontWeight: FontWeight.w400, fontSize: 20),
              ),
              style: const TextStyle(fontSize: 20),
              controller: _senhaController,
            ),
            const SizedBox(height: 20),
            Container(
              height: 60,
              alignment: Alignment.center,
              child: SizedBox.expand(
                child: ElevatedButton(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      const Text("Cadastrar", style: TextStyle(fontSize: 20), textAlign: TextAlign.left),
                      SizedBox(height: 150, width: 40, child: Image.asset("../assets/img/tolkien_monogram.png")),
                    ],
                  ),
                  onPressed: () {
                    _SalvarDadosFormulario(context);
                  },
                ),
              ),
            ),
            const SizedBox(height: 10),
            Container(
              height: 40,
              alignment: Alignment.center,
              child: ElevatedButton(
                child: const Text(
                  "Cancelar",
                  textAlign: TextAlign.center,
                ),
                onPressed: () => Navigator.pop(context, false),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void _SalvarDadosFormulario(BuildContext context) async{
  String email = _emailController.text;
  String senha = _senhaController.text;

  String key = "$email-$senha";
  String valor = _nomeController.text;
  AlertDialog alert;
  Widget button;

  if(!await _ValidaChaveExistente(key)){
    await _SalvarDados(key, valor);

    button = TextButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
      },
      child: const Text('OK'),
    );

    alert = AlertDialog(
      title: const Text(":)"),
      content: const Text("Cadastro com sucesso."),
      actions: [button],
    );
  }
  else{
    print("Dados já cadastrados.");

    button = TextButton(
      onPressed: () {
        Navigator.of(context).pop();
      },
      child: const Text('Fechar'),
    );

    alert = AlertDialog(
      title: const Text("Atenção"),
      content: const Text("Dados já cadastrados."),
      actions: [button],
    );

    //_ExibirAlerta(context, "Atenção", "Dados já cadastrados.");
  }

  await _ShowDialog(context, alert);
}

Future<void> _ShowDialog(BuildContext context, AlertDialog alert) async {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

void _ExibirAlerta(BuildContext context, String titulo, String conteudo) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(titulo),
        content: Text(conteudo),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Fechar'),
          ),
        ],
      );
    },
  );
}

Future<void> _SalvarDados(String key, String value) async{
  print("Chave: $key");
  print("Valor: $value");

  final perfs = await SharedPreferences.getInstance();
  await perfs.setString(key, value);

  print("Operação salva: $key - $value");
}

Future<bool> _ValidaChaveExistente(String key) async {
  print("Chave: $key");

  final perfs = await SharedPreferences.getInstance();
  String? result = perfs.getString(key);

  print("Operação valida chave existente: $result");

  return result != null;
}

Future<String> _RecuperarDados(String key) async {
  print("Chave: $key");

  final perfs = await SharedPreferences.getInstance();
  String result = perfs.getString(key) ?? "Sem valor";

  print("Operação recuperar: $result");
  
  return result;
}