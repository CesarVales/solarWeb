import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fl_chart/fl_chart.dart';

import 'globals.dart' as globals;

class DataScreen extends StatefulWidget {
  @override
  _DataScreenState createState() => _DataScreenState();
}

List<BarChartGroupData> getBarChartGroup(List<FlSpot> chartData){
  List<BarChartGroupData> retorno=[];
  var count =  0;
  for (var element in chartData) {
    retorno.add(
      BarChartGroupData(
        x: ++count,
        barRods: [
          BarChartRodData(
            y: chartData[(count-1)].y,
            colors: [Colors.green],
            width: 20,
          ),
        ],
      )
    );
  }return retorno;
}
double getMaxChartData(List<FlSpot> chartData){
  var maior = 0.0;
  for (var element in chartData) {
     maior = (element.y > maior) ? element.y : maior;

  }
  return maior;
}
class _DataScreenState extends State<DataScreen> {
  List<FlSpot> _chartData = [];
  bool _isLoading = false;


  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.get(Uri.parse(
          'https://re.jrc.ec.europa.eu/api/PVcalc?lat=${globals.latitudeAtual}&lon=${globals.longitudeAtual}&peakpower=1&loss=14&outputformat=json'));
      final parsed = jsonDecode(response.body);
      print(parsed);

      if (response.statusCode == 200) {
        final monthlyData = parsed['outputs']['monthly']['fixed'] as List<dynamic>;
        setState(() {
          _chartData = monthlyData
              .map<FlSpot>((item) => FlSpot(item['month'].toDouble(), item['E_m'].toDouble()))
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
    return Scaffold(
      appBar: AppBar(
        title: Text('Solaruébe'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _chartData.isEmpty
          ? Center(child: Text('No data available'))
          : Padding(
        padding: EdgeInsets.all(16.0),
        child: BarChart(
          BarChartData(
            minY: 0,
            maxY: (getMaxChartData(_chartData)*1.1),
            barGroups: getBarChartGroup(_chartData),
            titlesData: FlTitlesData(
              leftTitles: SideTitles(
                showTitles: true,
                interval: 5,
                margin: 8,
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
        )
        ,
      ),
    );
  }
}
