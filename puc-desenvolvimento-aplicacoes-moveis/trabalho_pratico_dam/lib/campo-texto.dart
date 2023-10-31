import 'package:flutter/material.dart';

class CampoTexto extends StatefulWidget{
  @override
  _CampoTextoState createState() => _CampoTextoState();
}

class _CampoTextoState extends State<CampoTexto>{
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(title: Text("Entrada de dados")),
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