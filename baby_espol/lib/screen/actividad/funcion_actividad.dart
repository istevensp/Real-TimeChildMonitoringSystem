import 'package:baby_espol/screen/extra/rest_api.dart';
import 'package:baby_espol/datos/activity.dart';
import 'package:image_picker/image_picker.dart';
import 'package:baby_espol/estilo/texto.dart';
import 'package:flutter/material.dart';

void mostraractividad(BuildContext context, List<String> fotos) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("Imagenes"),
        content: SingleChildScrollView(
          child: Container(
            width: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: fotos.asMap().entries.map((entry) {
                int index = entry.key;
                String foto = entry.value;
                return Column(
                  children: [
                    Image.network(foto),
                    if (index < fotos.length - 1) SizedBox(height: 10),
                  ],
                );
              }).toList(),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Cerrar'),
          ),
        ],
      );
    },
  );
}

Future<List<XFile>?> galeria(BuildContext context) async {
  final ImagePicker seleccion = ImagePicker();
  final List<XFile> imagenesSeleccionadas;
  try {
    imagenesSeleccionadas = await seleccion.pickMultiImage();
    return imagenesSeleccionadas;
  } catch (e) {
    print('Error al abrir la galería: $e');
  }
  return [];
}

void nuevactividad(
    void Function(String clase) funcion, BuildContext context, String clase) {
  TextEditingController titulocontroller = TextEditingController();
  List<XFile> imagenescontroller = [];

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
              Text('Nueva Actividad'),
              InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Icon(Icons.close_outlined, size: 25, color: Colors.grey),
              ),
            ],
          ),
          children: [
            rellenar(controlador: titulocontroller, pista: 'Titulo'),
            SizedBox(height: 10),
            InkWell(
              onTap: () async {
                List<XFile>? imagenes = await galeria(context);
                if (imagenes != null && imagenes.isNotEmpty) {
                  imagenescontroller = imagenes;
                }
              },
              child: Row(
                children: [
                  texto('Cargar archivos', Colors.grey, 17, FontWeight.bold),
                  Spacer(),
                  Icon(Icons.cloud_upload, size: 30, color: Colors.black87)
                ],
              ),
            ),
            SizedBox(height: 15),
            ElevatedButton(
              onPressed: () async {
                if (await nuevaActividad(context, titulocontroller.text, clase,
                    imagenescontroller)) {
                  funcion(clase);
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

Future<List<Widget>> lista_actividad_t(void Function(String clase) funcion,
    BuildContext context, bool change, Size screenSize, String clase) async {
  List<activity> lista_actividades = await actividades(context, clase);
  List<Widget> children = [];
  for (activity a in lista_actividades) {
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
                      if (change) {
                        if (await eliminarActividad(context, a.id_act)) {
                          funcion(clase);
                        }
                      } else {
                        List<String> lista_fotos =
                            await fotos(context, a.id_act);
                        mostraractividad(context, lista_fotos);
                      }
                    },
                    child: change
                        ? Icon(Icons.delete, size: 30, color: Colors.red)
                        : Icon(Icons.photo_camera_back_outlined,
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
