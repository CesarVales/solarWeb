import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:map/map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:solar_web/map_controller.dart';
import 'package:solar_web/searchScreen.dart';
import 'package:solar_web/globals.dart' as globals;

class mapWidget extends StatefulWidget {
  @override
  State<mapWidget> createState() => _mapWidgetState();
}

class _mapWidgetState extends State<mapWidget> {
  late BitmapDescriptor icon;
  @override
  void initState() {
    super.initState();
    BitmapDescriptor.fromAssetImage(
        ImageConfiguration(), 'assets/pino-de-localizacao.png')
        .then((value) => icon = value);
  }
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
                myLocationEnabled: true,
                buildingsEnabled: true,
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
                  Navigator.pop(context,
                      MaterialPageRoute(builder: (context) => const searchScreen())
                  );}
                // else {
                //   globals.posicaoEnd = null;
                // }

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

