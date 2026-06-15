import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:baby_espol/datos/advertisement.dart';
import 'package:baby_espol/datos/activity.dart';
import 'package:baby_espol/datos/bracelet.dart';
import 'package:image_picker/image_picker.dart';
import 'package:baby_espol/estilo/alerta.dart';
import 'package:baby_espol/datos/mensaje.dart';
import 'package:baby_espol/datos/child.dart';
import 'package:baby_espol/datos/user.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'dart:convert';

final url = 'https://f74d-190-155-148-157.ngrok-free.app';

Future<bool> agregarnino(
    BuildContext context, String usuario, int id_nino) async {
  try {
    final response = await http
        .get(Uri.parse('$url/add_child?usuario=$usuario&id_nino=$id_nino'));
    Map<String, dynamic> datos = {};

    if (response.statusCode == 200) {
      datos = json.decode(response.body);
      if (datos.containsKey('add_child') && datos['add_child'] != null) {
        return true;
      }
    }
  } on Exception catch (_) {
    alerta(
        context,
        Icon(Icons.warning_outlined, color: Colors.yellow, size: 35),
        'Falla de conexion',
        17);
  }
  return false;
}

Future<bool> quitarnino(
    BuildContext context, String usuario, int id_nino) async {
  try {
    final response = await http
        .get(Uri.parse('$url/remove_child?usuario=$usuario&id_nino=$id_nino'));
    Map<String, dynamic> datos = {};

    if (response.statusCode == 200) {
      datos = json.decode(response.body);
      if (datos.containsKey('remove_child') && datos['remove_child'] != null) {
        return true;
      }
    }
  } on Exception catch (_) {
    alerta(
        context,
        Icon(Icons.warning_outlined, color: Colors.yellow, size: 35),
        'Falla de conexion',
        17);
  }
  return false;
}

Future<List<user>> usuarios(BuildContext context, String condicion) async {
  List<user> usuarios = [];
  try {
    final response = await http.get(Uri.parse('$url/user?tipo=$condicion'));
    Map<String, dynamic> datos = {};

    if (response.statusCode == 200) {
      datos = json.decode(response.body);
      if (datos.containsKey('user') && datos['user'] != null) {
        for (int i = 0; i < datos['user'].length; i++) {
          user u = user(
              usuario: datos['user'][i]['usuario'],
              contrasena: datos['user'][i]['contrasena'],
              nombre: datos['user'][i]['nombre'],
              apellido: datos['user'][i]['apellido'],
              correo: datos['user'][i]['correo'],
              telefono: datos['user'][i]['telefono'],
              tipo: datos['user'][i]['tipo']);
          usuarios.add(u);
        }
      }
    }
  } on Exception catch (_) {
    alerta(
        context,
        Icon(Icons.warning_outlined, color: Colors.yellow, size: 35),
        'Falla de conexion',
        17);
  }
  return usuarios;
}

Future<bool> editarUsuario(BuildContext context, String usuario, int telefono,
    String contrasena) async {
  try {
    final response = await http.get(Uri.parse(
        '$url/edit_user?usuario=$usuario&telefono=$telefono&contrasena=$contrasena'));
    Map<String, dynamic> datos = {};

    if (response.statusCode == 200) {
      datos = json.decode(response.body);
      if (datos.containsKey('edit_user') && datos['edit_user'] != null) {
        return true;
      }
    }
  } on Exception catch (_) {
    alerta(
        context,
        Icon(Icons.warning_outlined, color: Colors.yellow, size: 35),
        'Falla de conexion',
        17);
  }
  return false;
}

void llamada(BuildContext context, int id_nino) async {
  try {
    final response = await http.get(Uri.parse('$url/call?id_nino=$id_nino'));
    Map<String, dynamic> datos = {};

    if (response.statusCode == 200) {
      datos = json.decode(response.body);
      if (datos.containsKey('call') && datos['call'] != null) {
        FlutterPhoneDirectCaller.callNumber(datos['call'][0]['telefono']!);
      }
    }
  } on Exception catch (_) {
    alerta(
        context,
        Icon(Icons.warning_outlined, color: Colors.yellow, size: 35),
        'Falla de conexion',
        17);
  }
}

