import 'package:flutter/material.dart';
import '../menu/menu_lateral.dart';

class AboutPageDuDudu extends StatefulWidget {
  const AboutPageDuDudu({super.key});

  @override
  State<AboutPageDuDudu> createState() => _AboutPageDuDudu();
}

class _AboutPageDuDudu extends State<AboutPageDuDudu> {

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text('App do Dudu > About')
      ),
      drawer: const MenuLateralDuDudu(),
      body: ListView(
        children: <Widget>[
          const SizedBox(height: 10),
          const Text('''
            App do Dudu

            O "App do Dudu" é um projeto inovador construído com a linguagem de programação Dart e o framework Flutter.
            Este aplicativo foi desenvolvido em resposta ao pedido do professor Felipe de Castro Belém como parte de um trabalho escolar
            na disciplina de Desenvolvimento de Aplicativos Móveis da Pontifícia Católica de Minas Gerais.

            Recursos Principais:
            - Interface Intuitiva: Design amigável e fácil de usar para uma experiência agradável.
            - Funcionalidades Específicas: Desenvolvido para atender aos requisitos do trabalho acadêmico.
            - Compatibilidade Multiplataforma: Utilizando Dart e Flutter para garantir versatilidade em dispositivos móveis.

            Data de Entrega do Projeto: 12/12/2023

            Este aplicativo é uma demonstração do compromisso com a excelência no desenvolvimento de aplicativos móveis
            e reflete a dedicação ao aprendizado na área de Desenvolvimento de Aplicativos Móveis.'''
          ),
          const SizedBox(height: 10),
          Center(
            child: _imagemCao(),
          ),
          const SizedBox(height: 30),
        ]
      )
    );
  }
}

Image _imagemCao(){
  return Image.asset('../assets/img/cao02.jpg',
     width: 350,
     height: 350,
    //fit: BoxFit.cover,
    //fit: BoxFit.fill,
  );
}