import 'package:baby_espol/screen/extra/rest_api.dart';
import 'package:baby_espol/datos/bracelet.dart';
import 'package:baby_espol/estilo/texto.dart';
import 'package:flutter/material.dart';

Future<List<Widget>> lista_pulseras_c(
    void Function() funcion, BuildContext context, Size screenSize) async {
  List<Widget> children = [];
  List<bracelet> lista_pulseras = await pulseras(context);
  for (bracelet b in lista_pulseras) {
    children.add(
      Container(
        padding: EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
        width: screenSize.width,
        decoration: BoxDecoration(
          color: Colors.grey,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: (screenSize.width) - (screenSize.width * 0.2),
                  child: Row(
                    children: [
                      Icon(Icons.brightness_1,
                          color: b.bateria < 25
                              ? Colors.red
                              : (b.bateria < 60 ? Colors.yellow : Colors.green),
                          size: 25),
                      SizedBox(width: 10),
                      Expanded(
                        child: texto_exp(
                            b.id_pulsera.toString(),
                            Colors.black87,
                            20,
                            FontWeight.bold,
                            TextOverflow.ellipsis,
                            1,
                            false),
                      ),
                      Spacer(),
                      texto('${b.bateria.toString()}%', Colors.black87, 20,
                          FontWeight.bold)
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  return children;
}
