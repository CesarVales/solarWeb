import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:solar_web/AppBarWidget.dart';
import 'globals.dart' as globals;
import 'drawer.dart';
import 'package:solar_web/newManutencao.dart';
import 'package:solar_web/solar_panels_screen.dart';

class my_maintenance extends StatefulWidget {
  const my_maintenance({Key? key}) : super(key: key);

  @override
  State<my_maintenance> createState() => _my_maintenanceState();
}

class _my_maintenanceState extends State<my_maintenance> {
  final _manutencoesStream =
  FirebaseFirestore.instance.collection('manutencao').where('id_placa', isEqualTo: globals.id_placa).snapshots();
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBarWidget(scaffoldKey: scaffoldKey),
      drawer: drawer(),
      body: StreamBuilder(
        stream: _manutencoesStream,
        builder: (BuildContext context, snapshot) {
          if (snapshot.hasError) {
            return const Text("Erro De Conexão");
          }
          if (!snapshot.hasData) {

            return const Text("Não Existem Manutenções Cadastradas");
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text('Carregando...');
          }
          var docs = snapshot.data!.docs;
          if(docs.length == 0){
            return const Align(child: Text("Não Existem Manutenções Cadastradas",style: TextStyle(
              fontSize: 30,
              color: Colors.black54,
            ),));
          }
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
                    SizedBox(
                      height: 10,
                    ),
                    Image.network(
                      'https://institutosolar.com/wp-content/uploads/2019/05/Manuten%C3%A7%C3%A3o-do-painel-solar.jpg',
                      width: double.infinity,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                    ListTile(
                      contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                      tileColor: Colors.grey[200], // Cor de fundo do ListTile (amarelo claro)  
                      title: Text(
                        '${docs[index]['descricao']}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Realizador: ${docs[index]['realizador']}',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.black54, // Cor do texto (preto claro)
                            ),
                          ),
                          Text(
                            'Data: ${docs[index]['data']}',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.black54,
                            ),
                          ),
                          Text(
                            'Próxima Manutenção: ${docs[index]['dataProx'] ?? "Sem data"}',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.black54,
                            ),
                          ),
                          Text(
                            'Contato: ${docs[index]['contato']}',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.black54,
                            ),
                          ),
                          
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
            separatorBuilder: (BuildContext context, int index) => const Divider(),

          );

        },
      ),
      floatingActionButton: FloatingActionButton(

        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => manutencao()),
          );
        },

        child: Icon(Icons.add),
        backgroundColor: Colors.green[800],
      ),


    )    ;
  }
}