Future<bool> nuevoNino(BuildContext context, String usuario, String nombre,
    String apellido, String clase, int pulsera) async {
  if (nombre == '' || apellido == '' || clase == ' ') {
    alerta(
        context,
        Icon(Icons.warning_outlined, color: Colors.yellow, size: 35),
        'Ingrese todos los campos',
        17);
  } else {
    try {
      final response = await http.get(Uri.parse(
          '$url/new_child?usuario=$usuario&nombre=$nombre&apellido=$apellido&clase=$clase&pulsera=$pulsera'));
      Map<String, dynamic> datos = {};
      if (response.statusCode == 200) {
        datos = json.decode(response.body);
        if (datos.containsKey('new_child')) {
          return true;
        }
      }
    } on Exception catch (_) {
      alerta(
          context,
          Icon(Icons.warning_outlined, color: Colors.yellow, size: 35),
          'Falla de conexion',
          17);
    }
  }
  return false;
}

Future<bool> editarNino(BuildContext context, int id_nino, String nuevo_nombre,
    String nuevo_apellido, String nueva_clase, int nueva_pulsera) async {
  if (nuevo_nombre == '' ||
      nuevo_apellido == '' ||
      nueva_clase == ' ' ||
      nueva_pulsera == '') {
    alerta(
        context,
        Icon(Icons.warning_outlined, color: Colors.yellow, size: 35),
        'Ingrese todos los campos',
        17);
  } else {
    try {
      final response = await http.get(Uri.parse(
          '$url/edit_child?id_nino=$id_nino&nombre=$nuevo_nombre&apellido=$nuevo_apellido&clase=$nueva_clase&pulsera=$nueva_pulsera'));
      Map<String, dynamic> datos = {};
      if (response.statusCode == 200) {
        datos = json.decode(response.body);
        if (datos.containsKey('edit_child')) {
          return true;
        }
      }
    } on Exception catch (_) {
      alerta(
          context,
          Icon(Icons.warning_outlined, color: Colors.yellow, size: 35),
          'Falla de conexion',
          17);
    }
  }
  return false;
}

Future<bool> eliminarNino(BuildContext context, int id_nino) async {
  try {
    final response =
        await http.get(Uri.parse('$url/delete_child?id_nino=$id_nino'));
    Map<String, dynamic> datos = {};
    if (response.statusCode == 200) {
      datos = json.decode(response.body);
      if (datos.containsKey('delete_child')) {
        return true;
      }
    }
  } on Exception catch (_) {
    alerta(
        context,
        Icon(Icons.warning_outlined, color: Colors.yellow, size: 35),
        'Falla de conexion',
        17);
  }
  return false;
}

Future<List<child>> ninos(BuildContext context, String usuario) async {
  List<child> ninos = [];
  try {
    final response = await http.get(Uri.parse('$url/child?usuario=$usuario'));
    Map<String, dynamic> datos = {};

    if (response.statusCode == 200) {
      datos = json.decode(response.body);
      if (datos.containsKey('child') && datos['child'] != null) {
        for (int i = 0; i < datos['child'].length; i++) {
          child c = child(
              datos['child'][i]['id_nino'],
              datos['child'][i]['nombre'],
              datos['child'][i]['apellido'],
              datos['child'][i]['id_pulsera'],
              datos['child'][i]['clase']);
          ninos.add(c);
        }
      }
    }
  } on Exception catch (_) {
    alerta(
        context,
        Icon(Icons.warning_outlined, color: Colors.yellow, size: 35),
        'Falla de conexion',
        17);
  }
  return ninos;
}

Future<bool> eliminarActividad(BuildContext context, int id_actividad) async {
  try {
    final response =
        await http.get(Uri.parse('$url/delete_activity?id_act=$id_actividad'));
    Map<String, dynamic> datos = {};

    if (response.statusCode == 200) {
      datos = json.decode(response.body);
      if (datos.containsKey('delete_activity')) {
        return true;
      }
    }
  } on Exception catch (_) {
    alerta(
        context,
        Icon(Icons.warning_outlined, color: Colors.yellow, size: 35),
        'Falla de conexion',
        17);
  }
  return false;
}

Future<void> nuevaFoto(
    BuildContext context, XFile enlace, int id_act, int numero) async {
  List<int> bytes = await enlace.readAsBytes();
  try {
    await http.post(Uri.parse('$url/new_photo?&id_act=$id_act&numero=$numero'),
        body: bytes);
  } on Exception catch (_) {
    alerta(
        context,
        Icon(Icons.warning_outlined, color: Colors.yellow, size: 35),
        'Falla de conexion',
        17);
  }
}

