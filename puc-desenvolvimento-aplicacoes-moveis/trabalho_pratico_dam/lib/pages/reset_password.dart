import 'package:flutter/material.dart';

class ResetPasswordPage extends StatelessWidget {
  const ResetPasswordPage({super.key});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:Colors.white,
         leading: IconButton(
         icon: const Icon(Icons.arrow_back),
         color:Colors.black38,
         onPressed:()=>Navigator.pop(context, false),
        ),
      ),
      body: Container(
        padding:const EdgeInsets.only(
          top:60,
          left: 40,
          right: 40
        ),
        color: Colors.white,
        child: ListView(
          children:<Widget> [
            SizedBox(
             width: 200,
             height: 200,
             child: Image.asset("../assets/img/chave_de_erebor.jpg"),
            ),
            const SizedBox(
              height:20 ,
            ),
            const Text(
             "Esqueceu sua senha?",
             style: TextStyle(
               fontSize:32,
               fontWeight:FontWeight.w500,
                 ),
                 textAlign: TextAlign.center,
            ),
             const SizedBox(
               height: 10,
             ),
             const Text(
               "Por favor, informe o e-mail associado a sua conta que enviaremos um link para o mesmo com as intruções para a restauração de sua senha.",
               style: TextStyle(
                 fontSize: 16,
                 fontWeight: FontWeight.w400,
               ),
               textAlign: TextAlign.center,
             ),
             const SizedBox(
               height: 20,
             ),
             TextFormField(
               keyboardType:TextInputType.emailAddress,
               decoration:const InputDecoration(
                 labelText: "E-mail",
                 labelStyle: TextStyle(
                   color:Colors.black38,
                   fontWeight:FontWeight.w400,
                   fontSize:20,
                    ),
               ),
               style:const TextStyle(
                 fontSize: 20,
                 ),
             ),
             const SizedBox(
               height: 20,
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
                        "Recuperar",
                        style: TextStyle(
                          fontSize:20,
                        ),
                        textAlign: TextAlign.left,
                      ),
                      Container(
                        child:SizedBox(
                          height: 150,
                          width:40,
                          child: Image.asset("../assets/img/tolkien_monogram.png"),
                        ),
                      ),
                    ],
                  ),
                  onPressed: () => Navigator.pop(context, false),
                ),
              ),
            ),
             const SizedBox(
               height: 20,
             ),
         ],
       ),
      ),
    );
  }
}
