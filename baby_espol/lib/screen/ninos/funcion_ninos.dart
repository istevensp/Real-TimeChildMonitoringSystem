import 'package:baby_espol/screen/actividad/funcion_actividad.dart';
import 'package:baby_espol/screen/extra/rest_api.dart';
import 'package:baby_espol/datos/activity.dart';
import 'package:baby_espol/datos/bracelet.dart';
import 'package:baby_espol/estilo/texto.dart';
import 'package:baby_espol/datos/child.dart';
import 'package:baby_espol/datos/user.dart';
import 'package:flutter/material.dart';

Future<List<Widget>> lista_actividades(
    BuildContext context, String clase, Size screenSize) async {
  List<activity> actividad = await actividades(context, clase);
  List<Widget> children = [];
  for (activity a in actividad) {
    children.add(
      Container(
        width: screenSize.width,
        padding: EdgeInsets.fromLTRB(5.0, 0.0, 5.0, 0.0),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 5.0),
              decoration: BoxDecoration(
                color: Colors.grey,
              ),
              child: Row(
                children: [
                  texto_exp('${a.dia}: ${a.titulo}', Colors.black87, 18,
                      FontWeight.bold, TextOverflow.ellipsis, 1, true),
                  Spacer(),
                  InkWell(
                    onTap: () async {
                      List<String> lista_fotos = await fotos(context, a.id_act);
                      mostraractividad(context, lista_fotos);
                    },
                    child: Icon(Icons.photo_camera_back_outlined,
                        size: 30, color: Colors.black87),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  return children;
}

Future<List<Widget>> lista_nino_rt(
    BuildContext context, user usuario, Size screenSize) async {
  List<child> lista_ninos = await ninos(context, usuario.usuario);
  List<bracelet> lista_pulseras = await pulseras(context);
  Map<String, List<Widget>> dic = {};
  for (child c in lista_ninos) {
    if (!dic.containsKey(c.clase)) {
      dic[c.clase] = await lista_actividades(context, c.clase, screenSize);
    }
  }

  List<Widget> children1 = [];
  for (bracelet b in lista_pulseras) {
    for (child c in lista_ninos) {
      List<Widget> children2 = [];
      bool click = false;
      if (b.id_pulsera == c.id_pulsera) {
        children1.add(
          StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              children2 = dic[c.clase]!;
              return Container(
                width: screenSize.width,
                decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(10)),
                padding: EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          width: (screenSize.width) - (screenSize.width * 0.3),
                          child: Row(
                            children: [
                              Icon(Icons.brightness_1,
                                  color: b.peligro == '1'
                                      ? Colors.red
                                      : (b.pulso > 0
                                          ? Colors.green
                                          : Colors.grey),
                                  size: 25),
                              SizedBox(width: 10),
                              Expanded(
                                child: texto_exp(
                                    '${c.id_pulsera} : ${c.nombre} ${c.apellido}'
                                        .toUpperCase(),
                                    Colors.black87,
                                    20,
                                    FontWeight.bold,
                                    TextOverflow.ellipsis,
                                    1,
                                    false),
                              ),
                            ],
                          ),
                        ),
                        Spacer(),
                        InkWell(
                          onTap: () async {
                            if (b.peligro != '1') {
                              setState(() {
                                click = !click;
                              });
                            } else {
                              llamada(context, c.id_nino);
                            }
                          },
                          child: b.peligro == '1'
                              ? Icon(Icons.call, size: 25, color: Colors.red)
                              : (click
                                  ? Icon(Icons.arrow_drop_up_outlined,
                                      size: 25, color: Colors.black)
                                  : Icon(Icons.arrow_drop_down_outlined,
                                      size: 25, color: Colors.black)),
                        ),
                      ],
                    ),
                    if (click) ...[
                      ...children2.map((Widget actividad) {
                        return Container(
                          child: Column(
                            children: [SizedBox(height: 15), actividad],
                          ),
                        );
                      }),
                    ],
                  ],
                ),
              );
            },
          ),
        );
      }
    }
  }
  return children1;
}

