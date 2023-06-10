import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class dropDown extends StatefulWidget {
  const dropDown({super.key});

  @override
  State<dropDown> createState() => _dropDownState();
}
List<String> list = ['B1 - Residencial	0,65313', 'B1 - Residencial Baixa Renda	0,54537', '  Residencial Mensal até 30 kWh', '   Residencial Mensal de 31 kWh até 100 kWh'];

class _dropDownState extends State<dropDown> {

  String dropdownValue = list.first;

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
        });
      },
      items: list.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}
