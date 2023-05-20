import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:solar_web/AppBarWidget.dart';
import 'package:solar_web/newLocale.dart';
import 'package:solar_web/solar_panels_screen.dart';

class meus_locais extends StatefulWidget {
  const meus_locais({Key? key}) : super(key: key);

  @override
  State<meus_locais> createState() => _meus_locaisState();
}

class _meus_locaisState extends State<meus_locais> {
  final _locaisStream =
  FirebaseFirestore.instance.collection('local').snapshots();
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
                      'https://d2r9epyceweg5n.cloudfront.net/stores/002/321/284/products/kit-3-611-2afc20e8d66dc2ab2116795036769050-640-0.webp',
                      width: double.infinity,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                    ListTile(
                      contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                      tileColor: Colors.grey[200], // Cor de fundo do ListTile (amarelo claro)
                      // leading: Container(
                      //   width: 70,
                      //   height: 70,
                      //   child: Image.network(
                      //     'https://d2r9epyceweg5n.cloudfront.net/stores/002/321/284/products/kit-3-611-2afc20e8d66dc2ab2116795036769050-640-0.webp',
                      //     width: 80, // definir a largura da imagem
                      //     height: 70, // definir a altura da imagem
                      //     fit: BoxFit.cover, // ajustar a imagem ao tamanho do container
                      //   ),
                      // ),
                      title: Text(
                        '${docs[index]['nome']}',
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
                            'Id Usuario: ${docs[index]['id_usuario']}',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.black54,
                            ),
                          ),
                          Text(
                            'Potencial mensal: ${docs[index]['potencial_mensal']}',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.black54,
                            ),
                          ),
                          Text(
                            'Latitude: ${docs[index]['latitude']} Longitude: ${docs[index]['longitude']}',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                      trailing: Icon(Icons.arrow_forward),
                      onTap: () async {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => solar_panels_screen()),
                        );
                      },
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
            MaterialPageRoute(builder: (context) => newLocale()),
          );
        },

        child: Icon(Icons.add),
        backgroundColor: Colors.green[800],
      ),


    )    ;
  }
}

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'dbControler.dart';
//
// class meus_locais extends StatefulWidget {
//   const meus_locais({Key? key}) : super(key: key);
//   @override
//   State<meus_locais> createState() => meus_locais_State();
// }
//
// Widget builderFuture(
//     BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
//   if (snapshot.connectionState == ConnectionState.waiting) {
//     // Exibir um indicador de carregamento enquanto os dados estão sendo buscados
//     return CircularProgressIndicator();
//   } else if (snapshot.hasError) {
//     // Lidar com erros durante a busca dos dados
//     return Text('Erro ao obter os dados');
//   } else {
//     // Os dados foram obtidos com sucesso, agora você pode construir o widget com base nos dados
//     List<dynamic> dados = snapshot.data!;
//     // Faça algo com os dados e retorne o widget correspondente
//     return Scaffold(
//         // Resto do código...
//         );
//   }
// }
// Widget <ListView> {
//
// }
// Future<List> lerManutencao2() async {
//   final docUsuario = FirebaseFirestore.instance
//       .collection('manutencao')
//       .where('id_local', isEqualTo: 1);
//   final docSnapshot = await docUsuario.get();
//   var listaLocais = [];
//   for (var i in docSnapshot.docs) {
//     print('${i.data()} => ${i.get('id_local')}');
//     listaLocais.add(i);
//   }
//   return listaLocais;
// }
//
// class meus_locais_State extends State<meus_locais> {
//   @override
//   Widget build(BuildContext context) {
//     return ListView.separated(
//       padding: const EdgeInsets.all(10),
//       //controller: scrollController,
//       itemCount: 1, // Altere o número de itens para exibir
//
//       itemBuilder: (BuildContext context, int index) {
//         return Card(
//             color: Colors.green,
//             elevation: 5,
//             child: ListTile(
//               contentPadding: EdgeInsets.symmetric(vertical: 10),
//               shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(10)),
//               trailing: Icon(Icons.arrow_forward),
//               tileColor: Colors.grey[200],
//               leading: Container(
//                   width: 70,
//                   height: 70,
//                   child: Image.network(
//                     'https://d2r9epyceweg5n.cloudfront.net/stores/002/321/284/products/kit-3-611-2afc20e8d66dc2ab2116795036769050-640-0.webp',
//                     width: 80, // definir a largura da imagem
//                     height: 70, // definir a altura da imagem
//                     fit: BoxFit
//                         .cover, // ajustar a imagem ao tamanho do container
//                   )),
//               title: Container(
//                   child: Text(
//                       '${listaLocais[index]}')), // Altere o título para cada item
//               subtitle: Text("usaiudhausidhauishduiashdiuahsiudh"),
//             ));
//       },
//       separatorBuilder: (BuildContext context, int index) => const Divider(),
//     );
//   }
// }