Future<List<String>> fotos(BuildContext context, int id_actividad) async {
  List<String> fotos = [];
  try {
    final response =
        await http.get(Uri.parse('$url/photo?id_act=$id_actividad'));
    Map<String, dynamic> datos = {};

    if (response.statusCode == 200) {
      datos = json.decode(response.body);
      if (datos.containsKey('photo') && datos['photo'] != null) {
        for (int i = 0; i < datos['photo'].length; i++) {
          fotos.add('https://drive.google.com/uc?export=view&id=' +
              datos['photo'][i]['enlace']);
        }
      }
    }
  } on Exception catch (_) {
    alerta(
        context,
        Icon(Icons.warning_outlined, color: Colors.yellow, size: 35),
        'Falla de conexion',
        17);
  }
  return fotos;
}

Future<bool> nuevaActividad(BuildContext context, String titulo, String clase,
    List<XFile> fotos) async {
  if (titulo == '') {
    alerta(
        context,
        Icon(Icons.warning_outlined, color: Colors.yellow, size: 35),
        'Ingrese los datos',
        17);
  }
  try {
    DateTime now = DateTime.now();
    String dia = "${now.month}/${now.day}";

    final response = await http.get(
        Uri.parse('$url/new_activity?titulo=$titulo&clase=$clase&dia=$dia'));
    Map<String, dynamic> datos = {};

    if (response.statusCode == 200) {
      datos = json.decode(response.body);
      if (datos.containsKey('new_activity')) {
        int i = 1;
        for (XFile enlace in fotos) {
          await nuevaFoto(context, enlace, datos['new_activity'], i);
          i++;
        }
        return true;
      }
    }
  } on Exception catch (_) {
    alerta(
        context,
        Icon(Icons.warning_outlined, color: Colors.yellow, size: 35),
        'Falla de conexion',
        17);
  }
  return false;
}

Future<List<activity>> actividades(BuildContext context, String clase) async {
  List<activity> actividades = [];
  try {
    final response = await http.get(Uri.parse('$url/activity?clase=$clase'));
    Map<String, dynamic> datos = {};

    if (response.statusCode == 200) {
      datos = json.decode(response.body);
      if (datos.containsKey('activity') && datos['activity'] != null) {
        for (int i = 0; i < datos['activity'].length; i++) {
          activity a = activity(
              datos['activity'][i]['id_act'],
              datos['activity'][i]['dia'],
              datos['activity'][i]['titulo'],
              datos['activity'][i]['clase']);
          actividades.add(a);
        }
      }
    }
  } on Exception catch (_) {
    alerta(
        context,
        Icon(Icons.warning_outlined, color: Colors.yellow, size: 35),
        'Falla de conexion',
        17);
  }
  return actividades;
}

Future<List<bracelet>> pulseras(BuildContext context) async {
  List<bracelet> pulseras = [];
  try {
    final response = await http.get(Uri.parse('$url/bracelet'));
    Map<String, dynamic> datos = {};

    if (response.statusCode == 200) {
      datos = json.decode(response.body);
      if (datos.containsKey('bracelet') && datos['bracelet'] != null) {
        for (int i = 0; i < datos['bracelet'].length; i++) {
          bracelet b = bracelet(
              datos['bracelet'][i]['id_pulsera'],
              datos['bracelet'][i]['longitud'],
              datos['bracelet'][i]['latitud'],
              datos['bracelet'][i]['pulso'],
              datos['bracelet'][i]['bateria'],
              datos['bracelet'][i]['peligro']);
          pulseras.add(b);
        }
      }
    }
  } on Exception catch (_) {
    alerta(
        context,
        Icon(Icons.warning_outlined, color: Colors.yellow, size: 35),
        'Falla de conexion',
        17);
  }
  return pulseras;
}

Future<bool> nuevoMensaje(
    BuildContext context, int id_anuncio, String usuario, String texto) async {
  try {
    final response = await http.get(Uri.parse(
        '$url/new_message?id_anuncio=$id_anuncio&usuario=$usuario&mensaje=$texto'));
    Map<String, dynamic> datos = {};
    if (response.statusCode == 200) {
      datos = json.decode(response.body);
      if (datos.containsKey('new_message')) {
        return true;
      }
    }
  } on Exception catch (_) {
    alerta(
        context,
        Icon(Icons.warning_outlined, color: Colors.yellow, size: 35),
        'Falla de conexion',
        17);
  }
  return false;
}

