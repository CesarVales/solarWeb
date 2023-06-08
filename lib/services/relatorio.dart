import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:solar_web/main.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:http/http.dart' as http;
import 'package:solar_web/globals.dart' as globals;

class relatorio extends StatefulWidget {
  @override
  _relatorioState createState() => _relatorioState();
}

class _relatorioState extends State<relatorio> {
  Stream<Map<dynamic, String>>? _dadosStream;

  @override
  void initState() {
    super.initState();
    _dadosStream = chamadaApi() as Stream<Map<dynamic, String>>?;
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Line Chart Example'),
      ),
      body: StreamBuilder<Map<dynamic, String>>(
        stream: _dadosStream,
        builder: (BuildContext context,
            AsyncSnapshot<Map<dynamic, String>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          } else if (!snapshot.hasData) {
            return Center(
              child: Text('Nenhum dado disponível'),
            );
          } else {
            List<FlSpot> chartData = [];
            double i = 0.0;
            snapshot.data?.forEach((chave, dados) {
              chartData.add(FlSpot(++i, double.parse(dados)));
            });

            return Padding(
              padding: EdgeInsets.all(16.0),
              child: LineChart(
                LineChartData(
                  minX: 0,
                  maxX: 5,
                  minY: 0,
                  maxY: 10,
                  lineBarsData: [
                    LineChartBarData(
                      spots: chartData,
                      isCurved: true,
                      colors: [Colors.blue],
                      barWidth: 2,
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}

Future<Map<String,dynamic>> chamadaApi() async {
  final response = await http.get(Uri.parse(
      'https://re.jrc.ec.europa.eu/api/PVcalc?lat=${globals.latitudeAtual}&lon=${globals.longitudeAtual}&peakpower=1&loss=14'));
  final parsed = jsonDecode(response.body).cast<Map<String, dynamic>>();
  print(parsed.convert);

  if (response.statusCode == 200) {

    return parsed;
  } else {

    throw Exception('Failed to load album');
  }
}

Stream<List<FlSpot>> chamadaApilist() {
  final streamController = StreamController<List<FlSpot>>();

  http.get(Uri.parse('https://re.jrc.ec.europa.eu/api/PVcalc?lat=${globals.latitudeAtual}&lon=${globals.longitudeAtual}&peakpower=1&loss=14&outputformat=json')).then((response) {
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body).cast<Map<String, dynamic>>();
      final chartData = <FlSpot>[];
      double i = 0.0;

      jsonData.forEach((dados) {
        chartData.add(FlSpot(++i, double.parse(dados.toString())));
      });

      streamController.add(chartData);
      streamController.close();
    } else {
      streamController.addError('Erro na requisição');
    }
  }).catchError((error) {
    streamController.addError(error);
  });

  return streamController.stream;
}

class PVcalc{
   int mes;
   double mediaKw;

   PVcalc({required this.mes,required this.mediaKw});
}

Stream<Map<dynamic, String>> chamadaApia() {
  final streamController = StreamController<Map<dynamic, String>>();

  http
      .get(Uri.parse(
      'https://re.jrc.ec.europa.eu/api/PVcalc?lat=${globals.latitudeAtual}&lon=${globals.longitudeAtual}&peakpower=1&loss=14&outputformat=json'))
      .then((response) {
    if (response.statusCode == 200) {
      print(response.body);
      streamController.add(jsonDecode(response.body));
      streamController.close();
    } else {

      streamController.addError('Erro na requisição');
    }
  }).catchError((error) {
    streamController.addError(error);
  });

  return streamController.stream;
}