import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_place/google_place.dart';
import 'package:solar_web/AppBarWidget.dart';
import 'package:solar_web/main.dart';
import 'package:solar_web/globals.dart' as globals;
import 'package:solar_web/map_controller.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final searchFieldController = TextEditingController();
  late GooglePlace googlePlace;
  Timer? delaySearch;
  List<AutocompletePrediction> recomendados = [];
  DetailsResult? posicaoEnd;
  late FocusNode focusNode;

  @override
  void initState() {
    super.initState();
    googlePlace = GooglePlace('AIzaSyDGzf0r-rPMwGSRkWwAizeK9pxHX5oBiJA');
    focusNode = FocusNode();
  }

  @override
  void dispose() {
    super.dispose();
    focusNode.dispose();
  }

  void autoComplete(String value) async {
    var result = await googlePlace.autocomplete.get(value);

    if (result != null && result.predictions != null && mounted) {
      setState(() {
        recomendados = result.predictions!;
      });
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    final scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBarWidget(scaffoldKey: scaffoldKey),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                autofocus: true,
                controller: searchFieldController,
                focusNode: focusNode,
                onChanged: (value) {
                  if (delaySearch?.isActive ?? false) delaySearch!.cancel();
                  delaySearch = Timer(const Duration(milliseconds: 500), () {
                    if (value.isNotEmpty) {
                      autoComplete(value);
                    } else {
                      setState(() {
                        recomendados = [];
                      });
                    }
                  });
                },
                decoration: InputDecoration(
                  prefixIcon: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.arrow_back),
                  ),
                  suffixIcon: GestureDetector(
                    onTap: () {
                      searchFieldController.clear();
                    },
                    child: Icon(Icons.clear),
                  ),
                  fillColor: Colors.white,
                  filled: true,
                  hintText: "Busque um endereço",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                ),
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: recomendados.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.green,
                      child: Icon(
                        Icons.solar_power,
                        color: Colors.white,
                      ),
                    ),
                    title: Text(recomendados[index].description ?? ''),
                    onTap: () async {
                      final placeId = recomendados[index].placeId!;
                      final detalhes = await googlePlace.details.get(placeId);

                      if (detalhes != null && detalhes.result != null) {
                        if (focusNode.hasFocus) {
                          setState(() {
                            posicaoEnd = detalhes.result;
                            searchFieldController.text = posicaoEnd!.formattedAddress!;
                            globals.posicaoEnd = detalhes.result;
                            recomendados = [];
                            Navigator.pushReplacement(context,
                                MaterialPageRoute(builder: (context) =>  MyApp()));                          });
                        }
                      }
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
