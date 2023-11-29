
import 'package:flutter/material.dart';
import '../main.dart';
import 'reset_password.dart';
import 'signup.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container (
        padding: const EdgeInsets.only(
          top: 60,
          left: 40,
          right: 40,
        ),
        color: Colors.white,
        child: ListView(
          children:<Widget>[
            SizedBox(
              width: 200,
              height: 200,
              child: Image.asset("../assets/img/arvore-branca-gondor.png"),
            ),
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText:"E-mail",
                labelStyle:TextStyle(
                  color:Colors.black38,
                  fontWeight:FontWeight.w400,
                  fontSize:20,
                ),
              ),
              style: const TextStyle(
                fontSize:20,
              ),
            ),
            const SizedBox(
              height:10,
            ),
            TextFormField(
              keyboardType:TextInputType.text,
              obscureText: true,
              decoration: const InputDecoration(
                labelText:"Senha",
                labelStyle: TextStyle(
                  color: Colors.black38,
                  fontWeight: FontWeight.w400,
                  fontSize: 20,
                ),
              ),
              style:const TextStyle(fontSize: 20),
            ),
            Container(
              height:40,
              alignment: Alignment.centerRight,
              child: TextButton(
                child: const Text(
                  "Recuperar Senha",
                ),
                onPressed: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ResetPasswordPage(),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            Container(
              height:60,
              alignment: Alignment.center,
              child: SizedBox.expand(
                child: ElevatedButton(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      const Text(
                        "Entrar",
                        style: TextStyle(
                          fontSize: 20,
                        ),
                        textAlign: TextAlign.left,
                      ),
                      SizedBox(
                        height: 150,
                        width:40,
                        child: Image.asset("../assets/img/tolkien_monogram.png"),
                      ),
                    ],
                  ),
                  onPressed: () => {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const HomePage(),
                      ),
                    )
                  },
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const SizedBox(
              height:10,
            ),
            Container(
                height: 40,
                alignment: Alignment.center,
                child: ElevatedButton(
                  child: const Text(
                    "Cadastre-se",
                    textAlign: TextAlign.center,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SignupPage(),
                      ),
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