void nuevonino(void Function() funcion, List<bracelet> pulseras,
    List<String> clases, BuildContext context, user usuario) {
  TextEditingController namecontroller = TextEditingController();
  TextEditingController lastnamecontroller = TextEditingController();
  late String nueva_clase;
  int cuenta_clase = 0;
  late int nueva_pulsera;
  int cuenta_pulsera = 0;

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Container(
        padding: EdgeInsets.fromLTRB(20.0, 32.0, 20.0, 32.0),
        child: SimpleDialog(
          contentPadding: EdgeInsets.fromLTRB(20.0, 32.0, 20.0, 32.0),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Nuevo Niño'),
              InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Icon(Icons.close_outlined, size: 25, color: Colors.grey),
              ),
            ],
          ),
          children: [
            rellenar(controlador: namecontroller, pista: 'Nombre'),
            SizedBox(height: 10),
            rellenar(controlador: lastnamecontroller, pista: 'Apellido'),
            SizedBox(height: 10),
            StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: () {
                              setState(() {
                                if (cuenta_pulsera < pulseras.length - 1) {
                                  cuenta_pulsera++;
                                }
                              });
                            },
                            child:
                                Icon(Icons.add, size: 30, color: Colors.black),
                          ),
                          SizedBox(width: 10),
                          Container(
                            width: (MediaQuery.of(context).size.width) -
                                (MediaQuery.of(context).size.width * 0.8),
                            child: TextFormField(
                              controller: TextEditingController(
                                  text: pulseras[cuenta_pulsera]
                                      .id_pulsera
                                      .toString()),
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
                                if (cuenta_pulsera > 0) {
                                  cuenta_pulsera--;
                                }
                              });
                            },
                            child: Icon(Icons.remove,
                                size: 30, color: Colors.black),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
            SizedBox(height: 10),
            StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () {
                          setState(() {
                            if (cuenta_clase < clases.length - 1) {
                              cuenta_clase++;
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
                          controller:
                              TextEditingController(text: clases[cuenta_clase]),
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
                            if (cuenta_clase > 0) {
                              cuenta_clase--;
                            }
                          });
                        },
                        child:
                            Icon(Icons.remove, size: 30, color: Colors.black),
                      ),
                    ],
                  ),
                );
              },
            ),
            SizedBox(height: 15),
            ElevatedButton(
              onPressed: () async {
                nueva_pulsera = pulseras[cuenta_pulsera].id_pulsera;
                nueva_clase = clases[cuenta_clase];
                if (await nuevoNino(
                    context,
                    usuario.usuario,
                    namecontroller.text,
                    lastnamecontroller.text,
                    nueva_clase,
                    nueva_pulsera)) {
                  funcion();
                  Navigator.pop(context);
                }
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                backgroundColor: Colors.yellow,
              ),
              child: Text('Guardar'),
            ),
          ],
        ),
      );
    },
  );
}

