import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:solar_web/AppBarWidget.dart';
import 'package:solar_web/drawer.dart';
import 'package:solar_web/home.dart';
import 'package:solar_web/main.dart';
import 'package:solar_web/services/auth_service.dart';
import 'package:solar_web/services/userProvider.dart';
import 'newAccount.dart';
import 'globals.dart' as globals;

import 'package:provider/provider.dart';
// Em algum lugar do código, provavelmente no início do app:
final userProvider = UserProvider();


class login extends StatelessWidget {

  final _tLogin = TextEditingController();
  final _tSenha = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final BuildContext context;

  login({required this.context});

  //cesinha

  loginUser(BuildContext context) async {
    try{
      await Provider.of<AuthService>(context, listen: false).login(_tLogin.text,_tSenha.text);
      // Quando o usuário fizer login atualiza o provider
      User? user = FirebaseAuth.instance.currentUser;
      userProvider.setUser(user);
      //Vai para tela principal (Mapa)
      globals.logged = "Sign Out";
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MyApp()),
      );

    }on AuthException catch(e){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message)));
    }
  }

  // fim cesinha
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,

      appBar: AppBarWidget(scaffoldKey: _scaffoldKey,)
      ,drawer: drawer(),
      body: Container(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
          children: [
            SizedBox(
                height: 230.0
            ),
            SizedBox(
              width: 300.0,
              child: TextField(
                obscureText: false,
                controller: _tLogin,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(60),

                    ),
                    labelText: 'Email:',
                    hintText: "Informe o email"
                ),

              ),
            ),
            SizedBox(
              child: SizedBox(
                  width: 10.0,
                  height: 10.0
              ),
            ),
            SizedBox(
              width: 300.0,
              child: TextField(
                obscureText: true,
                controller: _tSenha,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(60)
                    ),
                    labelText: 'Senha:',
                    hintText: "Informe uma senha"
                ),
              ),
            ),
            SizedBox(height: 15),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  textStyle: const TextStyle(fontSize: 20)),
              onPressed: () {
                loginUser(context);
              },
              child: Text('Entrar'),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text('Não tem uma conta?'),
                TextButton(
                  onPressed: () {
                    Navigator.push(context,
                      MaterialPageRoute(builder: (context) => newAccount(context: context,)));},
                  child: Text('Criar conta'),
                ),
              ],
            ),
          ],
        ),
        ),
      ),
    );
  }

  _onClickLogin(BuildContext context) {
    final login = _tLogin.text;
    final senha = _tSenha.text;
    if (login.isEmpty || senha.isEmpty) {
      showDialog(context: context,
        builder: (context) {
          return AlertDialog(
              title: Text("Erro"),
              content: Text("Login e/ou Senha inválido(s)"),
              actions: <Widget>[
                TextButton(
                    child: Text("OK"),
                    onPressed: () {
                      Navigator.pop(context);
                    }
                )
              ]
          );
        },
      );
    }
  }
}
