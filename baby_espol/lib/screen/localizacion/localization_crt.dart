import 'package:baby_espol/screen/localizacion/funcion_localiation.dart';
import 'package:baby_espol/estilo/texto.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:baby_espol/datos/user.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

class Localization_CRT extends StatefulWidget {
  final Size screenSize;
  final user usuario;

  Localization_CRT({required this.screenSize, required this.usuario, Key? key})
      : super(key: key);

  @override
  _Localization_CRT createState() => _Localization_CRT();
}

class _Localization_CRT extends State<Localization_CRT> {
  MapController mapController = MapController();
  List<dynamic> listaPulsera = [];

  @override
  void initState() {
    super.initState();
    cargarPulsera();
  }

  void cargarPulsera() async {
    List<dynamic> pulsera =
        await lista_pulsera(context, widget.usuario, widget.screenSize);

    setState(() {
      listaPulsera = pulsera;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.green[300],
        elevation: 1,
        title: Row(
          children: [
            texto('Localizacion', Colors.white, 30, FontWeight.bold),
          ],
        ),
      ),
      body: body(),
    );
  }

  Widget body() {
    if (listaPulsera.isEmpty) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    return Stack(
      children: [
        Container(
          padding: EdgeInsets.fromLTRB(20.0, 32.0, 20.0, 32.0),
          child: FlutterMap(
            options: MapOptions(
              minZoom: 5,
              maxZoom: 18,
              zoom: 18,
              center: LatLng(listaPulsera[2], listaPulsera[1]),
            ),
            layers: [
              TileLayerOptions(
                urlTemplate:
                    'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                subdomains: ['a', 'b', 'c'],
              ),
              MarkerLayerOptions(markers: listaPulsera[0])
            ],
          ),
        ),
      ],
    );
  }
}
