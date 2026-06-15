import 'package:baby_espol/screen/anuncio/funcion_anuncio.dart';
import 'package:baby_espol/estilo/texto.dart';
import 'package:baby_espol/datos/user.dart';
import 'package:flutter/material.dart';

class Anuncio_CT extends StatefulWidget {
  final List<String> lista_clases;
  final Size screenSize;
  final user usuario;

  Anuncio_CT(
      {required this.lista_clases,
      required this.screenSize,
      required this.usuario,
      Key? key})
      : super(key: key);

  @override
  _Anuncio_CT createState() => _Anuncio_CT();
}

class _Anuncio_CT extends State<Anuncio_CT> {
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
            Spacer(),
            InkWell(
              onTap: () {
                setState(() {
                  change = !change;
                  cargarAnuncios();
                });
              },
              child: Text(
                change ? 'Eliminar' : 'Listo',
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
          ElevatedButton(
            onPressed: () async {
              nuevoanuncio(cargarAnuncios, widget.lista_clases, context,
                  widget.screenSize, widget.usuario, change);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.yellow,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
            ),
            child: Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}
