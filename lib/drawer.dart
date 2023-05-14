
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:solar_web/main.dart';

import 'home.dart';
import 'login.dart';
import 'newLocale.dart';
import 'minha_conta.dart';
import 'newManutencao.dart';

class drawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.green,
      width: Get.width * 0.5,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const SizedBox(
            height: 100,
            child: DrawerHeader(
              decoration: BoxDecoration(color: Colors.green),
              child: Text('SolarWeb',
                  style: TextStyle(color: Colors.white, fontSize: 30)),
            ),
          ),
          Builder(builder: (BuildContext context) {
            return ListTile(
              title: const Text('Home',
                  style: TextStyle(color: Colors.white, fontSize: 18)),
              textColor: Colors.white,
              leading: const Icon(
                Icons.home,
                size: 35,
                color: Colors.white,
              ),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => MyApp()));
              },
            );
          }),
          Builder(builder: (BuildContext context) {
            return ListTile(
              title: const Text('Login',
                  style: TextStyle(color: Colors.white, fontSize: 18)),
              textColor: Colors.white,
              leading: const Icon(
                Icons.login,
                size: 35,
                color: Colors.white,
              ),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => login(context: context,)));
              },
            );
          }),
          ListTile(
            title: const Text('Meus Locais',
                style: TextStyle(color: Colors.white, fontSize: 18)),
            leading: const Icon(
              Icons.location_pin,
              size: 35,
              color: Colors.white,
            ),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => newLocale()));
            },
          ),
          // ListTile(
          //   title: Text('Artigos',
          //       style: TextStyle(color: Colors.white, fontSize: 18)),
          //   leading: Icon(
          //     Icons.menu_book,
          //     size: 35,
          //     color: Colors.white,
          //   ),
          //   onTap: () {
          //     Navigator.push(context,
          //         MaterialPageRoute(builder: (context) => manutencao()));
          //   },
          // ),
          ListTile(
            title: const Text('Manutenções',
                style: TextStyle(color: Colors.white, fontSize: 18)),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => manutencao()));
            },
          ),
          ListTile(
            title: const Text('Minha conta',
                style: TextStyle(color: Colors.white, fontSize: 18)),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => conta()));
            },
          ),

        ],
      ),
    );
  }
}