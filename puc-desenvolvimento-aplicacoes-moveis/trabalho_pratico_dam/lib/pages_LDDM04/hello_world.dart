import 'package:flutter/material.dart';
import '../menu/menu_lateral.dart';

class HelloWorldDuDudu extends StatelessWidget {
  const HelloWorldDuDudu({super.key});

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('App do Dudu'),
      ),
      drawer: const MenuLateralDuDudu(),
      body: ListView(
            children: <Widget>[
              const SizedBox(
                height: 30,
              ),
              const Center(
                child: Text("Hello World"),
              ),
              const SizedBox(
                height: 30,
              ),
              const TextField(decoration: InputDecoration(labelText: "TextField - Hello World")),
              const SizedBox(
                height: 30,
              ),
              const Align(
                alignment: Alignment.center,
                child: SizedBox(
                  width: 150,
                  child: TextField(
                    decoration: InputDecoration(labelText: "Align - Hello World"),
                    style: TextStyle(color: Colors.purple, fontSize: 20),
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              ElevatedButton(
                  onPressed: (){},
                  child: const Text('ElevatedButton - Clique aqui')
              )
            ]
        )
    );
  }
}