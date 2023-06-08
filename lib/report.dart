import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:solar_web/globals.dart' as globals;
import 'package:flutter/gestures.dart';

class report extends StatefulWidget {
  const report({Key? key}) : super(key: key);
  @override
  State<report> createState() => _reportState();
}

class _reportState extends State<report>  {

  @override
  Widget build(BuildContext context) {


    var _quantidade;
    return  Scaffold(
     body: Container(
       child: SingleChildScrollView(
         child: Align(
           alignment: Alignment.center,

           child: Column(
             children:[
               SizedBox(height: 50,),
               SizedBox(
                 width: 300.0,
                 child: TextField(
                   controller:_quantidade ,
                   decoration: InputDecoration(
                     border: OutlineInputBorder(
                       borderRadius: BorderRadius.circular(60),

                     ),
                     labelText: 'Qual Seu Consumo mensal?',
                   ),
                   keyboardType: TextInputType.number,
                   inputFormatters: <TextInputFormatter>[
                     FilteringTextInputFormatter.digitsOnly
                   ],

                 ),
               ), SolarPanelCarousel(),

             ]
           ),
         ),
       ),
     ),
    );
  }
}
class SolarPanelCarousel extends StatelessWidget {
  final List<String> solarPanelImages = [
    'https://institutosolar.com/wp-content/uploads/2019/05/Manuten%C3%A7%C3%A3o-do-painel-solar.jpg',
    'https://institutosolar.com/wp-content/uploads/2019/05/Manuten%C3%A7%C3%A3o-do-painel-solar.jpg',
    'https://institutosolar.com/wp-content/uploads/2019/05/Manuten%C3%A7%C3%A3o-do-painel-solar.jpg',
  ];

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      options: CarouselOptions(
        height: 200,
        autoPlay: true,
        enlargeCenterPage: true,
      ),
      items: solarPanelImages.map((imagePath) {
        return Builder(
          builder: (BuildContext context) {
            return  Card(elevation:4 ,

              child: Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.symmetric(horizontal: 5.0),
                child: Row(
                  children: [
                    SizedBox(
                      child: Image.network(
                        height: 150, width: 180,

                        imagePath,
                        fit: BoxFit.scaleDown,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }).toList(),
    );
  }
}
