import 'package:flutter/material.dart';
import 'package:trabalho_pratico_dam/menu/menu.dart';

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
      home: LoginPage(),
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
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context){
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text('App do Dudu'),
        ),
        drawer: NavDrawer(),
        body: Container(
          color: Colors.white,
          child: Center(
            child: _imagemCao(),
          ),
        ),
        // body: ElevatedButton(
        //   onPressed: (){},
        //   child: Text('Press here'),
        // ),
        // body: Align(
        //   alignment: Alignment.center,
        //   child: Container(
        //     width: 150,
        //     child: TextField(
        //       decoration: InputDecoration(labelText: 'Hello World'),
        //       style: TextStyle(color: Colors.purple, fontSize: 20),
        //     ),
        //   ),
        // ),
        // body: Center(
        //   child: Column(
        //     mainAxisAlignment: MainAxisAlignment.center,
        //     children: <Widget>[
        //       const Text(
        //         'Você apertou o botão tantas vezes:',
        //       ),
        //       Text(""
        //         //'$_counter',
        //         //style: Theme.of(context).textTheme.headlineMedium,
        //       ),
        //     ],
        //   ),
        // ),
        bottomNavigationBar: BottomNavigationBar(
          items: <BottomNavigationBarItem> [
            BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home'
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Minha conta'
            ),
          ],
        )// This trailing comma makes auto-formatting nicer for build methods.
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
      drawer: Drawer(),
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
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem> [
          BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home'
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Minha conta'
          ),
        ],
      )// This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
