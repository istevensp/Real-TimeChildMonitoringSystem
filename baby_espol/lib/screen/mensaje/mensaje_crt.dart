import 'package:baby_espol/screen/mensaje/funcion_mensaje.dart';
import 'package:baby_espol/screen/extra/rest_api.dart';
import 'package:baby_espol/screen/extra/home.dart';
import 'package:baby_espol/estilo/texto.dart';
import 'package:baby_espol/datos/user.dart';
import 'package:flutter/material.dart';

class Mensaje_CRT extends StatefulWidget {
  final List<String> lista_clases;
  final Size screenSize;
  final int id_anuncio;
  final String titulo;
  final user usuario;

  Mensaje_CRT(
      {required this.lista_clases,
      required this.screenSize,
      required this.id_anuncio,
      required this.titulo,
      required this.usuario,
      Key? key})
      : super(key: key);

  @override
  _Mensaje_CRT createState() => _Mensaje_CRT();
}

class _Mensaje_CRT extends State<Mensaje_CRT> {
  final TextEditingController mensajecontroller = TextEditingController();
  List<Widget> listaMensajes = [];

  @override
  void initState() {
    super.initState();
    cargarMensajes();
  }

  void cargarMensajes() async {
    List<Widget> mensajes = await lista_mensaje(context, widget.screenSize,
        widget.usuario, widget.id_anuncio, widget.titulo);

    setState(() {
      listaMensajes = mensajes;
    });
  }

  Future<void> enviarMensaje(String texto) async {
    if (texto.isNotEmpty) {
      if (await nuevoMensaje(
          context, widget.id_anuncio, widget.usuario.usuario, texto)) {
        cargarMensajes();
        mensajecontroller.clear();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.green[300],
        elevation: 1,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            texto_exp("${widget.titulo}", Colors.white, 22, FontWeight.bold,
                TextOverflow.clip, 1, true),
            Spacer(),
            InkWell(
              onTap: () async {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Home(
                        lista_clases: widget.lista_clases,
                        usuario: widget.usuario),
                  ),
                );
              },
              child: Icon(Icons.close_outlined, size: 25, color: Colors.black),
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
                children: listaMensajes,
              ),
            ),
          ),
          TextFormField(
            controller: mensajecontroller,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blue),
              ),
              hintText: 'Ingrese texto',
              suffixIcon: IconButton(
                onPressed: () => enviarMensaje(mensajecontroller.text),
                icon: Icon(Icons.send_outlined),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
