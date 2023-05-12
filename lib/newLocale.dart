import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:solar_web/dbControler.dart';

import 'AppBarWidget.dart';

class newLocale extends StatefulWidget {
  const newLocale({Key? key}) : super(key: key);

  @override
  _newLocale createState() => _newLocale();
}
class _newLocale extends State<newLocale>{
  final _tApelido = TextEditingController();
  final _tEndereco = TextEditingController();
  bool myLocale = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>(); // cesinha

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      key: _scaffoldKey,//cesinha
      // appBar: AppBar(
      //   title: Text('Cadastro de Local'), backgroundColor: Colors.green,
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
      appBar: AppBarWidget(scaffoldKey: _scaffoldKey,),
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
                controller: _tApelido,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(60),

                    ),
                    labelText: 'Defina um apelido a esse local:',
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
              child: Visibility(
                visible: !myLocale,
                child: TextFormField(obscureText: false,
                  controller: _tEndereco,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(60)
                    ),
                    labelText: 'Digite o endereço:',
                  ),),
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
              child: CheckboxListTile(
                  title: Text("Deseja usar sua localização atual?"),
                  controlAffinity: ListTileControlAffinity.leading,
                  value: this.myLocale,
                  activeColor: Colors.green,
                  onChanged:(bool? check){
                    myLocale = !myLocale;
                    setState(() {
                      this.myLocale = check!;
                    });

                    Text('Remember me');
                  }),
            ),
            SizedBox(
              child: SizedBox(
                  width: 10.0,
                  height: 10.0
              ),
            ),
            SizedBox(height: 15),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  textStyle: const TextStyle(fontSize: 20)),
              onPressed: () {
                //Cesinha 12/05
                  final apelido = _tApelido.text;
                  final endereco = _tEndereco.text;
                  criarLocal( latitude: 0.0, longitude: 0.0, nome: apelido);
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
}