
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:solar_web/main.dart';
import 'package:solar_web/meus_locais.dart';

import 'home.dart';
import 'login.dart';
import 'newLocale.dart';
import 'minha_conta.dart';
import 'newManutencao.dart';
import 'newPlaca.dart';
void _signOut() {
  FirebaseAuth.instance.signOut();
  //FirebaseUser user = FirebaseAuth.instance.currentUser;
  //print('$user');
  runApp(
      new MaterialApp(
        //home: new LoginPage(),
      )

  );
}
class drawer extends StatelessWidget {
  var auth =  FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    User? user = auth.currentUser;
    var usuario =  user?.email.toString();
    var isLoged =  user == null ? false : true;
    print("logado ??????$isLoged");
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
            return Visibility(
              visible: !isLoged,
              child: ListTile(
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
              ),
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
                  MaterialPageRoute(builder: (context) => meus_locais()));
            },
          ),

          // ListTile(
          //   title: const Text('Manutenções',
          //       style: TextStyle(color: Colors.white, fontSize: 18)),
          //   onTap: () {
          //     Navigator.push(context,
          //         MaterialPageRoute(builder: (context) => manutencao()));
          //   },
          // ),
          ListTile(
            title: const Text('Minha conta',
                style: TextStyle(color: Colors.white, fontSize: 18)),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => my_account()));
            },
          ),
       ListTile(
          title: Text("Log Out",style:TextStyle(color: Colors.white, fontSize: 18),),
         leading: const Icon(
           Icons.logout,
           size: 35,
           color: Colors.white,
         ),
          onTap:  ()  async {
            _signOut();
          },
        ),
          Text(
            getUser().toString()
          ),
        ],
      ),
    );
  }
  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
  }
  String? getUser()  {
    var auth =  FirebaseAuth.instance;

    User? user = auth.currentUser;
    var usuario =  user?.email.toString();
    if(usuario == null){
      return 'Não Logado';
    }
    print("Usuário: ${user?.email}");
    return usuario;
  }
}