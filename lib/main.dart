import 'package:flutter/material.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:solar_web/my_bottom_sheet.dart';
import 'package:solar_web/map_controller.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterConfig.loadEnvVariables();
  runApp(
    ChangeNotifierProvider<map_controller>(
      create: (_) => map_controller(),
      child:MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var locale = map_controller().getPosicao();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My App',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: Scaffold(
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              const SizedBox(
                height: 100,
                  child: DrawerHeader(
                  child: Text('Home'),
                 decoration: BoxDecoration(
                   color: Colors.green
                 ),
              )),
              ListTile(
                title: const Text('data'),
              ),
              ListTile(
                title: const Text('data'),
              )
            ],
          ),
        ),
        body: Stack(
        fit: StackFit.loose,
        children: [
          mapWidget(),
        MyBottomSheet(),

        ],
      ),)
    );
  }
}

class mapWidget extends StatelessWidget    {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: Drawer(backgroundColor: Colors.teal),
        appBar: AppBar(title: Text('SolarWeb'), backgroundColor: Colors.green),
        body: ChangeNotifierProvider<map_controller>(
          create: (context) => map_controller(),
          child: Builder(builder: (context){
            final local = context.watch<map_controller>();
            debugPrint('laaat ${local.lat},${local.long}');

            return GoogleMap(initialCameraPosition: CameraPosition(
              target: LatLng(local.lat,local.long),
              zoom: 18,

            ),
              zoomControlsEnabled: true,
              myLocationButtonEnabled: true,
              onMapCreated: local.onMapCreated,
              markers: local.markers,
            );
          },),
        )

    );
  }
}
