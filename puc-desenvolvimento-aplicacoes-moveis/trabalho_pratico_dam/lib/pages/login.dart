import 'package:flutter/material.dart';

import '../main.dart';
import 'reset-password.dart';
import 'signup.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container (
        padding: EdgeInsets.only(
          top: 60,
          left: 40,
          right: 40,
        ),
        color: Colors.white,
        child: ListView(
          children:<Widget>[
            SizedBox(
              width: 128,
              height: 128,
              child: Image.asset("../assets/img/arvore-branca-gondor.png"),
            ),
            SizedBox(
              height: 20,
            ),
            TextFormField(
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText:"E-mail",
                labelStyle:TextStyle(
                  color:Colors.black38,
                  fontWeight:FontWeight.w400,
                  fontSize:20,
                ),
              ),
              style: TextStyle(
                fontSize:20,
              ),
            ),
            SizedBox(
              height:10,
            ),
            TextFormField(
              keyboardType:TextInputType.text,
              obscureText: true,
              decoration: InputDecoration(
                labelText:"Senha",
                labelStyle: TextStyle(
                  color: Colors.black38,
                  fontWeight: FontWeight.w400,
                  fontSize: 20,
                ),
              ),
              style:TextStyle(fontSize: 20),
            ),
            Container(
              height:40,
              alignment: Alignment.centerRight,
              child: TextButton(
                child: Text(
                  "Recuperar Senha",
                ),
                onPressed: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:(context)=> ResetPasswordPage(),
                    ),
                  );
                },
              ),
            ),
            SizedBox(
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
                      Text(
                        "Entrar",
                        style:TextStyle(
                          color:Colors.purple,
                          fontSize:20,
                        ),
                        textAlign: TextAlign.left,
                      ),
                      Container(
                        child:SizedBox(
                          child:Image.asset("../assets/img/monograma.jpg"),
                          height: 28,
                          width:28,
                        ),
                      ),
                    ],
                  ),
                  onPressed: () => {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HomePage(),
                      ),
                    )
                  },
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            // Container(
            //   height: 60,
            //   alignment: Alignment.centerLeft,
            //   decoration: BoxDecoration(
            //     color:Color(0xFF3C5A99),
            //     borderRadius: BorderRadius.all(
            //       Radius.circular(5),
            //     ),
            //   ),
            //   child: SizedBox.expand(
            //     child:ElevatedButton(
            //       child: Row(
            //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //         children: <Widget>[
            //           Text(
            //             "Login com Facebook",
            //             style: TextStyle(
            //               fontWeight: FontWeight.bold,
            //               color:Colors.white,
            //               fontSize:20,
            //             ),
            //             textAlign: TextAlign.left,
            //           ),
            //           Container(
            //             child: SizedBox(
            //               child: Image.asset("assets/fb-icon.png"),
            //               height: 28,
            //               width: 28,
            //             ),
            //           ),
            //         ],
            //       ),
            //       onPressed: () {},
            //     ),
            //   ),
            // ),
            SizedBox(
              height:10,
            ),
            Container(
                height: 40,
                child:ElevatedButton(
                  child: Text(
                    "Cadastre-se",
                    textAlign: TextAlign.center,
                  ),

                  onPressed: (){
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