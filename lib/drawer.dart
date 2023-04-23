
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:solar_web/main.dart';

import 'home.dart';
import 'login.dart';

class drawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.green,
      width: Get.width * 0.5,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          SizedBox(
            height: 100,
            child: DrawerHeader(
              child: Text('SolarWeb',
                  style: TextStyle(color: Colors.white, fontSize: 30)),
              decoration: BoxDecoration(color: Colors.green),
            ),
          ),
          Builder(builder: (BuildContext context) {
            return ListTile(
              title: Text('Home',
                  style: TextStyle(color: Colors.white, fontSize: 18)),
              textColor: Colors.white,
              leading: Icon(
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
              title: Text('Login',
                  style: TextStyle(color: Colors.white, fontSize: 18)),
              textColor: Colors.white,
              leading: Icon(
                Icons.login,
                size: 35,
                color: Colors.white,
              ),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => login()));
              },
            );
          }),
          ListTile(
            title: Text('Meus Locais',
                style: TextStyle(color: Colors.white, fontSize: 18)),
            leading: Icon(
              Icons.location_pin,
              size: 35,
              color: Colors.white,
            ),
          ),
          ListTile(
            title: Text('Artigos',
                style: TextStyle(color: Colors.white, fontSize: 18)),
            leading: Icon(
              Icons.menu_book,
              size: 35,
              color: Colors.white,
            ),
          )
        ],
      ),
    );
  }
}