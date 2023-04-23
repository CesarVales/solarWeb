import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class newAccount extends StatelessWidget {
  final _tLogin = TextEditingController();
  final _tSenha = TextEditingController();
  final _tNome = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cadastro de Usuário'), backgroundColor: Colors.green,
        leading: Icon(Icons.sunny, color: Colors.yellow, size: 40,),
        actions: [
          IconButton(
            icon: Icon(Icons.menu),
            onPressed: () {
              Scaffold.of(context).openDrawer(); // exibe o novo Drawer
            },
          ),
        ],
      ),
      body: Container(
        key: _formKey,
        child: Column(
          children: <Widget>[
            SizedBox(
                height: 230.0
            ),
            SizedBox(
              width: 300.0,
              child: TextField(
                obscureText: false,
                controller: _tNome,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(60),

                    ),
                    labelText: 'Nome:',
                    hintText: "Informe seu nome"
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
                controller: _tLogin,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(60)
                    ),
                    labelText: 'Email:',
                    hintText: "Informe seu email"
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
                _onClickNew(context);
              },
              child: Text('Cadastrar'),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
            ),
          ],
        ),
      ),
    );
  }

  _onClickNew(BuildContext context) {
    final nome = _tNome.text;
    final login = _tLogin.text;
    final senha = _tSenha.text;
    if (login.isEmpty || senha.isEmpty || nome.isEmpty) {
      showDialog(context: context,
        builder: (context) {
          return AlertDialog(
              title: Text("Erro"),
              content: Text("Login, Senha e/ou nome inválido(s)"),
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
