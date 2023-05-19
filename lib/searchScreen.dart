import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_place/google_place.dart';
import 'package:solar_web/AppBarWidget.dart';
import 'package:solar_web/main.dart';
import 'package:solar_web/globals.dart' as globals;
class searchScreen extends StatefulWidget {
  const searchScreen({Key? key}) : super(key: key);

  @override
  State<searchScreen> createState() => _searchScreenState();
}

class _searchScreenState extends State<searchScreen> {
  final searchFieldController = TextEditingController();
  late GooglePlace googlePlace;
  Timer? delaySearch;
  List<AutocompletePrediction> recomendados = []; //list para recomendaçoes
  DetailsResult? posicaoEnd; // variavel global definida no globals (coisa de psicopata)
  late FocusNode focusNode;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    googlePlace = GooglePlace('AIzaSyDExRcS073ga9tfDmfynJA4n_regjAC3yg');
    focusNode = FocusNode();
  }

  @override
  void dispose() { //destroi o focusNode
    super.dispose();
    focusNode.dispose();
  }

  void autoComplete(String value) async {
    var result = await googlePlace.autocomplete.get(value);

    if (result != null && result.predictions != null && mounted) {
      //mounted verifica se esta na arvore
      setState(() {
        print(result.predictions!.first.description);
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
          crossAxisAlignment: CrossAxisAlignment.center,//remover
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
              offset: Offset(0, 2), // Define a direção da sombra (horizontal, vertical)
            ),
          ],
        ),
            child: TextField(
              autofocus: true,
              controller: searchFieldController,
              focusNode: focusNode,
              onTap: () async {
                // should show search screen here
                /*showSearch(
                        context: context,
                        // we haven't created AddressSearch class
                        // this should be extending SearchDelegate
                        delegate: AddressSearch(),
                      );*/
              },
              onChanged: (value) {
                if (delaySearch?.isActive ?? false)
                  delaySearch!
                      .cancel(); //Evita que o delay reinicie a cada onChange
                delaySearch = Timer(const Duration(milliseconds: 500), () {
                  if (value.isNotEmpty) {
                    autoComplete(value);
                  } else {}
                });
              },
              // with some styling
              decoration: InputDecoration(

                suffixIcon: GestureDetector(onTap: () {
                    searchFieldController.clear();
                  },child:Icon(Icons.clear)),
                fillColor: Colors.white,
                filled: true,
                hintText: "Busque um endereço",
                border: InputBorder.none,

                contentPadding: EdgeInsets.only(left: 8.0, top: 6.0),
              ),
            ),
          ),
              ListView.builder(
                shrinkWrap: true,
                itemCount: recomendados.length,
                itemBuilder: ( context,  index) {
                  return ListTile(
                    hoverColor: Colors.black,
                    leading: CircleAvatar(child: Icon(Icons.solar_power_outlined,color: Colors.green,size: 30,),backgroundColor: Colors.transparent),
                    title: Text(recomendados[index].description.toString()),
                    onTap: () async {
                      final placeId = recomendados[index].placeId!; // pega id do local
                      final detalhes = await googlePlace.details.get(placeId); // usa a api para retornar os detalhes
                      if(detalhes != null && detalhes.result != null){
                        if(focusNode.hasFocus){
                          setState(() {
                            posicaoEnd = detalhes.result;
                            searchFieldController.text = posicaoEnd!.formattedAddress!;
                            globals.posicaoEnd = detalhes.result;

                            recomendados = [];
                              Navigator.push(context,
                              MaterialPageRoute(builder: (context) => MyApp()));
                              },
                          );
                        }
                      }
                    },
                  );
                },

              )
        ]),
      ),
    );
  }
}