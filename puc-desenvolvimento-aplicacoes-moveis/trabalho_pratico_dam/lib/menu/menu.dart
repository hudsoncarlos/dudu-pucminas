import 'package:flutter/material.dart';
import 'package:trabalho_pratico_dam/campo-texto.dart';
import 'package:trabalho_pratico_dam/pensamento-positivo.dart';

class NavDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Text('', style: TextStyle(color: Colors.white, fontSize: 25)),
            decoration: BoxDecoration(
                color: Colors.green,
                image: DecorationImage(
                    fit: BoxFit.contain,
                    image: AssetImage('../assets/img/tolkien_monogram.png')
                ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.adb),
            title: Text('Campo Texto'),
            onTap: () => {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CampoTexto(),
                ),
              )
            },
          ),
          ListTile(
            leading: Icon(Icons.adb),
            title: Text('Pensamentos Positívos'),
            onTap: () => {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PensamentoPositivo(),
                ),
              )
            },
          ),
          ListTile(
            leading: Icon(Icons.verified_user),
            title: Text('Profile'),
            onTap: () => {Navigator.of(context).pop()},
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Settings'),
            onTap: () => {Navigator.of(context).pop()},
          ),
          ListTile(
            leading: Icon(Icons.border_color),
            title: Text('Feedback'),
            onTap: () => {Navigator.of(context).pop()},
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Logout'),
            onTap: () => {Navigator.of(context).pop()},
          ),
        ],
      ),
    );
  }
}