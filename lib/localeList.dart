import 'package:flutter/material.dart';
import 'package:solar_web/AppBarWidget.dart';
import 'dbControler.dart';
class localeList extends StatelessWidget{
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
    Widget build(BuildContext context) {

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBarWidget(scaffoldKey: _scaffoldKey,),
      body:Column(
        children: [
          listTileLocale(),
        ],
      ) 
    );
  }

}
//Melhor criar uma classe para cada Documento

class listTileLocale extends StatelessWidget {
  //var login = lerUsuario('login');

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.account_box),
    );
  }

}