Future<List<message>> mensajes(BuildContext context, int id_anuncio) async {
  List<message> lista_mensaje = [];
  try {
    final response =
        await http.get(Uri.parse('$url/message?id_anuncio=$id_anuncio'));
    Map<String, dynamic> datos = {};

    if (response.statusCode == 200) {
      datos = json.decode(response.body);
      if (datos.containsKey('message') && datos['message'] != null) {
        for (int i = 0; i < datos['message'].length; i++) {
          message m = message(
              datos['message'][i]['usuario'], datos['message'][i]['mensaje']);
          lista_mensaje.add(m);
        }
      }
    }
  } on Exception catch (_) {
    alerta(
        context,
        Icon(Icons.warning_outlined, color: Colors.yellow, size: 35),
        'Falla de conexion',
        17);
  }
  return lista_mensaje;
}

Future<bool> eliminarAnuncio(BuildContext context, int id_anuncio) async {
  try {
    final response = await http
        .get(Uri.parse('$url/delete_advertisement?id_anuncio=$id_anuncio'));
    Map<String, dynamic> datos = {};

    if (response.statusCode == 200) {
      datos = json.decode(response.body);
      if (datos.containsKey('delete_advertisement')) {
        return true;
      }
    }
  } on Exception catch (_) {
    alerta(
        context,
        Icon(Icons.warning_outlined, color: Colors.yellow, size: 35),
        'Falla de conexion',
        17);
  }
  return false;
}

Future<bool> nuevoAnuncio(BuildContext context, String titulo, String clase,
    String usuario, String texto, List<String> lista_clases) async {
  if (titulo == '' || texto == '' || clase == '') {
    alerta(
        context,
        Icon(Icons.warning_outlined, color: Colors.yellow, size: 35),
        'Ingrese todos los campos',
        17);
  } else if (!lista_clases.contains(clase)) {
    alerta(
        context,
        Icon(Icons.warning_outlined, color: Colors.yellow, size: 35),
        'Clase no existe',
        17);
  } else {
    try {
      DateTime now = DateTime.now();
      String dia = "${now.month}/${now.day}";
      final response = await http.get(Uri.parse(
          '$url/new_advertisement?dia=$dia&titulo=$titulo&mensaje=$texto&clase=$clase'));
      Map<String, dynamic> datos = {};

      if (response.statusCode == 200) {
        datos = json.decode(response.body);
        if (datos.containsKey('new_advertisement')) {
          return await nuevoMensaje(
              context, datos['new_advertisement'], usuario, texto);
        }
      }
    } on Exception catch (_) {}
  }
  return false;
}

Future<List<advertisement>> anuncios(
    BuildContext context, List<String> lista_clases) async {
  String parametro = lista_clases.join(',');
  List<advertisement> lista_anuncios = [];
  try {
    final response =
        await http.get(Uri.parse('$url/advertisement?clase=$parametro'));
    Map<String, dynamic> datos = {};

    if (response.statusCode == 200) {
      datos = json.decode(response.body);
      if (datos.containsKey('advertisement') &&
          datos['advertisement'] != null) {
        for (int i = 0; i < datos['advertisement'].length; i++) {
          advertisement anuncio = advertisement(
              datos['advertisement'][i]['id_anuncio'],
              datos['advertisement'][i]['dia'],
              datos['advertisement'][i]['titulo'],
              datos['advertisement'][i]['clase']);
          lista_anuncios.add(anuncio);
        }
      }
    }
  } on Exception catch (_) {
    alerta(
        context,
        Icon(Icons.warning_outlined, color: Colors.yellow, size: 35),
        'Falla de conexion',
        17);
  }
  return lista_anuncios;
}

Future<List<String>> clases(BuildContext context, String usuario) async {
  List<String> clases = [];
  clases.add(' ');
  try {
    final response = await http.get(Uri.parse('$url/class?usuario=$usuario'));
    Map<String, dynamic> datos = {};

    if (response.statusCode == 200) {
      datos = json.decode(response.body);
      if (datos.containsKey('class') && datos['class'] != null) {
        for (int i = 0; i < datos['class'].length; i++) {
          if (!clases.contains(datos['class'][i]['clase'])) {
            clases.add(datos['class'][i]['clase']);
          }
        }
      }
    }
  } on Exception catch (_) {
    alerta(
        context,
        Icon(Icons.warning_outlined, color: Colors.yellow, size: 35),
        'Falla de conexion',
        17);
  }
  return clases;
}

