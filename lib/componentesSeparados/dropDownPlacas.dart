


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../globals.dart' as globals;


class dropDownPlacas extends StatefulWidget {
  const dropDownPlacas({super.key});

  @override
  State<dropDownPlacas> createState() => _dropDownPlacasState();
}
List<Map<String, dynamic>> solarPanels = [];
final array = [];


class _dropDownPlacasState extends State<dropDownPlacas> {

  void getPotenciaMax() async {
    final querySnapshot = await FirebaseFirestore.instance.collection('sistemasReais').where('Modelo', isEqualTo: dropdownValue).get();

    print(globals.potenciaMax);
    globals.potenciaMax = querySnapshot.docs.first['PotenciaMaxPainel'].toString();
  }
  void getPotenciaKit() async {
    final querySnapshot = await FirebaseFirestore.instance.collection('sistemasReais').where('Modelo', isEqualTo: dropdownValue).get();
    globals.potenciaKit = querySnapshot.docs.first['PotenciaKit'].toString();
  }

  String dropdownValue = globals.placas[0];
  // String dropdownValue = 'Intelbras 335w';

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: dropdownValue,
      icon: const Icon(Icons.arrow_downward),
      elevation: 16,
      style:
      const TextStyle(color: Colors.green),
      underline: Container(
        height: 2,
        color: Colors.green,
      ),
      onChanged: (String? value) {
        // This is called when the user selects an item.
        setState(() {
          dropdownValue = value!;
          getPotenciaMax();
          getPotenciaKit();
          globals.modeloPlaca = dropdownValue;
        });
      },
      items: globals.placas.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}