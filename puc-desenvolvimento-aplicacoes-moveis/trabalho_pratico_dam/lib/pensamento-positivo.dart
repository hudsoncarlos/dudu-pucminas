import 'package:flutter/material.dart';

class PensamentoPositivo extends StatefulWidget{
  @override
  _PensamentoPositivoState createState() => _PensamentoPositivoState();
}

class _PensamentoPositivoState extends State<PensamentoPositivo>{
  var _frase = "A mão queimada ensina melhor. Depois disso o conselho sobre o fogo chega ao coração.";
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(title: Text("Pensamento do Dia")),
      body: Column(
        children: <Widget>[
          Padding(
              padding: EdgeInsets.all(32),
              child: TextField(
                keyboardType: TextInputType.datetime,
                decoration: InputDecoration(
                  labelText: "Digite um valor: "
                ),
                enabled: true,
                maxLength: 2,
              ),
          ),
        ],
      ),
    );
  }
}