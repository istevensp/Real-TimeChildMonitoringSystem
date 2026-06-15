import 'package:baby_espol/screen/mensaje/mensaje_crt.dart';
import 'package:baby_espol/screen/extra/rest_api.dart';
import 'package:baby_espol/datos/advertisement.dart';
import 'package:baby_espol/estilo/texto.dart';
import 'package:baby_espol/datos/user.dart';
import 'package:flutter/material.dart';

void nuevoanuncio(void Function() funcion, List<String> lista_clases,
    BuildContext context, Size screenSize, user usuario, bool change) {
  TextEditingController mensajeController = TextEditingController();
  TextEditingController tituloController = TextEditingController();
  TextEditingController claseController = TextEditingController();
  int cuenta = 0;

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return Container(
            padding: EdgeInsets.fromLTRB(20.0, 32.0, 20.0, 32.0),
            child: SimpleDialog(
              contentPadding: EdgeInsets.fromLTRB(20.0, 32.0, 20.0, 32.0),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Nuevo Anuncio',
                    style: TextStyle(color: Colors.black87),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Icon(Icons.close_outlined,
                        size: 25, color: Colors.black),
                  ),
                ],
              ),
              children: [
                rellenar(controlador: tituloController, pista: 'Titulo'),
                SizedBox(height: 10),
                rellenar(controlador: mensajeController, pista: 'Mensaje'),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () {
                        setState(() {
                          if (cuenta < lista_clases.length - 1) {
                            cuenta++;
                            claseController.text = lista_clases[cuenta];
                          }
                        });
                      },
                      child: Icon(Icons.add, size: 30, color: Colors.black),
                    ),
                    SizedBox(width: 10),
                    Container(
                      width: (MediaQuery.of(context).size.width) -
                          (MediaQuery.of(context).size.width * 0.8),
                      child: TextFormField(
                        controller: claseController,
                        enabled: false,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 5.0, horizontal: 5.0),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    InkWell(
                      onTap: () {
                        setState(() {
                          if (cuenta > 0) {
                            cuenta--;
                            claseController.text = lista_clases[cuenta];
                          }
                        });
                      },
                      child: Icon(Icons.remove, size: 30, color: Colors.black),
                    ),
                  ],
                ),
                SizedBox(height: 15),
                ElevatedButton(
                  onPressed: () async {
                    if (await nuevoAnuncio(
                        context,
                        tituloController.text,
                        claseController.text,
                        usuario.usuario,
                        mensajeController.text,
                        lista_clases)) {
                      funcion();
                      Navigator.pop(context);
                    } else {
                      Navigator.pop(context);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                    backgroundColor: Colors.yellow,
                  ),
                  child: Text('Guardar'),
                ),
              ],
            ),
          );
        },
      );
    },
  );
}

Future<List<Widget>> lista_anuncio_ctr(
    void Function() funcion,
    List<String> lista_clases,
    BuildContext context,
    user usuario,
    bool change,
    Size screenSize) async {
  List<advertisement> lista_anuncios = await anuncios(context, lista_clases);
  List<Widget> children = [];
  for (advertisement a in lista_anuncios) {
    children.add(
      Row(
        children: [
          Icon(Icons.email_outlined, size: 30),
          SizedBox(width: 5),
          Container(
            decoration: BoxDecoration(
              border:
                  Border(bottom: BorderSide(color: Colors.black, width: 1.5)),
            ),
            width: (screenSize.width) - (screenSize.width * 0.2),
            child: Row(
              children: [
                Expanded(
                  child: texto_exp('${a.clase}: ${a.titulo}', Colors.black87,
                      25, FontWeight.bold, TextOverflow.ellipsis, 1, true),
                ),
                SizedBox(width: 25),
                InkWell(
                  onTap: () async {
                    if (change) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Mensaje_CRT(
                              lista_clases: lista_clases,
                              id_anuncio: a.id_anuncio,
                              screenSize: screenSize,
                              usuario: usuario,
                              titulo: a.titulo),
                        ),
                      );
                    } else {
                      if (await eliminarAnuncio(context, a.id_anuncio)) {
                        funcion();
                      }
                    }
                  },
                  child: change
                      ? Icon(Icons.arrow_right_outlined,
                          size: 30, color: Colors.black)
                      : Icon(Icons.delete, size: 30, color: Colors.red),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  return children;
}
