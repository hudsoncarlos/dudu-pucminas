import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

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
  VideoPlayerController _videocontroller;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  void initState(){
    super.initState();
    _videocontroller = VideoPlayerController.network(
      //"https://sample-videos.com/video123/mp4/720/big_buck_bunny_720_1mb.mp4",
      "assets/videos/exemplo.mp4"
    )
    ..setLooping(true)
    ..initialize().then((_){});
    setState(() {
      _videocontroller.play();
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
                    child: AspectRatio(
                      aspectRatio: _videocontroller.value.aspectRatio,
                      child: VideoPlayer(_videocontroller),
                    ),
                ),
              ],
            ),
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
