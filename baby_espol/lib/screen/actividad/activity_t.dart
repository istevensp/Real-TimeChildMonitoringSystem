import 'package:baby_espol/screen/actividad/funcion_actividad.dart';
import 'package:baby_espol/estilo/texto.dart';
import 'package:baby_espol/datos/user.dart';
import 'package:flutter/material.dart';

class Activity_T extends StatefulWidget {
  final List<String> lista_clases;
  final Size screenSize;
  final user usuario;

  Activity_T(
      {required this.lista_clases,
      required this.screenSize,
      required this.usuario,
      Key? key})
      : super(key: key);

  @override
  _Activity_T createState() => _Activity_T();
}

class _Activity_T extends State<Activity_T> {
  List<Widget> listaActividades = [];
  bool change = false;
  String clase = ' ';

  @override
  void initState() {
    super.initState();
    cargarActividades(clase);
  }

  void cargarActividades(String curso) async {
    List<Widget> actividades = await lista_actividad_t(
        cargarActividades, context, change, widget.screenSize, clase);

    setState(() {
      listaActividades = actividades;
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
            texto('Actividades', Colors.white, 30, FontWeight.bold),
            Spacer(),
            InkWell(
              onTap: () {
                setState(() {
                  change = !change;
                  cargarActividades(clase);
                });
              },
              child: Text(
                change ? 'Listo' : 'Eliminar',
                style: TextStyle(
                  color: Colors.black87,
                  decorationStyle: TextDecorationStyle.solid,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
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
          DropdownButtonFormField(
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              contentPadding:
                  EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
              border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            isDense: true,
            isExpanded: true,
            value: clase,
            hint: Text('Seleccione una clase'),
            items: widget.lista_clases.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                clase = newValue!;
                cargarActividades(clase);
              });
            },
          ),
          SizedBox(height: 15),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  for (Widget actividad in listaActividades)
                    Column(
                      children: [actividad, SizedBox(height: 15)],
                    ),
                ],
              ),
            ),
          ),
          Visibility(
            visible: clase != ' ',
            child: ElevatedButton(
              onPressed: () async {
                nuevactividad(cargarActividades, context, clase);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.yellow,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: Icon(Icons.add),
            ),
          )
        ],
      ),
    );
  }
}
