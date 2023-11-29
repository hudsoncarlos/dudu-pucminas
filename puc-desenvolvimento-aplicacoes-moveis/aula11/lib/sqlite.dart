import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  get _nomeController => null;

  get _senhaController => null;

  _recuperarBancoDados() async{
    final caminhoBD = await getDatabasesPath();
    final localBD = join(caminhoBD, "banco.db");
    var retorno = await openDatabase(
        localBD,
        version: 1,
        onCreate: (db, dbVersaoRecente){
          String sql = "CREATE TABLE usuarios (id INTERGER PRIMARY KEY AUTOINCREMENT, nome VARCHAR, idade INTERGER)";
          db.execute(sql);
        }
    );
    print("Aberto ${retorno.isOpen}");
  }

  _listarUsuarios() async{
    Database bd = await _recuperarBancoDados();
    String sql = "SELECT * FROM usuarios";
    List usuarios = await bd.rawQuery(sql);
    for(var usuario in usuarios){
      print(" id: $usuario['id'] nome: $usuario['nome'] idade: $usuario['idade'] ");
    }
  }

  _getUsuario(int id) async{
    Database bd = await _recuperarBancoDados();
    List usuarios = await bd.query(
        "usuarios",
        columns: ["id", "nome", "idade"],
        where: "id = ?",
        whereArgs: [id]
    );
    for(var usuario in usuarios){
      print(" id: $usuario['id'] nome: $usuario['nome'] idade: $usuario['idade'] ");
    }
  }

  _excluirUsuario(int id) async{
    Database bd = await _recuperarBancoDados();
    int retorno1 = await bd.delete(
        "usuarios",
        where: "id = ?",
        whereArgs: [id]
    );
    int retorno2 = await bd.delete(
        "usuarios",
        where: "nome = ? AND idade = ?",
        whereArgs: ["Raquel Ribeiro", id]
    );
    print("Itens excluidos: $retorno1");
    print("Itens excluidos: $retorno2");
  }

  _atualizarUsuario(int id) async{
    Database bd = await _recuperarBancoDados();
    Map<String, dynamic> dadosUsuario = {
      "nome" : "Antonio Pedro",
      "idade" : 35
    };
    int retorno = await bd.update(
        "usuarios", dadosUsuario,
        where: "id = ?",
        whereArgs: [id]
    );
    print("Itens atualizados: $retorno ");
  }

  _salvarDados(String nome, int idade) async{
    Database bd = await _recuperarBancoDados();
    Map<String, dynamic> dadosUsuario = {
      "nome" : nome,
      "idade" : idade
    };
    int id = await bd.insert("usuarios", dadosUsuario);
    print("Salvo: $id ");
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
        ),
        body: Container(
          padding: EdgeInsets.all(16),
          child: Column(
            children: <Widget>[
              TextField(decoration: const InputDecoration(labelText: "Digíte o nome: ",), controller: _nomeController,),
              const SizedBox(height: 16,),
              TextField(decoration: const InputDecoration(labelText: "Digíte a senha: ",), controller: _senhaController),
              const SizedBox(height: 16,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  ElevatedButton( onPressed: _salvarDados(_nomeController, 0), child: const Text("Salvar um usuário")),
                  const SizedBox(width: 16,),
                  ElevatedButton(onPressed: _listarUsuarios, child: const Text("Listar todos usuários")),
                  const SizedBox(width: 16,),
                  ElevatedButton(onPressed: _getUsuario(1), child: const Text("Buscar um usuário")),
                  const SizedBox(width: 16,),
                  ElevatedButton(onPressed: _atualizarUsuario(1), child: const Text("Atualizar um usuário")),
                  const SizedBox(width: 16,),
                  ElevatedButton(onPressed: _excluirUsuario(1), child: const Text("Excluir usuário")),
                ],
              ),
            ],
          ),
        )
    );
  }
}