Future<user> recuperarUsuario(BuildContext context, String usuario) async {
  String httpusuario = '';
  String httpcontrasena = '';
  String httpnombre = '';
  String httpapellido = '';
  String httpcorreo = '';
  String httptelefono = '';
  String httptipo = '';

  try {
    final response =
        await http.get(Uri.parse('$url/recuperate?usuario=$usuario'));
    Map<String, dynamic> datos = {};

    if (response.statusCode == 200) {
      datos = json.decode(response.body);
      if (datos.containsKey('recuperate') && datos['recuperate'] != null) {
        httpusuario = datos['recuperate'][0]['usuario'];
        httpcontrasena = datos['recuperate'][0]['contrasena'];
        httpnombre = datos['recuperate'][0]['nombre'];
        httpapellido = datos['recuperate'][0]['apellido'];
        httpcorreo = datos['recuperate'][0]['correo'];
        httptelefono = datos['recuperate'][0]['telefono'];
        httptipo = datos['recuperate'][0]['tipo'];
      } else {
        alerta(
            context,
            Icon(Icons.warning_outlined, color: Colors.yellow, size: 35),
            'Usuario incorrecto',
            17);
      }
    }
  } on Exception catch (_) {
    alerta(
        context,
        Icon(Icons.warning_outlined, color: Colors.yellow, size: 35),
        'Falla de conexion',
        17);
  }
  return user(
      usuario: httpusuario,
      contrasena: httpcontrasena,
      nombre: httpnombre,
      apellido: httpapellido,
      correo: httpcorreo,
      telefono: httptelefono,
      tipo: httptipo);
}

void crearUsuario(
    BuildContext context,
    String usuario,
    String contrasena,
    String nombre,
    String apellido,
    String correo,
    String telefono,
    String tipo) async {
  if (usuario == '' ||
      contrasena == '' ||
      nombre == '' ||
      apellido == '' ||
      correo == '' ||
      telefono == '' ||
      tipo == '') {
    alerta(
        context,
        Icon(Icons.warning_outlined, color: Colors.yellow, size: 35),
        'Ingrese todos los campos',
        17);
  } else {
    try {
      final response = await http.get(Uri.parse(
          '$url/register?usuario=$usuario&contrasena=$contrasena&nombre=$nombre&apellido=$apellido&correo=$correo&telefono=$telefono&tipo=$tipo'));
      Map<String, dynamic> datos = {};
      if (response.statusCode == 200) {
        datos = json.decode(response.body);
        if (datos.containsKey('register')) {
          alerta(context, Icon(Icons.check, color: Colors.green, size: 35),
              'Usuario creado', 17);
        }
      }
    } on Exception catch (_) {
      alerta(
          context,
          Icon(Icons.warning_outlined, color: Colors.yellow, size: 35),
          'Falla de conexion',
          17);
    }
  }
}

Future<user> construirUsuario(
    BuildContext context, String usuario, String contrasena) async {
  String httpusuario = '';
  String httpcontrasena = '';
  String httpnombre = '';
  String httpapellido = '';
  String httpcorreo = '';
  String httptelefono = '';
  String httptipo = '';
  try {
    final response = await http
        .get(Uri.parse('$url/login?usuario=$usuario&contrasena=$contrasena'));
    Map<String, dynamic> datos = {};

    if (response.statusCode == 200) {
      datos = json.decode(response.body);
      if (datos.containsKey('login') && datos['login'] != null) {
        httpusuario = datos['login'][0]['usuario'];
        httpcontrasena = datos['login'][0]['contrasena'];
        httpnombre = datos['login'][0]['nombre'];
        httpapellido = datos['login'][0]['apellido'];
        httpcorreo = datos['login'][0]['correo'];
        httptelefono = datos['login'][0]['telefono'];
        httptipo = datos['login'][0]['tipo'];
      }
    }
  } on Exception catch (_) {
    alerta(
        context,
        Icon(Icons.warning_outlined, color: Colors.yellow, size: 35),
        'Falla de conexion',
        17);
  }
  return user(
      usuario: httpusuario,
      contrasena: httpcontrasena,
      nombre: httpnombre,
      apellido: httpapellido,
      correo: httpcorreo,
      telefono: httptelefono,
      tipo: httptipo);
}
