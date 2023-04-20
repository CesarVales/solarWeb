import 'package:flutter/material.dart';

class MyBottomSheet extends StatefulWidget {
  const MyBottomSheet({Key? key}) : super(key: key);

  @override
  _MyBottomSheetState createState() => _MyBottomSheetState();
}

final List<String> entries = [
  "JINKO TIGER NEO  470W",
  'JINKO TIGER NEO  470W 5KW ',
  'MÓDULO SOLAR AMERISOLAR AS-6P30 280W 60 CÉLULAS',
  "JINKO TIGER NEO  470W",
  'JINKO TIGER NEO  470W 5KW ',
  'MÓDULO SOLAR AMERISOLAR AS-6P30 280W 60 CÉLULAS'
];

class _MyBottomSheetState extends State<MyBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.3,
      minChildSize: 0.3,
      maxChildSize: 0.6,
      builder: (BuildContext context, ScrollController scrollController) {
        return Material(
          color: Colors.yellow.shade200,
            borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),),
            child: ListView.separated(
              padding: const EdgeInsets.all(10),
              controller: scrollController,
              itemCount: entries.length, // Altere o número de itens para exibir

              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  leading: const CircleAvatar(
                    backgroundImage: NetworkImage(
                        'https://cdn-icons-png.flaticon.com/512/234/234784.png'), // Altere o nome do arquivo de imagem para cada item
                  ),
                  title: Container(
                      child: Text(
                          '${entries[index]}')), // Altere o título para cada item
                  subtitle: Text("usaiudhausidhauishduiashdiuahsiudh"),
                );
              },
              separatorBuilder: (BuildContext context, int index) =>
                  const Divider(),
            ));
      },
    );
  }
}
