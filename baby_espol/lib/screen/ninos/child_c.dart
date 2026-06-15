import 'package:baby_espol/screen/ninos/funcion_ninos.dart';
import 'package:baby_espol/screen/extra/rest_api.dart';
import 'package:baby_espol/datos/bracelet.dart';
import 'package:baby_espol/estilo/texto.dart';
import 'package:baby_espol/datos/user.dart';
import 'package:flutter/material.dart';

class Child_C extends StatefulWidget {
  final List<String> lista_clases;
  final Size screenSize;
  final user usuario;

  Child_C(
      {required this.lista_clases,
      required this.screenSize,
      required this.usuario,
      Key? key})
      : super(key: key);

  @override
  _Child_C createState() => _Child_C();
}

class _Child_C extends State<Child_C> {
  List<Widget> listaNinos = [];
  bool change = false;

  @override
  void initState() {
    super.initState();
    cargarNinos();
  }

  void cargarNinos() async {
    List<Widget> ninos = await lista_nino_c(cargarNinos, widget.lista_clases,
        context, widget.usuario, widget.screenSize, change);

    setState(() {
      listaNinos = ninos;
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
              texto('Niños', Colors.white, 30, FontWeight.bold),
              Spacer(),
              InkWell(
                onTap: () {
                  setState(() {
                    change = !change;
                    cargarNinos();
                  });
                },
                child: Text(
                  change ? 'Listo' : 'Eliminar',
                  style: TextStyle(
                      color: Colors.black87,
                      decorationStyle: TextDecorationStyle.solid,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
        body: body());
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
                  for (Widget ninos in listaNinos)
                    Column(
                      children: [ninos, SizedBox(height: 15)],
                    ),
                ],
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              List<bracelet> lista_pulseras = await pulseras(context);
              nuevonino(cargarNinos, lista_pulseras, widget.lista_clases,
                  context, widget.usuario);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.yellow,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}
