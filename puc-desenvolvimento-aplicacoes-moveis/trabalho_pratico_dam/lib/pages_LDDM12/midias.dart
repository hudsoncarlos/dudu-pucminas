import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

import '../services/util.dart';

class MidiaSonsDuDudu extends StatefulWidget {
  const MidiaSonsDuDudu({super.key});

  @override
  State<MidiaSonsDuDudu> createState() => _AudioPlayerState();
}

class _AudioPlayerState extends State<MidiaSonsDuDudu> {
  int _counter = 0;

  AudioPlayer audioPlayer = AudioPlayer();
  String url = "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-2.mp3";
  AudioCache audioCache = AudioCache(prefix: "../assets/audios/");
  bool primeiraExecucao = true;
  double volume = 0.5;

  _executar() async {
    audioPlayer.setVolume(volume);
    if (primeiraExecucao == true) {
      //audioPlayer = await audioCache.play("musica.mp3");
      primeiraExecucao = false;
    } else {
      audioPlayer.resume();
    }

    var button = TextButton(
      onPressed: () {
        Navigator.of(context).pop();
      },
      child: const Text('Fechar'),
    );

    var alert = AlertDialog(
      title: const Text(":) "),
      content: const Text("Executando..."),
      actions: [button],
    );

    await ShowDialog(context, alert);
  }

  _pausar() async {
    //int resultado = await audioPlayer.pause();
    // if (resultado == 1) {
    //   // sucesso
    // }

    var button = TextButton(
      onPressed: () {
        Navigator.of(context).pop();
      },
      child: const Text('Fechar'),
    );

    var alert = AlertDialog(
      title: const Text(":) "),
      content: const Text("Pausando..."),
      actions: [button],
    );

    await ShowDialog(context, alert);
  }

  _parar() async {
    // int resultado = await audioPlayer.stop();
    // if (resultado == 1) {
    //   // sucesso
    // }

    var button = TextButton(
      onPressed: () {
        Navigator.of(context).pop();
      },
      child: const Text('Fechar'),
    );

    var alert = AlertDialog(
      title: const Text(":) "),
      content: const Text("Parando..."),
      actions: [button],
    );

    await ShowDialog(context, alert);
  }

  _executarDog() async {
    //audioPlayer = await audioPlayer.play("dog.mp3");
    var button = TextButton(
      onPressed: () {
        Navigator.of(context).pop();
      },
      child: const Text('Fechar'),
    );

    var alert = AlertDialog(
      title: const Text(":) "),
      content: const Text("Executando som de cachorro..."),
      actions: [button],
    );

    await ShowDialog(context, alert);
  }

  _executarCat() async {
    //audioPlayer = await audioPlayer.play("cat.mp3");

    var button = TextButton(
      onPressed: () {
        Navigator.of(context).pop();
      },
      child: const Text('Fechar'),
    );

    var alert = AlertDialog(
      title: const Text(":) "),
      content: const Text("Executando som de gato..."),
      actions: [button],
    );

    await ShowDialog(context, alert);
  }

  _executarCow() async {
    //audioPlayer = await audioPlayer.play("cow.mp3");

    var button = TextButton(
      onPressed: () {
        Navigator.of(context).pop();
      },
      child: const Text('Fechar'),
    );

    var alert = AlertDialog(
      title: const Text(":) "),
      content: const Text("Executando som de vaca..."),
      actions: [button],
    );

    await ShowDialog(context, alert);
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
        title: const Text("Sons dos Animais"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: GestureDetector(
                    child: Image.asset("../assets/img/dog.png"),
                    onTap: () {
                      _executarDog();
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: GestureDetector(
                    child: Image.asset("../assets/img/cat.png"),
                    onTap: () {
                      _executarCat();
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: GestureDetector(
                    child: Image.asset("../assets/img/cow.png"),
                    onTap: () {
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
                  padding: const EdgeInsets.all(8),
                  child: GestureDetector(
                    child: Image.asset("../assets/img/executar.png"),
                    onTap: () {
                      _executar();
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: GestureDetector(
                    child: Image.asset("../assets/img/pausar.png"),
                    onTap: () {
                      _pausar();
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: GestureDetector(
                    child: Image.asset("../assets/img/parar.png"),
                    onTap: () {
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
                  padding: const EdgeInsets.all(8),
                  child: Slider(
                    value: volume,
                    min: 0,
                    max: 1,
                    divisions: 10,
                    onChanged: (novoVolume) {
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
