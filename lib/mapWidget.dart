import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:map/map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:solar_web/map_controller.dart';
class mapWidget extends StatelessWidget    {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('SolarWeb'), backgroundColor: Colors.green),
      body: ChangeNotifierProvider<map_controller>(
        create: (context) => map_controller(),
        child: Builder(builder: (context){
          final local = context.watch<map_controller>();

          return GoogleMap(initialCameraPosition: CameraPosition(
            target: LatLng(local.lat,local.long),
            zoom: 18,

          ));
        },),
      )

    );
  }
}
