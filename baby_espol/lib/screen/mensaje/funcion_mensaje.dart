import 'package:baby_espol/screen/extra/rest_api.dart';
import 'package:baby_espol/datos/mensaje.dart';
import 'package:baby_espol/estilo/texto.dart';
import 'package:baby_espol/datos/user.dart';
import 'package:flutter/material.dart';

Future<List<Widget>> lista_mensaje(BuildContext context, Size screenSize,
    user usuario, int id_anuncio, String titulo) async {
  List<message> lista_mensaje = await mensajes(context, id_anuncio);
  List<Widget> children = [];

  for (message m in lista_mensaje) {
    children.add(
      Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          width: screenSize.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                decoration: BoxDecoration(
                  color:
                      m.usuario == usuario.usuario ? Colors.grey : Colors.blue,
                  borderRadius: BorderRadius.circular(10),
                ),
                alignment: m.usuario == usuario.usuario
                    ? Alignment.centerRight
                    : Alignment.centerLeft,
                width: screenSize.width,
                child: Padding(
                  padding: EdgeInsets.all(10.0),
                  child: texto_exp('${m.usuario}: ${m.mensaje}', Colors.black,
                      17, FontWeight.bold, TextOverflow.ellipsis, 2, true),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  return children;
}
