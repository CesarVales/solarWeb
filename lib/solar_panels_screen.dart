import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:solar_web/AppBarWidget.dart';

class solar_panels_screen extends StatefulWidget {
  const solar_panels_screen({Key? key}) : super(key: key);

  @override
  State<solar_panels_screen> createState() => _solar_panels_screenState();
}

class _solar_panels_screenState extends State<solar_panels_screen> {
  final _locaisStream =
  FirebaseFirestore.instance.collection('painel').snapshots();
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBarWidget(scaffoldKey: scaffoldKey),
      body: StreamBuilder(
        stream: _locaisStream,
        builder: (BuildContext context, snapshot) {
          if (snapshot.hasError) {
            return Text("Erro De Conexão");
          }
          if (!snapshot.hasData) {
            return Text("Não Existem Locais Cadastrados");
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text('Carregando...');
          }
          var docs = snapshot.data!.docs;
          return ListView.separated(
            padding: const EdgeInsets.all(10),
            shrinkWrap: true,
            //controller: scrollController,
            itemCount: docs.length, // Altere o número de itens para exibir

            itemBuilder: (BuildContext context, int index) {
              return Card(
                  color: Colors.green,
                  elevation: 5,
                  child: ListTile(

                      contentPadding: EdgeInsets.symmetric(vertical: 10),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      trailing: Icon(Icons.arrow_forward),
                      tileColor: Colors.grey[200],
                      leading: Icon(Icons.home_work_rounded),
                      title: Container(
                          child: Text(
                              '${docs[index]['nome']}')), // Altere o título para cada item
                      subtitle: Column(
                        crossAxisAlignment:CrossAxisAlignment.start,
                        children: [
                          Text('Id  ${docs[index]['id']}'),
                          Text('Id Usuario ${docs[index]['id_usuario']}'),
                          Text('Potencial mensal ${docs[index]['potencial_mensal']}'),
                          Text('Latitude: ${docs[index]['latitude']} Longitude: ${docs[index]['longitude']}')
                        ],
                      )
                  ));
            },
            separatorBuilder: (BuildContext context, int index) =>
            const Divider(),
          );
        },
      ),
    );
  }
}
