
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:solar_web/drawer.dart';
import 'package:solar_web/my_bottom_sheet.dart';
import 'package:solar_web/map_controller.dart';
import 'package:get/get.dart';
import 'package:solar_web/searchScreen.dart';
import 'package:solar_web/services/auth_service.dart';
import 'dbControler.dart';
import 'AppBarWidget.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:solar_web/globals.dart' as globals;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterConfig.loadEnvVariables();
  await Firebase.initializeApp();

  runApp(
    MultiProvider(providers: [
      ChangeNotifierProvider<map_controller>(
        create: (_) => map_controller(),

      ),
      ChangeNotifierProvider(create: (context) => AuthService()),
    ],child: MyApp()

    )
  );
}

class MyApp extends StatefulWidget {

  @override
  State<MyApp> createState() => _MyAppState();

}

class _MyAppState extends State<MyApp> {
  var locale = map_controller().getPosicao();
  var locale2 = map_controller();
  var db = FirebaseFirestore.instance;
  var auth =  FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    final scaffoldKey = GlobalKey<ScaffoldState>();
    if (globals.posicaoEnd != null) {
      // Faça algo com posicaoEnd
    }
    User? user = auth.currentUser;
    print("Usuário: ${user?.email}");
    return MaterialApp(
        title: 'My App',
        theme: ThemeData(
          primarySwatch: Colors.green,
        ),
        home: Scaffold(
            key: scaffoldKey,
            appBar: AppBarWidget(scaffoldKey: scaffoldKey,
            ),
            drawer: drawer(),
            body: Stack(
              fit: StackFit.loose,
              children: [
                mapWidget(),
                const MyBottomSheet(),
              ],
            ),
            floatingActionButton: Align(
                heightFactor: 2.0,
                widthFactor: 0.7,
                child: FloatingActionButton.extended(
                  onPressed: () async {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => const searchScreen())
                    );
                    // final usuario =  await lerUsuario('Cesinha');
                    // if(usuario != null){
                    //   usuario.forEach((key, value) {
                    //     print("$key - $value");
                    //   });
                    // }else{
                    //   print('VALOR NULO');
                    // }
                  },
                  label: Icon(Icons.article_outlined),
                  splashColor: Colors.yellow,
                  hoverColor: Colors.yellow,
                ))));
  }
}

class mapWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var searchBarControler = TextEditingController();
    if (globals.posicaoEnd != null) {
      searchBarControler.text = globals.posicaoEnd!.formattedAddress!;
    }
    return Scaffold(
      body: Stack(children: [
        ChangeNotifierProvider<map_controller>(
          create: (context) => map_controller(),
          child: Builder(
            builder: (context) {
              final local = context.watch<map_controller>();

              return GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: LatLng(local.lat, local.long),
                  zoom: 18,
                ),
                zoomControlsEnabled: false,
                myLocationButtonEnabled: true,
                onMapCreated: local.onMapCreated,
                markers: local.markers,
              );
            },
          ),
        ),
        Container(

            padding: EdgeInsets.symmetric(horizontal: 10),
            margin: EdgeInsets.symmetric(vertical: 30, horizontal: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 2,
                  blurRadius: 4,
                  offset: Offset(0, 2), // Define a direção da sombra (horizontal, vertical)
                ),
              ],
            ),
            child: TextField(

              controller: searchBarControler,
              onTap: () async {
                if(searchBarControler.text.isEmpty){
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const searchScreen())
                  );
                }

              },
              // with some styling
              decoration: InputDecoration(
                suffixIcon: GestureDetector(onTap: () {
                  searchBarControler.clear();
                },child:Icon(Icons.clear)),
                filled: true,
                fillColor: Colors.white,
                hintText: "Busque um endereço",
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(left: 8.0, top: 6.0),
              ),
            )),
      ]),
    );
  }
}

class AddressSearch {}
