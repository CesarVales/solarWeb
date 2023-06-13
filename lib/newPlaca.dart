import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:get/get.dart';
import 'package:solar_web/AppBarWidget.dart';
import 'package:solar_web/dbControler.dart';
import 'package:solar_web/drawer.dart';
import 'package:solar_web/solar_panels_screen.dart';
import 'newAccount.dart';
import 'home.dart';
import 'login.dart';
import 'newLocale.dart';
import 'componentesSeparados/dropDownPlacas.dart';
import 'package:intl/intl.dart';
import 'globals.dart' as globals;

class newPlaca extends StatefulWidget {
  const newPlaca({Key? key}) : super(key: key);

  @override
  State<newPlaca> createState() => _new_placaState();
}

class _new_placaState extends State<newPlaca> {
  final _modelo = TextEditingController();
  final _kwh = TextEditingController();
  final _kwp = TextEditingController();
  final _quantidade = TextEditingController();
  final _data = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBarWidget(scaffoldKey: _scaffoldKey,
      ),
      drawer: drawer(),
      body: Container(
        child: SingleChildScrollView(child: Column(
          children: <Widget>[
            const SizedBox(
              height: 20,
            ),

            const SizedBox(
              width: 300,
              child: Text(
                "Dados da Placa",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 25,
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),

            SizedBox(
                width: 300.0,
                child: dropDownPlacas()
            ),
            /*
            SizedBox(
              width: 300.0,
              child: TextField(
                controller: _modelo,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(60),

                  ),
                  labelText: 'Modelo da Placa',
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
                controller:_kwh ,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(60),

                  ),
                  labelText: 'KwH',
                ),
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ],

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
                controller:_kwp ,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(60),
                  ),
                  labelText: 'Kwp',
                ),
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ],

              ),
            ),*/
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
                  labelText: 'Data da Instalação',
                ),
                readOnly: true,
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000), //DateTime.now() - not to allow to choose before today.
                    lastDate: DateTime(2101),
                  );
                  if(pickedDate != null ){
                    String formattedDate = DateFormat('dd/MM/yyyy').format(pickedDate);

                    _data.text = formattedDate;
                  }else{
                    print("Date is not selected");
                  }
                },
                controller: _data,
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
                controller:_quantidade ,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(60),

                  ),
                  labelText: 'Quantidade',
                ),
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ],

              ),
            ),
            const SizedBox(
              child: SizedBox(
                  width: 10.0,
                  height: 10.0
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
                if(_data.text != "" && _quantidade.text != "" && globals.potenciaKit != ''){
                  print(globals.potenciaKit ?? '-1');
                  criarPlaca(globals.id_local ?? -1, _data.text, _quantidade.text,  globals.modeloPlaca ?? '', globals.potenciaKit ?? '-1', globals.potenciaMax ?? '-1');
                  showDialog(context: context,
                    builder: (context) {
                      return AlertDialog(
                          title: Text("Sucesso"),
                          content: Text("Placa cadastrada com sucesso!"),
                          actions: <Widget>[
                            TextButton(
                                child: Text("OK"),
                                onPressed: () {
                                  Navigator.of(context).pushNamed("/solar_panels_screen");
                                }
                            )
                          ]
                      );
                    },
                  );
                }else{
                  showDialog(context: context,
                    builder: (context) {
                      return AlertDialog(
                          title: Text("Erro"),
                          content: Text("Preencha o todos os campos antes de finalizar o cadastro!"),
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

              },
              child: Text('Salvar Placa'),
            ),
            const SizedBox(
              child: SizedBox(
                  width: 10.0,
                  height: 15.0
              ),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
            )
          ],
        ),),
      ),
    );
  }

}
