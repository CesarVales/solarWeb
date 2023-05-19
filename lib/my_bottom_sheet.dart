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
      initialChildSize: 0.015,
      minChildSize: 0.005,
      maxChildSize: 0.6,
      builder: (BuildContext context, ScrollController scrollController) {

        return Material(
            color:Colors.green,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
            child: ListView.separated(
              padding: const EdgeInsets.all(10),
              controller: scrollController,
              itemCount: entries.length, // Altere o número de itens para exibir

              itemBuilder: (BuildContext context, int index) {
                return Card(
                    color: Colors.green,
                    elevation: 5,
                    child: ListTile(
                      contentPadding: EdgeInsets.symmetric(vertical: 10),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      trailing: Icon(Icons.arrow_forward),
                      tileColor: Colors.grey[200],
                      leading: Container(
                          width: 70,
                          height: 70,
                          child: Image.network(
                            'https://d2r9epyceweg5n.cloudfront.net/stores/002/321/284/products/kit-3-611-2afc20e8d66dc2ab2116795036769050-640-0.webp',
                            width: 80, // definir a largura da imagem
                            height: 70, // definir a altura da imagem
                            fit: BoxFit
                                .cover, // ajustar a imagem ao tamanho do container
                          )),
                      title: Container(
                          child: Text(
                              '${entries[index]}')), // Altere o título para cada item
                      subtitle: Text("usaiudhausidhauishduiashdiuahsiudh"),
                    ));
              },
              separatorBuilder: (BuildContext context, int index) =>
                  const Divider(),
            ));
      }

    );
  }
}
