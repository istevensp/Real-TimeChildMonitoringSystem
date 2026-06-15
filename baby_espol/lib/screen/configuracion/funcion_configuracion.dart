import 'package:baby_espol/screen/extra/rest_api.dart';
import 'package:baby_espol/estilo/texto.dart';
import 'package:baby_espol/datos/child.dart';
import 'package:baby_espol/datos/user.dart';
import 'package:flutter/material.dart';

void informacion(List<child> todos, BuildContext context, user usuario) async {
  child? selectedChild;
  List<child> nino = await ninos(context, usuario.usuario);
  todos.removeWhere(
      (child) => nino.any((ninoChild) => ninoChild.id_nino == child.id_nino));

  // ignore: use_build_context_synchronously
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
                  Text('${usuario.nombre} ${usuario.apellido}'),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Icon(Icons.close_outlined,
                        size: 25, color: Colors.grey),
                  ),
                ],
              ),
              children: [
                Column(
                  children: [
                    for (child c in nino)
                      Row(
                        children: [
                          InkWell(
                            onTap: () async {
                              if (await quitarnino(
                                  context, usuario.usuario, c.id_nino)) {
                                setState(() {
                                  nino.remove(c);
                                });
                              }
                            },
                            child:
                                Icon(Icons.delete, size: 25, color: Colors.red),
                          ),
                          SizedBox(width: 10),
                          texto('${c.nombre} ${c.apellido}', Colors.black, 20.0,
                              FontWeight.bold),
                        ],
                      ),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    InkWell(
                      onTap: () async {
                        if (await agregarnino(
                            context, usuario.usuario, selectedChild!.id_nino)) {
                          print('setstate');
                          setState(() {
                            nino.add(selectedChild!);
                          });
                        }
                      },
                      child: Icon(Icons.save, size: 25, color: Colors.grey),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    DropdownButton<child>(
                      hint: Text('Selecciona un niño'),
                      value: selectedChild,
                      onChanged: (child? newChild) {
                        setState(() {
                          selectedChild = newChild;
                        });
                      },
                      items: todos.map((child c) {
                        return DropdownMenuItem<child>(
                          value: c,
                          child: Text('${c.nombre} ${c.apellido}'),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      );
    },
  );
}

Future<List<Widget>> lista_usuario_c(BuildContext context, Size screenSize,
    String condicion, String principal) async {
  List<user> lista_usuarios = await usuarios(context, condicion);
  List<Widget> children = [];
  for (user u in lista_usuarios) {
    children.add(
      Container(
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: texto_exp('${u.nombre} ${u.apellido}', Colors.black87,
                      25, FontWeight.bold, TextOverflow.ellipsis, 1, true),
                ),
                InkWell(
                  onTap: () async {
                    List<child> todos = await ninos(context, principal);
                    if (todos.length != 0) {
                      informacion(todos, context, u);
                    }
                  },
                  child: Icon(Icons.edit_attributes_outlined,
                      size: 30, color: Colors.black),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
  return children;
}

Future<List<Widget>> lista_usuario_crt(void Function() funcion,
    BuildContext context, user usuario, bool change, Size screenSize) async {
  List<Widget> children = [];

  children.add(
    Row(
      children: [
        Container(
          width: (screenSize.width) - (screenSize.width * 0.7),
          child: texto('Tipo: ', Colors.black87, 20, FontWeight.bold),
        ),
        Container(
          width: (screenSize.width) - (screenSize.width * 0.45),
          child: rellenar_edit(
              controlador:
                  TextEditingController(text: usuario.tipo.toUpperCase()),
              activo: false),
        ),
      ],
    ),
  );

  children.add(
    Row(
      children: [
        Container(
          width: (screenSize.width) - (screenSize.width * 0.7),
          child: texto('Celular: ', Colors.black87, 20, FontWeight.bold),
        ),
        Container(
          width: (screenSize.width) - (screenSize.width * 0.45),
          child: rellenar_edit(
            controlador: TextEditingController(text: usuario.telefono),
            activo: change,
            ingreso_texto: TextInputType.number,
            cambio: (value) {
              if (value != '') {
                usuario.telefono = value;
              }
            },
          ),
        ),
      ],
    ),
  );

  children.add(
    Row(
      children: [
        Container(
          width: (screenSize.width) - (screenSize.width * 0.7),
          child: texto('Contraseña: ', Colors.black87, 20, FontWeight.bold),
        ),
        Container(
          width: (screenSize.width) - (screenSize.width * 0.45),
          child: rellenar_edit(
            controlador: TextEditingController(text: usuario.contrasena),
            activo: change,
            vision: true,
            cambio: (value) {
              if (value != '') {
                usuario.contrasena = value;
              }
            },
          ),
        ),
      ],
    ),
  );

  return children;
}
