import 'package:baby_espol/screen/anuncio/funcion_anuncio.dart';
import 'package:baby_espol/estilo/texto.dart';
import 'package:baby_espol/datos/user.dart';
import 'package:flutter/material.dart';

class Anuncio_R extends StatefulWidget {
  final List<String> lista_clases;
  final Size screenSize;
  final user usuario;

  Anuncio_R(
      {required this.lista_clases,
      required this.screenSize,
      required this.usuario,
      Key? key})
      : super(key: key);

  @override
  _Anuncio_R createState() => _Anuncio_R();
}

class _Anuncio_R extends State<Anuncio_R> {
  List<Widget> listaAnuncios = [];
  bool change = true;

  @override
  void initState() {
    super.initState();
    cargarAnuncios();
  }

  void cargarAnuncios() async {
    List<Widget> anuncios = await lista_anuncio_ctr(
        cargarAnuncios,
        widget.lista_clases,
        context,
        widget.usuario,
        change,
        widget.screenSize);

    setState(() {
      listaAnuncios = anuncios;
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
            texto('Mensajes', Colors.white, 30, FontWeight.bold),
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
                  for (Widget anuncio in listaAnuncios)
                    Column(
                      children: [anuncio, SizedBox(height: 15)],
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
