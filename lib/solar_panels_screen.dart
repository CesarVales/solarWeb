import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:solar_web/AppBarWidget.dart';
import 'package:solar_web/dbControler.dart';
import 'globals.dart' as globals;
import 'my_maintenance.dart';
import 'newPlaca.dart';
import 'drawer.dart';

class solar_panels_screen extends StatefulWidget {
  const solar_panels_screen({Key? key}) : super(key: key);

  @override
  State<solar_panels_screen> createState() => _solar_panels_screenState();
}

class _solar_panels_screenState extends State<solar_panels_screen> {
  final _locaisStream =
  //FirebaseFirestore.instance.collection('placa').snapshots();

   FirebaseFirestore.instance.collection('placa').where('id_local',isEqualTo: globals.id_local).snapshots();

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      key: scaffoldKey,
      appBar: AppBarWidget(scaffoldKey: scaffoldKey),
      drawer: drawer(),
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
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Image.network(
                      'https://s3.static.brasilescola.uol.com.br/img/2019/01/aproveitamento-energia-solar.jpeg',
                      fit: BoxFit.cover,
                      height: 100,
                    ),
                    ListTile(
                      contentPadding: EdgeInsets.fromLTRB(16, 20, 16, 10), // Aumenta o espaço superior
                      tileColor: Colors.amber[50], // Cor de fundo do ListTile (amarelo claro)
                      title: Text(
                        '${docs[index]['modelo']}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Id: ${docs[index]['id']}',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.black54, // Cor do texto (preto claro)
                            ),
                          ),
                          Text(
                            'Id local: ${docs[index]['id_local']}',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.black54,
                            ),
                          ),
                          Text(
                            'Potencial mensal: ${docs[index]['kwh']} KHW',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.black54,
                            ),
                          ),
                          Text(
                            'Data Instalação: ${docs[index]['data']}',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.black54,
                            ),
                          ),
                          Text(
                            'Última Manutenção: ${docs[index]['dataUlt'] ?? "Sem data"}',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.black54,
                            ),
                          ),
                          Text(
                            // 'Próxima Manutenção: ${docs[index]['dataProx'] ?? "Sem data"}',
                            'Próxima Manutenção: ${proxManutencao(docs[index]['dataUlt']) ?? "Sem data"}',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.black54,
                            ),
                          ),

                        ],
                      ),
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children:  [
                          InkWell(
                            onTap: () async {
                              globals.id_placa = docs[index]['id'];
                              globals.ultMan_placa = docs[index]['dataUlt'];
                              Navigator.of(context).pushNamed("/my_maintenance");
                            },
                            child: const Icon(
                              Icons.build_rounded,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );

            },
            separatorBuilder: (BuildContext context, int index) =>
            const Divider(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(

        onPressed: () {
          Navigator.of(context).pushNamed("/novaPlaca");
          // Navigator.pushReplacement(
          //   context,
          //   MaterialPageRoute(builder: (context) => novaPlaca()),
          // );
        },

        child: Icon(Icons.add),
        backgroundColor: Colors.green[800],
      ),

    );
  }
}
