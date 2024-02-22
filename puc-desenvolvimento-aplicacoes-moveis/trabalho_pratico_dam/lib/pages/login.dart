import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home_page.dart';
import 'reset_password.dart';
import 'signup.dart';

TextEditingController _emailController = TextEditingController();
TextEditingController _senhaController = TextEditingController();

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container (
        padding: const EdgeInsets.only(top: 60, left: 40, right: 40),
        color: Colors.white,
        child: ListView(
          children:<Widget>[
            SizedBox(width: 200, height: 200, child: Image.asset("../assets/img/arvore-branca-gondor.png")),
            const SizedBox(height: 20),
            TextField(
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText:"E-mail",
                labelStyle:TextStyle(color:Colors.black38, fontWeight:FontWeight.w400, fontSize:20),
              ),
              style: const TextStyle(fontSize:20),
              controller: _emailController,
            ),
            const SizedBox(height:10),
            TextField(
              keyboardType:TextInputType.text,
              obscureText: true,
              decoration: const InputDecoration(
                labelText:"Senha",
                labelStyle:TextStyle(color:Colors.black38, fontWeight:FontWeight.w400, fontSize:20),
              ),
              style:const TextStyle(fontSize: 20),
              controller: _senhaController,
            ),
            Container(
              height:40,
              alignment: Alignment.centerRight,
              child: TextButton(
                child: const Text("Recuperar Senha"),
                onPressed: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ResetPasswordPage(),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 40),
            Container(
              height:60,
              alignment: Alignment.center,
              child: SizedBox.expand(
                child: ElevatedButton(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      const Text("Entrar", style: TextStyle(fontSize: 20), textAlign: TextAlign.left),
                      SizedBox(height: 150, width:40, child: Image.asset("../assets/img/tolkien_monogram.png")),
                    ],
                  ),
                  onPressed: () async {

                    String? result = await _RecuperarDados(_emailController.text, _senhaController.text);
                    AlertDialog alert;
                    Widget button;

                    if(result != null){
                      print("Olá $result.");

                      button = TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const HomePageDuDudu()),
                          );
                        },
                        child: const Text('OK'),
                      );

                      alert = AlertDialog(
                        title: const Text("Olá"),
                        content: Text(result),
                        actions: [button],
                      );
                    }else{
                      button = TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('Fechar'),
                      );

                      alert = AlertDialog(
                        title: const Text("Atenção"),
                        content: const Text("Usuário ou senha inválido."),
                        actions: [button],
                      );
                    }

                    await _ShowDialog(context, alert);
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              height: 40,
              alignment: Alignment.center,
              child: ElevatedButton(
                child: const Text("Cadastre-se", textAlign: TextAlign.center),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SignupPage()),
                  );
                },
              )
            ),
          ],
        ),
      ),
    );
  }
}

Future<void> _ShowDialog(BuildContext context, AlertDialog alert) async {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

Future<String?> _RecuperarDados(String email, String senha) async {
  String key = "$email-$senha";
  print("Chave: $key");

  final perfs = await SharedPreferences.getInstance();
  String? result = perfs.getString(key);

  print("Operação recuperação: $result");

  return result;
}

Future<bool> _ValidaChaveExistente(String email, String senha) async {
  String key = "$email-$senha";
  print("Chave: $key");

  final perfs = await SharedPreferences.getInstance();
  String? result = perfs.getString(key);

  print("Operação valida chave existente: $result");

  return result != null;
}