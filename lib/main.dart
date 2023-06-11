import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:solar_web/DataScreen.dart';
import 'package:solar_web/drawer.dart';
import 'package:solar_web/login.dart';
import 'package:solar_web/my_bottom_sheet.dart';
import 'package:solar_web/map_controller.dart';
import 'package:get/get.dart';
import 'package:solar_web/SearchScreen.dart';
import 'package:solar_web/newAccount.dart';
import 'package:solar_web/services/relatorio.dart';
import 'package:solar_web/Report.dart';
import 'package:solar_web/services/auth_service.dart';
import 'package:solar_web/solar_panels_screen.dart';
import 'dbControler.dart';
import 'AppBarWidget.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:solar_web/globals.dart' as globals;
import 'package:http/http.dart' as http;

import 'meus_locais.dart';
import 'my_maintenance.dart';
import 'minha_conta.dart';
import 'newLocale.dart';
import 'newPlaca.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterConfig.loadEnvVariables();
  await Firebase.initializeApp();

  runApp(MultiProvider(providers: [
    ChangeNotifierProvider<map_controller>(
      create: (_) => map_controller(),
    ),
    ChangeNotifierProvider(create: (context) => AuthService()),
  ], child: MyApp()));
}

class MyApp extends StatefulWidget {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  State<MyApp> createState() => _MyAppState();

}

class _MyAppState extends State<MyApp> {
  var db = FirebaseFirestore.instance;
  var auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    final scaffoldKey = GlobalKey<ScaffoldState>();

    if (globals.posicaoEnd != null) {
      // Faça algo com posicaoEnd
    }
    final navigatorKey = GlobalKey<NavigatorState>();

    User? user = auth.currentUser;
    print("Usuário: ${user?.email}");
    return MaterialApp(
        navigatorKey: navigatorKey,

        title: 'My App',
        theme: ThemeData(
          primarySwatch: Colors.green,
        ),
        initialRoute: "/",
        routes: {
          "/meus_locais": (context) => meus_locais(),
          "/minha_conta": (context) => my_account(),
          "/my_maintenance": (context) => my_maintenance(),
          "/login": (context) => login(context: context),
          "/solar_panels_screen": (context) => solar_panels_screen(),
          "/newLocale": (context) => newLocale(),
          "/novaPlaca": (context) => novaPlaca(),
          "/newAccount": (context) => newAccount(context: context),
        },

        home: Scaffold(
            key: scaffoldKey,
            appBar: AppBarWidget(
              scaffoldKey: scaffoldKey,
            ),
            drawer: drawer(),
            body: Stack(
              fit: StackFit.loose,
              children: [
                mapWidget(),
                const MyBottomSheet(),

              ],
            ),
            floatingActionButton: FloatingActionButton.extended(
              onPressed: ()  {
                navigatorKey.currentState?.pushReplacement(
                    MaterialPageRoute(builder: (context) => Report()));



              },
              label: Icon(Icons.article_outlined),
              splashColor: Colors.yellow,
              hoverColor: Colors.yellow,
            )
        ));
  }
}

class mapWidget extends StatefulWidget {
  @override
  State<mapWidget> createState() => _mapWidgetState();
}

class _mapWidgetState extends State<mapWidget> {
  @override
  Widget build(BuildContext context) {
    var searchBarControler = TextEditingController();

    return Scaffold(
      body: Stack(children: [
        ChangeNotifierProvider<map_controller>(
          create: (context) => map_controller(),
          child: Builder(
            builder: (context) {
              final local = context.watch<map_controller>();
              if (globals.posicaoEnd != null) {
                searchBarControler.text = globals.posicaoEnd!.formattedAddress!;
              }
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
                  offset: Offset(0,
                      2), // Define a direção da sombra (horizontal, vertical)
                ),
              ],
            ),
            child: TextField(
              controller: searchBarControler,
              onTap: () async {
                if (searchBarControler.text.isEmpty) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SearchScreen()));
                }
              },
              // with some styling
              decoration: InputDecoration(
                suffixIcon: GestureDetector(
                    onTap: () {
                      searchBarControler.clear();
                    },
                    child: Icon(Icons.clear)),
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

