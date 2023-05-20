
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class map_controller extends ChangeNotifier {
  double lat = 0.0;
  double long = 0.0;
  String erro = '';
  Set<Marker> markers = Set<Marker>();

  late GoogleMapController _mapsController;

  /*map_controller() {
    getPosicao();
  }*/
  get mapsController => _mapsController;

  onMapCreated(GoogleMapController gmc) async {
    _mapsController = gmc;
    await getPosicao();
    await setMarker();
  }

  setMarker() async {
    Position posicao = await _posicaoAtual();

    String imgurl = "https://cdn3.iconfinder.com/data/icons/map-objects/154/sun-light-poi-pointer-location-160.png";
    Uint8List bytes = (await NetworkAssetBundle(Uri.parse(imgurl))
        .load(imgurl))
        .buffer
        .asUint8List();
    markers.add(Marker(
        markerId: MarkerId('markerUsuario'),
        position: LatLng(posicao.latitude, posicao.longitude),
        icon: BitmapDescriptor.fromBytes(bytes),
        draggable: true,


    ));
    notifyListeners();
    return markers;
  }
  Future<LatLng> getPosicao() async {
    try {
      Position posicao = await _posicaoAtual();
      lat = posicao.latitude;
      long = posicao.longitude;
      _mapsController.animateCamera(CameraUpdate.newLatLng(LatLng(lat, long)));
    } catch (e) {
      erro = e.toString();
    }
    notifyListeners();
    return LatLng(lat, long);
  }
  void moveCameraToPosition(LatLng position) {
    _mapsController.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
        target: position,
        zoom: 18,
      ),
    ));
  }
  Future<Position> _posicaoAtual() async {
    LocationPermission permissao;

    bool ativado = await Geolocator.isLocationServiceEnabled();
    if (!ativado) {
      return Future.error('Por favor, habilite a localização no smartphone');
    }

    permissao = await Geolocator.checkPermission();
    if (permissao == LocationPermission.denied) {
      permissao = await Geolocator.requestPermission();
      if (permissao == LocationPermission.denied) {
        return Future.error('Você precisa autorizar o acesso à localização');
      }
    }

    if (permissao == LocationPermission.deniedForever) {
      return Future.error('Você precisa autorizar o acesso à localização');
    }

    return await Geolocator.getCurrentPosition();
  }
}

