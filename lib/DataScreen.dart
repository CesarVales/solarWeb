import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fl_chart/fl_chart.dart';

import 'dbControler.dart';
import 'globals.dart' as globals;

class DataScreen extends StatefulWidget {
  @override
  _DataScreenState createState() => _DataScreenState();

  final String imagePath;
  final double consumo;
  final double preco;
  final double lat;
  final double long;
  final double geracao;
  final String modelo;

  DataScreen({
    required this.imagePath,
    required this.consumo,
    required this.preco,
    required this.lat,
    required this.long,
    required this.geracao,
    required this.modelo,
  });

  String get image => imagePath;
}

List<BarChartGroupData> getBarChartGroup(List<FlSpot> chartData) {
  List<BarChartGroupData> retorno = [];
  var count = 0;

  for (var element in chartData) {
    retorno.add(
      BarChartGroupData(
        x: ++count,
        barRods: [
          BarChartRodData(
            y: chartData[(count - 1)].y,
            colors: [Colors.green],
            width: 20,
          ),
        ],
      ),
    );
  }
  return retorno;
}

double getMaxChartData(List<FlSpot> chartData) {
  var maior = 0.0;
  for (var element in chartData) {
    maior = (element.y > maior) ? element.y : maior;
  }
  return maior;
}

class _DataScreenState extends State<DataScreen> {
  List<FlSpot> _chartData = [];
  bool _isLoading = false;

  get lat => widget.lat;

  get long => widget.long;
  late var solarPanels;

  void fetchSolarPanels() async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('sistemasReais')
        .where('UrlImagem', isEqualTo: widget.imagePath)
        .get();
    setState(() {
      solarPanels = querySnapshot.docs.map((document) => document.data());
    });
  }

  @override
  void initState() {
    super.initState();
    chamadaApi();
    fetchSolarPanels();
  }

  Future<void> chamadaApi() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.get(Uri.parse(
          'https://re.jrc.ec.europa.eu/api/PVcalc?lat=${lat}&lon=${long}&peakpower=${widget.geracao}&slope=35&loss=14&outputformat=json'));
      final parsed = jsonDecode(response.body);
      print(parsed);

      if (response.statusCode == 200) {
        final monthlyData =
        parsed['outputs']['monthly']['fixed'] as List<dynamic>;
        setState(() {
          _chartData = monthlyData
              .map<FlSpot>((item) => FlSpot(
            item['month'].toDouble(),
            item['E_m'].toDouble(),
          ))
              .toList();
          _isLoading = false;
        });
      } else {
        throw Exception('Failed to load data');
      }
    } catch (error) {
      print(error);
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var mediaEnergia = mediaGeracao(_chartData);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Solaruébe',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.green,
        elevation: 0,
        centerTitle: true,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _chartData.isEmpty
          ? Center(child: Text('Sem dados disponíveis'))
          : Padding(
        padding: EdgeInsets.only(left: 1,right: 1),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: 300,padding: EdgeInsets.only(top:25,right: 10),
                child: BarChart(

                  BarChartData(
                    minY: 0,
                    maxY: (getMaxChartData(_chartData) * 1.1),
                    barGroups: getBarChartGroup(_chartData),
                    titlesData: FlTitlesData(
                      leftTitles: SideTitles(
                        showTitles: true,
                        interval: 5,
                        margin: 8,
                        reservedSize: 30,
                        getTitles: (value) {
                          if (value % 50 == 0) {
                            return value.toInt().toString();
                          }
                          return '';
                        },
                      ),
                      bottomTitles: SideTitles(
                        showTitles: true,
                        interval: 1,
                        margin: 8,
                        reservedSize: 30,
                        getTitles: (value) {
                          switch (value.toInt()) {
                            case 1:
                              return 'Jan';
                            case 2:
                              return 'Fev';
                            case 3:
                              return 'Mar';
                            case 4:
                              return 'Abr';
                            case 5:
                              return 'Mai';
                            case 6:
                              return 'Jun';
                            case 7:
                              return 'Jul';
                            case 8:
                              return 'Ago';
                            case 9:
                              return 'Set';
                            case 10:
                              return 'Out';
                            case 11:
                              return 'Nov';
                            case 12:
                              return 'Dec';
                            default:
                              return '';
                          }
                        },
                      ),
                    ),
                    borderData: FlBorderData(
                      show: false,
                      border: Border.all(
                        color: Colors.grey.withOpacity(0.5),
                        width: 0.5,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Consumo vs. Geração',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              AspectRatio(
                aspectRatio: 1.5, // Controla a proporção do gráfico em pizza
                child: PieChart(
                  PieChartData(
                    sections: [
                      PieChartSectionData(
                        color: Colors.green,
                        value: mediaEnergia,
                        title:
                        '${mediaEnergia.toStringAsFixed(2)} KW/H',
                        radius: 50,
                        titleStyle: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.black54,
                        ),
                      ),
                      PieChartSectionData(
                        color: Colors.amber,
                        value: widget.consumo,
                        title:
                        '${widget.consumo.toStringAsFixed(2)} KW/H',
                        radius: 50,
                        titleStyle: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                    sectionsSpace: 0,
                    centerSpaceRadius: 40,
                    startDegreeOffset: -90,
                  ),
                ),
              ),
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
                color: Colors.white,
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Relatório',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Colors.black,
                            ),
                          ),
                          Icon(
                            Icons.report,
                            color: Colors.black,
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Você geraria ${widget.consumo > widget.geracao ? mediaEnergia.toStringAsFixed(2) : widget.geracao.toStringAsFixed(2)} KW/H por mês em média.',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Você economizaria R\$ ${(widget.preco * mediaEnergia).toStringAsFixed(2)} ao mês e R\$ ${(12 * widget.preco * mediaEnergia).toStringAsFixed(2)} ao ano',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 8),
                      Row(
                        mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Modelo utilizado - ${widget.modelo}',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                            ),
                          ),
                          Icon(
                            Icons.info,
                            color: Colors.black,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Visibility(
                visible: widget.consumo < mediaEnergia, // Condição desejada
                child: Text(
                  'Atenção! Você geraria ${(mediaEnergia-widget.consumo).toStringAsFixed(2)} KW/H em excesso',
                  style: TextStyle(
                    fontSize: 18,
                    color: Color(0xBA801414),
                  ),
                ),
              ),
              SizedBox(height: 16),
              IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

double mediaGeracao(List<FlSpot> chartData) {
  var media = 0.0;

  for (var i in chartData) {
    media += i.y;
  }
  return media / 12;
}
