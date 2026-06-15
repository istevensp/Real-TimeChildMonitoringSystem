import 'package:baby_espol/screen/configuracion/funcion_configuracion.dart';
import 'package:baby_espol/screen/extra/rest_api.dart';
import 'package:baby_espol/estilo/boton.dart';
import 'package:baby_espol/estilo/texto.dart';
import 'package:baby_espol/datos/user.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class Setting_RT extends StatefulWidget {
  final Size screenSize;
  String contrasena;
  String telefono;
  user usuario;

  Setting_RT(
      {required this.contrasena,
      required this.telefono,
      required this.screenSize,
      required this.usuario,
      Key? key})
      : super(key: key);

  @override
  _Setting_RT createState() => _Setting_RT();
}

class _Setting_RT extends State<Setting_RT> {
  List<Widget> listaUsuarios = [];
  bool change = false;

  @override
  void initState() {
    super.initState();
    cargarUsuarios();
  }

  void cargarUsuarios() async {
    List<Widget> usuarios = await lista_usuario_crt(
        cargarUsuarios, context, widget.usuario, change, widget.screenSize);

    setState(() {
      listaUsuarios = usuarios;
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
            texto('Perfil', Colors.white, 30, FontWeight.bold),
            Spacer(),
            InkWell(
              onTap: () async {
                setState(() {
                  change = !change;
                });
                if (!change) {
                  if (await editarUsuario(
                      context,
                      widget.usuario.usuario,
                      int.parse(widget.usuario.telefono),
                      widget.usuario.contrasena)) {
                    cargarUsuarios();
                  }
                } else {
                  widget.usuario.telefono = widget.telefono;
                  widget.usuario.contrasena = widget.contrasena;
                  cargarUsuarios();
                }
              },
              child: Text(
                change ? 'Guardar' : 'Editar',
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
          texto('${widget.usuario.nombre} ${widget.usuario.apellido}',
              Colors.black87, 20, FontWeight.bold),
          SizedBox(height: 5),
          texto(
              '${widget.usuario.correo}', Colors.black87, 18, FontWeight.bold),
          SizedBox(height: 25),
          Container(
            width: widget.screenSize.width,
            padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
            color: const Color.fromARGB(255, 196, 196, 196),
            child: Row(
              children: [
                texto('Configuracion general', Colors.black87, 20,
                    FontWeight.bold),
              ],
            ),
          ),
          SizedBox(height: 25),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  for (Widget usuario in listaUsuarios)
                    Column(
                      children: [usuario, SizedBox(height: 5)],
                    ),
                ],
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pushReplacementNamed('/login');
            },
            style: estilo_boton(
              color: Colors.yellow,
              estilo_texto:
                  TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            child: Text("CERRAR SESION"),
          ),
        ],
      ),
    );
  }
}
