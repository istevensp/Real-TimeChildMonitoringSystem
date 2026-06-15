import 'package:baby_espol/screen/extra/rest_api.dart';
import 'package:baby_espol/datos/bracelet.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:baby_espol/datos/child.dart';
import 'package:baby_espol/datos/user.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

Future<List<dynamic>> lista_pulsera(
    BuildContext context, user usuario, Size screenSize) async {
  List<dynamic> contenido = [];
  List<child> listaNino = await ninos(context, usuario.usuario);
  List<bracelet> listaPulsera = await pulseras(context);
  List<Marker> children = [];
  double sumLat = 0.0;
  double sumLng = 0.0;

  for (bracelet b in listaPulsera) {
    for (child c in listaNino) {
      if (b.id_pulsera == c.id_pulsera) {
        children.add(
          Marker(
            width: 40.0,
            height: 40.0,
            point: LatLng(b.longitud, b.latitud),
            builder: (ctx) => Container(
              child: Center(
                child: Column(
                  children: [
                    Text(b.id_pulsera.toString()),
                    Icon(Icons.location_on_outlined)
                  ],
                ),
              ),
            ),
          ),
        );
        sumLat += b.latitud;
        sumLng += b.longitud;
      }
    }
  }
  contenido.add(children);
  double avgLat = listaNino.isNotEmpty ? sumLat / listaNino.length : 0.0;
  contenido.add(avgLat);
  double avgLng = listaNino.isNotEmpty ? sumLng / listaNino.length : 0.0;
  contenido.add(avgLng);
  return contenido;
}
