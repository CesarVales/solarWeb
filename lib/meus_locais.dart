import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:solar_web/AppBarWidget.dart';
import 'package:solar_web/newLocale.dart';
import 'package:solar_web/my_maintenance.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:solar_web/solar_panels_screen.dart';
import 'drawer.dart';
import 'dbControler.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'globals.dart' as globals;

class meus_locais extends StatefulWidget {
  const meus_locais({Key? key}) : super(key: key);

  @override
  State<meus_locais> createState() => _meus_locaisState();
}

class _meus_locaisState extends State<meus_locais> {
  User? user = FirebaseAuth.instance.currentUser;
  // var email = user?.email;
  // final _locaisStream = FirebaseFirestore.instance.collection('local').where('id_usuario', isEqualTo:email).snapshots();
  final _locaisStream = lerLocal();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    //fetchSolarPanels();
    super.initState();
    fetchSolarPanels();
  }
  List<Map<String, dynamic>> solarPanels = [];
  void fetchSolarPanels() async {
    final querySnapshot = await FirebaseFirestore.instance.collection('sistemasReais').get();
    setState(() {
      solarPanels = querySnapshot.docs
          .map((document) => document.data())
          .toList();
    });
    globals.placas.clear();
    for (var element in solarPanels) {
      print(element["Modelo"]);
      globals.placas.add(element["Modelo"]);
    }
    globals.placas.toSet().toList();
  }

  @override
  Widget build(BuildContext context) {
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
    return Scaffold(
      backgroundColor: Colors.amber[50],
      key: _scaffoldKey,
      appBar: AppBarWidget(scaffoldKey: _scaffoldKey),
      drawer: drawer(),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: _locaisStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.hasError) {
            return Text("Erro de Conexão");
          }
          if (!snapshot.hasData) {
            return Text("Não Existem Locais Cadastrados");
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text('Carregando...');
          }
          final docs = snapshot.data!.docs;
          return ListView.separated(
            padding: const EdgeInsets.all(10),
            shrinkWrap: true,
            itemCount: docs.length,

            itemBuilder: (BuildContext context, int index) {
              final doc = docs[index];
              return Card(
                color: Colors.green,
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: 10),
                    Image.network(
                      'https://canalsolar.com.br/wp-content/uploads/2021/12/Energia-solar-residencial.jpg',
                      width: double.infinity,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                    ListTile(
                      contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                      tileColor: Colors.grey[200],
                      title: Text(
                        '${doc['nome']}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Id: ${doc['id']}',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.black54,
                            ),
                          ),
                          Text(
                            'Id Usuário: ${doc['id_usuario']}',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.black54,
                            ),
                          ),
                          Text(
                            'Latitude: ${doc['latitude']} Longitude: ${doc['longitude']}',
                            style: const TextStyle(
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
                            onTap: () {
                              globals.id_local = doc['id'];
                              Navigator.of(context).pushNamed("/solar_panels_screen");
                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute(builder: (context) => solar_panels_screen()),
                              // );
                            },
                            child: const Icon(
                              Icons.solar_power_outlined,
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
          Navigator.of(context).pushNamed("/newLocale");
          // Navigator.pushReplacement(
          //   context,
          //   MaterialPageRoute(builder: (context) => newLocale()),
          // );
        },
        child: const Icon(Icons.add),
        backgroundColor: Colors.green[800],
      ),
    );
  }
}
