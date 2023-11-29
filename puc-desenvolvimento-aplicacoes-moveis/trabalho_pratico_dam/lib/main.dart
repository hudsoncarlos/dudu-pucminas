import 'package:flutter/material.dart';
import 'menu/menu_footer.dart';
import 'menu/menu_lateral.dart';
import 'pages/login.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Primeiro Trabalho Prático - Desenvolvimento de Aplicações Móveis',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      //home: const MyHomePageStatefulWidget(title: 'App do Dudu'),
      // home: const HomePage(),
      home: const LoginPage(),
    );
  }
}

Image _imagemCao(){
  return Image.asset('../assets/img/cao.jpg',
    // width: 350,
    // height: 350,
    // fit: BoxFit.cover,
    fit: BoxFit.fill,
  );
}

class HomePage extends StatelessWidget{
  const HomePage({super.key});

  @override
  Widget build(BuildContext context){
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            title: const Text('App do Dudu')
        ),
        drawer: const MenuLateralDuDudu(),
        body: Container(
          color: Colors.white,
          child: Center(
            child: _imagemCao(),
          ),
        ),
        bottomNavigationBar: const BarraDeNavegacaoDuDudu()
    );
  }
}

class MyHomePageStatefulWidget extends StatefulWidget {
  const MyHomePageStatefulWidget({super.key, required this.title});

  final String title;

  @override
  State<MyHomePageStatefulWidget> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePageStatefulWidget> {
  int _counter = 0;

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
      drawer: const Drawer(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Você apertou o botão tantas vezes:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: const BarraDeNavegacaoDuDudu()
    );
  }
}
