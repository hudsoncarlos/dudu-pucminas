import 'package:flutter/material.dart';

void main() {
  runApp(
      const PrimeiraTela()
  );
}

class PrimeiraTela extends StatelessWidget {
  const PrimeiraTela({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PUC - Desenvolvimento de Aplicativos Móveis com Flutter.',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: const MyHomePagePrimeiraTela(
          title: 'Primeira Tela'
      ),
    );
  }
}

class SegundaTela extends StatelessWidget {
  const SegundaTela({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PUC - Desenvolvimento de Aplicativos Móveis com Flutter.',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: const MyHomePagePrimeiraTela(
          title: 'Segunda Tela'
      ),
    );
  }
}

class MyHomePagePrimeiraTela extends StatefulWidget {
  const MyHomePagePrimeiraTela({super.key, required this.title});

  final String title;

  @override
  State<MyHomePagePrimeiraTela> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePagePrimeiraTela> {
  int _counter = 0;
  double _currentSliderValue = 50;

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
      body: Center(
        child: Center(
          child:
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                children: [
                  FilledButton(
                      child: Text("Ir para a segunda tela",
                          style: TextStyle(
                              fontSize: 20
                          )
                      ),
                      onPressed: (){
                        Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (context) => SegundaTela()
                          )
                        );
                      }
                    )
                ],
              ),
              Row(
                children: [
                  Column(
                    children: [
                      Icon(Icons.kitchen, color: Colors.green[500]),
                      const Text('PREP:'),
                      const Text('25 min'),
                    ],
                  ),
                  Column(
                    children: [
                      Icon(Icons.timer, color: Colors.green[500]),
                      const Text('COOK:'),
                      const Text('1 hr'),
                    ],
                  ),
                  Column(
                    children: [
                      Icon(Icons.restaurant, color: Colors.green[500]),
                      const Text('FEEDS:'),
                      const Text('4-6'),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),

      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class MyHomePageSegundaTela extends StatefulWidget {
  const MyHomePageSegundaTela({super.key, required this.title});

  final String title;

  @override
  State<MyHomePageSegundaTela> createState() => _MyHomePageSegundaTelaState();
}

class _MyHomePageSegundaTelaState extends State<MyHomePageSegundaTela> {
  int _counter = 0;
  double _currentSliderValue = 50;

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
      body: Center(
        child:
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Slider(
              value: _currentSliderValue,
              min: 0,
              max: 100,
              divisions: 10,
              label: _currentSliderValue.round().toString(),
              onChanged: (double novoValor) {
                setState(() {
                  _currentSliderValue = novoValor;
                });
              },
            ),
            ElevatedButton(
                child: Text("Salvar",
                    style: TextStyle(
                        fontSize: 20
                    )
                ),
                onPressed: (){
                  print("Valor salvo: " + _currentSliderValue.toString());
                }),
          ],
        ),
      ),
       // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
