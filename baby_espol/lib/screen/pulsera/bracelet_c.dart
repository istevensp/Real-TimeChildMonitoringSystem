import 'package:baby_espol/screen/pulsera/funcion_pulsera.dart';
import 'package:baby_espol/estilo/texto.dart';
import 'package:flutter/material.dart';

class Bracelet_C extends StatefulWidget {
  final Size screenSize;

  Bracelet_C({required this.screenSize, Key? key}) : super(key: key);

  @override
  _Bracelet_C createState() => _Bracelet_C();
}

class _Bracelet_C extends State<Bracelet_C> {
  List<Widget> listaPulsera = [];

  @override
  void initState() {
    super.initState();
    cargarPulseras();
  }

  void cargarPulseras() async {
    List<Widget> pulseras =
        await lista_pulseras_c(cargarPulseras, context, widget.screenSize);

    setState(() {
      listaPulsera = pulseras;
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
            texto('Pulseras', Colors.white, 30, FontWeight.bold),
          ],
        ),
      ),
      body: body(),
    );
  }

  Widget body() {
    return Container(
      padding: EdgeInsets.fromLTRB(20.0, 32.0, 20.0, 32.0),
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  for (Widget pulsera in listaPulsera)
                    Column(
                      children: [pulsera, SizedBox(height: 15)],
                    ),
                ],
              ),
            ),
          ),
          SizedBox(height: 15),
          ElevatedButton(
            onPressed: () {
              // Acción al presionar el botón
            },
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
              backgroundColor: Colors.yellow,
            ),
            child: Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}
