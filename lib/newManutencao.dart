import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:get/get.dart';
import 'package:solar_web/AppBarWidget.dart';
import 'package:solar_web/dbControler.dart';
import 'package:solar_web/drawer.dart';
import 'newAccount.dart';
import 'home.dart';
import 'login.dart';
import 'newLocale.dart';
import 'package:intl/intl.dart';

class manutencao extends StatelessWidget {
  final _realizador = TextEditingController();
  final _email = TextEditingController();
  //final _meses = TextEditingController();
  final _data = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final  _telefone = TextEditingController();
  final  _descricao = TextEditingController();

  @override
  Widget build(BuildContext context) {
    //_meses.text = '6';
    return Scaffold(
      key: _scaffoldKey,

      appBar: AppBarWidget(scaffoldKey: _scaffoldKey,

      ),
      drawer: drawer(),

      body: Container(
        child: Column(
          children: <Widget>[
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              width: 300.0,
              child: TextField(
                controller: _descricao,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(60),

                  ),
                  labelText: 'Descrição da manutenção',
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
                  labelText: 'Data da manutenção',
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
                    String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);

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
            const SizedBox(
              width: 300,
              child: Text(
                "Dados do realizador",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
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
                controller: _realizador,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(60),

                  ),
                  labelText: 'Nome',
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
                controller:_telefone ,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(60),

                  ),
                  labelText: 'Telefone',
                ),
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
                criarManutencao(_telefone.text, _data.text, _descricao.text, _realizador.text);
              },
              child: Text('Salvar Manutenção'),
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
        ),
      ),
    );
  }

  _onClickNew(BuildContext context) {
  }
}
