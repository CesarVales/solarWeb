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

class my_account extends StatefulWidget {
  const my_account({Key? key}) : super(key: key);

  @override
  State<my_account> createState() => _my_accountState();
}


class _my_accountState extends State<my_account> {
  final _nome = TextEditingController();
  final _email = TextEditingController();
  final _senha = TextEditingController();
  final _meses = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  var auth =  FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    User? user = auth.currentUser;
    print("USER: $user");
    String _nome2 = '';

    const List<String> list = <String>['3', '6', '9'];
    String _meses = list.first;
    if (user == null) {
      return Scaffold(
        key: _scaffoldKey,
        appBar:AppBarWidget(scaffoldKey: _scaffoldKey),
        drawer: drawer(),
        body: Container(
            child: Center(child: Text("Faça Login... \nFAÇA LOGIN IMEDIATAMENTE",style: TextStyle(fontSize: 20),))
        ),
      );
    }
    _email.text =  user?.email as String;
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBarWidget(scaffoldKey: _scaffoldKey),
      drawer: drawer(),
      body: Container(
        child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
            const SizedBox(
            height: 20,
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
                controller: _senha,

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
                _nome2 = _senha.text;
                if (user != null) {
                  user.updatePassword(_nome2).then((_) {
                    print("Successfully changed password");
                  }).catchError((error) {
                    print("Password can't be changed" + error.toString());
                  });
                }
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
                "Quando você gostaria de receber notificações para a manutenção do seu equipamento?",
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
                child: DropdownButton<String>(
                  value: _meses,
                  icon: const Icon(Icons.notifications),
                  underline: Container(
                    height: 2,
                    color: Colors.green,
                  ),
                  onChanged: (String? value) {
                    setState(() {
                      _meses = value!;
                      print(_meses);
                    });
                  },
                  items: list.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                )
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
            )
          ],
        ),
      ),
    )
    );
  }

  _onClickNew(BuildContext context) {
    }
  }
