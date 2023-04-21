import 'package:flutter/material.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:solar_web/my_bottom_sheet.dart';
import 'package:solar_web/map_controller.dart';
import 'package:get/get.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import 'home.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterConfig.loadEnvVariables();
  runApp(
    ChangeNotifierProvider<map_controller>(
      create: (_) => map_controller(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var locale = map_controller().getPosicao();
  var locale2 = map_controller();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'My App',
        theme: ThemeData(
          primarySwatch: Colors.green,
        ),
        home: Scaffold(
          drawer: Drawer(
            backgroundColor: Colors.green,width: Get.width*0.5,
            child: ListView(
              padding: EdgeInsets.zero,
              children:  [
                SizedBox(
                    height: 100,
                    child: DrawerHeader(

                      child: Text('SolarWeb',style: TextStyle(color: Colors.white,fontSize: 30)),
                      decoration: BoxDecoration(color: Colors.green),
                    )),
                Builder(builder: (BuildContext context) {
                  return ListTile(
                    title: Text('Home',
                        style: TextStyle(color: Colors.white, fontSize: 18)),
                    textColor: Colors.white,
                    leading: Icon(
                      Icons.home,
                      size: 35,
                      color: Colors.white,
                    ),
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => home()));
                    },
                  );
                }),

                ListTile(
                  title: Text('Login',style: TextStyle(color: Colors.white,fontSize: 18)),
                  leading: Icon(Icons.login, size: 35,color: Colors.white,),


                ),
                ListTile(
                  title: Text('Meus Locais',style: TextStyle(color: Colors.white,fontSize: 18)),
                  leading: Icon(Icons.location_pin, size: 35,color: Colors.white,),
                ),
                ListTile(
                  title: Text('Artigos',style: TextStyle(color: Colors.white,fontSize: 18)),
                  leading: Icon(Icons.menu_book, size: 35,color: Colors.white,),
                )
              ],
            ),
          ),
          body: Stack(
            fit: StackFit.loose,
            children: [
              mapWidget(),
              const MyBottomSheet(),
            ],
          ),
        ));
  }
}

class mapWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text('SolarWeb'), backgroundColor: Colors.green,
          leading: Icon(Icons.sunny, color: Colors.yellow,size: 40,),
          actions: [
            IconButton(
              icon: Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer(); // exibe o novo Drawer
              },
            ),
          ],
        ),
        body: Stack(children:[
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
                zoomControlsEnabled: true,
                myLocationButtonEnabled: true,
                onMapCreated: local.onMapCreated,
                markers: local.markers,
              );
            },
          ),
        ),Container(
              padding: EdgeInsets.symmetric(horizontal: 10 ),
              margin: EdgeInsets.symmetric(vertical: 30,horizontal: 20),
              width: Get.width*0.9,
              transformAlignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.yellow,
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextField(

            onTap: () async {
              // should show search screen here
              /*showSearch(
                context: context,
                // we haven't created AddressSearch class
                // this should be extending SearchDelegate
                delegate: AddressSearch(),
              );*/
            },
            // with some styling
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,

              hintText: "Busque um endereço",
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(left: 8.0, top: 6.0),
            ),
          )),
        ]
    )
    );
  }
}

class AddressSearch {
}