void editarnino(void Function() funcion, List<bracelet> pulseras,
    List<String> clases, BuildContext context, child nino) {
  String nuevo_nombre = nino.nombre;
  String nuevo_apellido = nino.apellido;
  late String nueva_clase;
  int cuenta_clase = 0;
  for (int i = 0; i < clases.length; i++) {
    if (clases[i] == nino.clase) {
      cuenta_clase = i;
    }
  }
  late int nueva_pulsera;
  int cuenta_pulsera = 0;
  for (int i = 0; i < pulseras.length; i++) {
    if (pulseras[i].id_pulsera == nino.id_pulsera) {
      cuenta_pulsera = i;
    }
  }

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Container(
        padding: EdgeInsets.fromLTRB(20.0, 32.0, 20.0, 32.0),
        child: SimpleDialog(
          contentPadding: EdgeInsets.fromLTRB(20.0, 32.0, 20.0, 32.0),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('${nino.nombre} ${nino.apellido}'),
              InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Icon(Icons.close_outlined, size: 25, color: Colors.grey),
              ),
            ],
          ),
          children: [
            rellenar_edit(
              controlador: TextEditingController(text: nino.nombre),
              cambio: (value) {
                nuevo_nombre = value;
              },
            ),
            SizedBox(height: 10),
            rellenar_edit(
              controlador: TextEditingController(text: nino.apellido),
              cambio: (value) {
                nuevo_apellido = value;
              },
            ),
            SizedBox(height: 10),
            StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: () {
                              setState(() {
                                if (cuenta_pulsera < pulseras.length - 1) {
                                  cuenta_pulsera++;
                                }
                              });
                            },
                            child:
                                Icon(Icons.add, size: 30, color: Colors.black),
                          ),
                          SizedBox(width: 10),
                          Container(
                            width: (MediaQuery.of(context).size.width) -
                                (MediaQuery.of(context).size.width * 0.8),
                            child: TextFormField(
                              controller: TextEditingController(
                                  text: pulseras[cuenta_pulsera]
                                      .id_pulsera
                                      .toString()),
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
                                if (cuenta_pulsera > 0) {
                                  cuenta_pulsera--;
                                }
                              });
                            },
                            child: Icon(Icons.remove,
                                size: 30, color: Colors.black),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
            SizedBox(height: 10),
            StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () {
                          setState(() {
                            if (cuenta_clase < clases.length - 1) {
                              cuenta_clase++;
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
                          controller:
                              TextEditingController(text: clases[cuenta_clase]),
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
                            if (cuenta_clase > 0) {
                              cuenta_clase--;
                            }
                          });
                        },
                        child:
                            Icon(Icons.remove, size: 30, color: Colors.black),
                      ),
                    ],
                  ),
                );
              },
            ),
            SizedBox(height: 15),
            ElevatedButton(
              onPressed: () async {
                nueva_pulsera = pulseras[cuenta_pulsera].id_pulsera;
                nueva_clase = clases[cuenta_clase];
                if (await editarNino(context, nino.id_nino, nuevo_nombre,
                    nuevo_apellido, nueva_clase, nueva_pulsera)) {
                  funcion();
                  Navigator.pop(context);
                }
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                backgroundColor: Colors.yellow,
              ),
              child: Text('Guardar'),
            ),
          ],
        ),
      );
    },
  );
}

Future<List<Widget>> lista_nino_c(
    void Function() funcion,
    List<String> lista_clases,
    BuildContext context,
    user usuario,
    Size screenSize,
    bool change) async {
  List<child> lista_ninos = await ninos(context, usuario.usuario);
  List<bracelet> lista_pulseras = await pulseras(context);
  List<Widget> children = [];
  for (bracelet b in lista_pulseras) {
    for (child c in lista_ninos) {
      if (b.id_pulsera == c.id_pulsera) {
        children.add(
          Container(
            width: screenSize.width,
            decoration: BoxDecoration(
                color: Colors.grey, borderRadius: BorderRadius.circular(10)),
            padding: EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      width: (screenSize.width) - (screenSize.width * 0.3),
                      child: Row(
                        children: [
                          Icon(Icons.brightness_1,
                              color: b.peligro == '1'
                                  ? Colors.red
                                  : (b.pulso > 0 ? Colors.green : Colors.grey),
                              size: 25),
                          SizedBox(width: 10),
                          Expanded(
                            child: texto_exp(
                                '${c.id_pulsera} : ${c.nombre} ${c.apellido}'
                                    .toUpperCase(),
                                Colors.black87,
                                20,
                                FontWeight.bold,
                                TextOverflow.ellipsis,
                                1,
                                false),
                          ),
                        ],
                      ),
                    ),
                    Spacer(),
                    InkWell(
                      onTap: () async {
                        if (change) {
                          if (await eliminarNino(context, c.id_nino)) {
                            funcion();
                          }
                        } else {
                          editarnino(funcion, lista_pulseras, lista_clases,
                              context, c);
                        }
                      },
                      child: change
                          ? Icon(Icons.delete, size: 25, color: Colors.red)
                          : Icon(Icons.edit, size: 25, color: Colors.black),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      }
    }
  }
  return children;
}
