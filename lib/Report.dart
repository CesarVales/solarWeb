import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:solar_web/DataScreen.dart';
import 'package:solar_web/globals.dart' as globals;
import 'package:flutter/services.dart';

import 'AppBarWidget.dart';
import 'drawer.dart';

class Report extends StatefulWidget {
  const Report({Key? key}) : super(key: key);

  @override
  State<Report> createState() => _ReportState();
}

class _ReportState extends State<Report> {
  TextEditingController latController = TextEditingController();
  TextEditingController longController = TextEditingController();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController consumoController = TextEditingController();
  TextEditingController precoController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if(globals.posicaoEnd == null){
      latController =
          TextEditingController(text: globals.latitudeAtual?.toStringAsFixed(2));
      longController =
          TextEditingController(text: globals.longitudeAtual?.toStringAsFixed(2));
    }else{
      latController =
          TextEditingController(text: globals.posicaoEnd?.geometry?.location?.lat?.toStringAsFixed(2));
      longController =
          TextEditingController(text: globals.posicaoEnd?.geometry?.location?.lng?.toStringAsFixed(2));
    }
  }

  @override
  Widget build(BuildContext context) {
    var _quantidade;

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBarWidget(scaffoldKey: scaffoldKey),
      drawer: drawer(),
      body: Container(
        child: SingleChildScrollView(
          child: Align(
            alignment: Alignment.center,
            child: Column(
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.09),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  height: MediaQuery.of(context).size.height * 0.05,
                  child: TextField(
                    controller: consumoController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(60),
                      ),
                      labelText: 'Qual Seu Consumo mensal?',
                      suffixIcon: Tooltip(
                        triggerMode: TooltipTriggerMode.tap,
                        message: 'Pode olhar na conta de Luz seu otario',
                        child: Icon(Icons.info_outline),
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly
                    ],
                  ),
                ),
                SizedBox(height: 15),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  height: MediaQuery.of(context).size.height * 0.05,
                  child: TextField(
                    controller: precoController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(60),
                      ),
                      labelText: 'Qual a tarifa por KW/H?',
                      suffixIcon: Tooltip(
                        triggerMode: TooltipTriggerMode.tap,
                        message: 'Media Nacional: R\$ 0,85',
                        child: Icon(Icons.info_outline),
                      ),
                    ),
                    keyboardType: TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.4,
                      child: TextField(
                        controller: latController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(60),
                          ),
                          labelText: 'Lat',
                        ),
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly
                        ],
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.4,
                      child: TextField(
                        controller: longController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(60),
                          ),
                          labelText: 'Long',
                        ),
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly
                        ],
                      ),
                    )
                  ],
                ),
                SizedBox(height: 20),
                SolarPanelList(
                    consumoController: (consumoController),
                    precoController: (precoController),
                    latController: (latController),
                    longController: (longController)),
                SizedBox(height: 15),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SolarPanelList extends StatefulWidget {
  TextEditingController latController;
  TextEditingController longController;
  TextEditingController precoController;
  TextEditingController consumoController;

  SolarPanelList({
    required this.latController,
    required this.longController,
    required this.precoController,
    required this.consumoController,
  });
  @override
  State<SolarPanelList> createState() => _SolarPanelListState();
}

class _SolarPanelListState extends State<SolarPanelList> {
  final ScrollController _scrollController = ScrollController();
  final Duration _scrollDuration =
      Duration(seconds: 5); // Defina a duração de rolagem
  final double _scrollDistance = 2000; // Defina a distância de rolagem

  List<Map<String, dynamic>> solarPanels = [];

  @override
  void initState() {
    super.initState();
    fetchSolarPanels();
  }

  void fetchSolarPanels() async {
    final querySnapshot =
        await FirebaseFirestore.instance.collection('sistemasReais').get();
    setState(() {
      solarPanels = querySnapshot.docs
          .map((document) => document.data() as Map<String, dynamic>)
          .toList();
    });

    // Iniciar a rolagem automática após o carregamento dos dados
    _startAutoScroll();
  }

  void _startAutoScroll() {
    Timer.periodic(_scrollDuration, (_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.pixels + _scrollDistance,
          duration: _scrollDuration,
          curve: Curves.linear,
        );
      }
    });
  }

  void handleCardTap(
      String imagePath, double consumo, double preco, double lat, double long, double geracao,String modelo) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DataScreen(
            imagePath: imagePath,
            consumo: consumo,
            preco: preco,
            lat: lat,
            long: long,
            geracao: geracao,
            modelo: modelo


        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        controller: _scrollController,
        itemCount: solarPanels.length,
        separatorBuilder: (context, index) => SizedBox(width: 10),
        itemBuilder: (context, index) {
          final json = solarPanels[index];

          return GestureDetector(
            onTap: () {
              if (widget.consumoController.text.isNumericOnly ||
                  widget.precoController.text.isNumericOnly) {
                handleCardTap(
                    json['UrlImagem'],
                    double.parse(widget.consumoController.text),
                    double.parse(widget.precoController.text),
                    double.parse(widget.latController.text),
                    double.parse(widget.longController.text),
                    (json['PotenciaKit'])  ,(json['Modelo']),
                );
              } else {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Título da caixa de diálogo'),
                      content: Text('Conteúdo da caixa de diálogo'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            // Ação ao pressionar o botão
                            Navigator.of(context)
                                .pop(); // Fechar a caixa de diálogo
                          },
                          child: Text('Fechar'),
                        ),
                      ],
                    );
                  },
                );
              }
            },
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
              ),
              color: Colors.blueGrey[50], // Cor de fundo do card
              child: Container(
                width: MediaQuery.of(context).size.width * 0.95,
                margin: EdgeInsets.symmetric(horizontal: 2.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      height: 120,
                      width: 150,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(16.0),
                          bottomLeft: Radius.circular(16.0),
                        ),
                        image: DecorationImage(
                          image: NetworkImage('https://' + json['UrlImagem']),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              json['Modelo'],
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Potência Unitária: ${json['PotenciaMaxPainel'].toString()}W',
                              style: TextStyle(
                                fontSize: 14,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Eficiência: 20%',
                              style: TextStyle(
                                fontSize: 14,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Geração média por mês:',
                              style: TextStyle(
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              '${json['PotenciaKit'].toString()} W',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
