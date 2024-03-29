import 'package:flutter/material.dart';
import 'package:trabalho_pratico_dam/pages/about-page.dart';
import 'package:trabalho_pratico_dam/pages_LDDM05/text_field.dart';
import '../pages/home_page.dart';
import '../pages/login.dart';
import '../pages_LDDM04/hello_world.dart';
import '../pages_LDDM04/imagens.dart';
import '../pages_LDDM05/widgets_stateful.dart';
import '../pages_LDDM05/widgets_stateless.dart';
import '../pages_LDDM12/midias.dart';

class MenuLateralDuDudu extends StatelessWidget {
  const MenuLateralDuDudu({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.green,
              image: DecorationImage(
                  fit: BoxFit.contain,
                  image: AssetImage('../assets/img/tolkien_monogram.png')),
            ),
            child:
                Text('', style: TextStyle(color: Colors.white, fontSize: 25)),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home Page'),
            onTap: () => {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const HomePageDuDudu(),
                ),
              )
            },
          ),
          ListTile(
            leading: const Icon(Icons.account_balance),
            title: const Text('About'),
            onTap: () => {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AboutPageDuDudu(),
                ),
              )
            },
          ),
          ListTile(
            leading: const Icon(Icons.battery_0_bar),
            title: const Text('Hello World'),
            onTap: () => {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const HelloWorldDuDudu(),
                ),
              )
            },
          ),
          ListTile(
            leading: const Icon(Icons.battery_1_bar),
            title: const Text('Imagens'),
            onTap: () => {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ImagensDuDudu(),
                ),
              )
            },
          ),
          ListTile(
            leading: const Icon(Icons.network_wifi_1_bar),
            title: const Text('Widgets Stateless'),
            onTap: () => {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const WidgetsStatelessDuDudu(),
                ),
              )
            },
          ),
          ListTile(
            leading: const Icon(Icons.network_wifi_2_bar),
            title: const Text('Widgets Stateful'),
            onTap: () => {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const WidgetsStatefulDuDudu(),
                ),
              )
            },
          ),
          ListTile(
            leading: const Icon(Icons.network_wifi_3_bar),
            title: const Text('Text Field'),
            onTap: () => {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const TextFieldDuDudu(),
                ),
              )
            },
          ),
          ListTile(
            leading: const Icon(Icons.surround_sound),
            title: const Text('Mídias - Sons'),
            onTap: () => {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const MidiaSonsDuDudu(),
                ),
              )
            },
          ),
          ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: const Text('Logout'),
            onTap: () => {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const LoginPage(),
                ),
              )
            },
          ),
        ],
      ),
    );
  }
}
