
import 'package:flutter/material.dart';
import '../menu/menu_lateral.dart';
import '../menu/menu_footer.dart';

class ImagensDuDudu extends StatelessWidget {
  const ImagensDuDudu({super.key});

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
              const Text("Exemplo 01: 'Center'"),
              Container(
                color: Colors.white,
                child: Center(
                  child: Image.asset('../assets/img/cao02.jpg')
                ),
              ),
              const SizedBox(height: 20),
              const Text("Exemplo 02: 'BoxFit.cover'. "),
              Image.asset('../assets/img/cao03.jpg', width: 350, height: 350, fit: BoxFit.cover),
              const SizedBox(height: 20),
              const Text("Exemplo 03: 'BoxFit.fill'. "),
              Image.asset('../assets/img/cao03.jpg', width: 350, height: 350, fit: BoxFit.fill),
              const SizedBox(height: 20),
              const Text("Exemplo 04: 'URL Network'. "),
              Container(
                color: Colors.white,
                child: Center(
                    //child: Image.network("https://i0.wp.com/www.portaldodog.com.br/cachorros/wp-content/uploads/2014/09/bebe-carter-e-cachorro-toby.png?ssl=1")
                    child: Image.asset('../assets/img/cao04.jpg')
                ),
              ),
              const SizedBox(height: 20),
              const Text("Exemplo 05: 'SizedBox', ao tentar utiliza-lo o app trava. "),
              // Container(
              //   color: Colors.white,
              //   child: SizedBox.expand(
              //     child: _imagemCao(),
              //   ),
              // ),
              const SizedBox(height: 20),
            ]
        ),
        bottomNavigationBar: const BarraDeNavegacaoDuDudu()
    );
  }
}

Image _imagemCao(){
  return Image.asset('../assets/img/cao4.jpg',
    // width: 350,
    // height: 350,
    // fit: BoxFit.cover,
    fit: BoxFit.fill,
  );
}