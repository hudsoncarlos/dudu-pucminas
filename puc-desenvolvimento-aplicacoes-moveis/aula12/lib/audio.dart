import 'dart:js_interop_unsafe';

import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LDDM 12 - Web Service, Mídias, Gerenciamento de Estados',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'LDDM 12 - Web Service, Mídias, Gerenciamento de Estados'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _AudioPlayerState();
}

class _AudioPlayerState extends State<MyHomePage> {
  int _counter = 0;

  AudioPlayer audioPlayer = AudioPlayer();
  String url = "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-2.mp3";
  AudioCache audioCache = AudioCache(prefix: "assets/audios/");
  bool primeiraExecucao = true;
  double volume = 0.5;

  _executar() async{
    audioPlayer.setVolume(volume);
    if(primeiraExecucao == true){
      audioPlayer = await audioPlayer.play("musica.mp3");
      primeiraExecucao = false;
    }else{
      audioPlayer.resume();
    }
  }

  _pausar() async{
    int resultado = await audioPlayer.pause();
    if(resultado == 1){
      // sucesso
    }
  }

  _parar() async{
    int resultado = await audioPlayer.stop();
    if(resultado == 1){
      // sucesso
    }
  }

  _executarDog() async{
    audioPlayer = await audioPlayer.play("dog.mp3");
  }

  _executarCat() async{
    audioPlayer = await audioPlayer.play("cat.mp3");
  }

  _executarCow() async{
    audioPlayer = await audioPlayer.play("cow.mp3");
  }

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
        title: Text("Sons dos Animais"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                    padding: EdgeInsets.all(8),
                    child: GestureDetector(
                      child: Image.asset("asserts/images/dog.png"),
                      onTap: (){
                        _executarDog();
                      },
                    ),
                ),
                Padding(
                  padding: EdgeInsets.all(8),
                  child: GestureDetector(
                    child: Image.asset("asserts/images/cat.png"),
                    onTap: (){
                      _executarCat();
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8),
                  child: GestureDetector(
                    child: Image.asset("asserts/images/cow.png"),
                    onTap: (){
                      _executarCow();
                    },
                  ),
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(8),
                  child: GestureDetector(
                    child: Image.asset("asserts/images/executar.png"),
                    onTap: (){
                      _executar();
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8),
                  child: GestureDetector(
                    child: Image.asset("asserts/images/pausar.png"),
                    onTap: (){
                      _pausar();
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8),
                  child: GestureDetector(
                    child: Image.asset("asserts/images/parar.png"),
                    onTap: (){
                      _parar();
                    },
                  ),
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(8),
                  child: Slider(
                    value: volume,
                    min: 0,
                    max: 1,
                    divisions: 10,
                    onChanged: (novoVolume){
                      setState(() {
                        volume = novoVolume;
                      });
                      audioPlayer.setVolume(novoVolume);
                    },
                  ),
                ),
              ],
            )
          ],
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
