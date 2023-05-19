import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:get/get.dart';
import 'package:solar_web/AppBarWidget.dart';
import 'package:solar_web/drawer.dart';
import 'newAccount.dart';
import 'home.dart';
import 'login.dart';
import 'newLocale.dart';


class conta extends StatelessWidget {
  final _nome = TextEditingController();
  final _email = TextEditingController();
  final _meses = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  var auth =  FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    User? user = auth.currentUser;

    _nome.text = 'admin';
    _email.text =  user?.email as String;
    _meses.text = '6';
    return Scaffold(
      key: _scaffoldKey,

      appBar: AppBarWidget(scaffoldKey: _scaffoldKey,

      ),
      drawer: drawer(),

      // appBar: AppBar(
      //   title: Text('Minha Conta'), backgroundColor: Colors.green,
      //   leading: Icon(Icons.sunny, color: Colors.yellow, size: 40,),
      //   actions: [
      //     IconButton(
      //       icon: Icon(Icons.menu),
      //       onPressed: () {
      //         Scaffold.of(context).openDrawer(); // exibe o novo Drawer
      //       },
      //     ),
      //   ],
      // ),
      body: Container(
        child: Column(
          children: <Widget>[
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              width: 300.0,
              child: TextField(
                readOnly: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(60),

                  ),
                  labelText: 'Nome',
                ),
                controller: _nome,

              ),
            ),
            const SizedBox(
              child: SizedBox(
                  width: 10.0,
                  height: 10.0
              ),
            ),
            SizedBox(
              width: 300.0,
              child: TextField(
                readOnly: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(60),

                  ),
                  labelText: 'Email',
                ),
                controller: _email,

              ),
            ),
            const SizedBox(
              child: SizedBox(
                  width: 10.0,
                  height: 10.0
              ),
            ),
            const SizedBox(
              width: 300,
              child: Text(
                "Alterar Senha",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            ),
            const SizedBox(
              child: SizedBox(
                  width: 10.0,
                  height: 5.0
              ),
            ),
            SizedBox(
              width: 300.0,
              child: TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(60),

                  ),
                  labelText: 'Senha Antiga',
                ),
              ),
            ),
            const SizedBox(
              child: SizedBox(
                  width: 10.0,
                  height: 10.0
              ),
            ),
            SizedBox(
              width: 300.0,
              child: TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(60),

                  ),
                  labelText: 'Nova Senha',
                ),
              ),
            ),
            const SizedBox(
              child: SizedBox(
                  width: 10.0,
                  height: 5.0
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  textStyle: const TextStyle(fontSize: 20)),
              onPressed: () {
              },
              child: Text('Salvar Senha'),
            ),
            const SizedBox(
              child: SizedBox(
                  width: 10.0,
                  height: 15.0
              ),
            ),
            const SizedBox(
              width: 300,
              child: Text(
                "Notificações",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            ),
            const SizedBox(
              child: SizedBox(
                  width: 10.0,
                  height: 5.0
              ),
            ),
            const SizedBox(
              width: 300,
              child: Text(
                "Quando você gostaría de receber notificações para a manutenção do seu equipamento?",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 11,
                ),
              ),
            ),
            const SizedBox(
              child: SizedBox(
                  width: 10.0,
                  height: 10.0
              ),
            ),
            SizedBox(
              width: 300.0,
              child: TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(60),

                  ),
                  labelText: 'A cada quantos meses',
                ),
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ],
                controller: _meses,
              ),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
            )
          ],
        ),
      ),
    );
  }

  _onClickNew(BuildContext context) {
    }
  }
