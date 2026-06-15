import 'package:baby_espol/screen/localizacion/localization_crt.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:baby_espol/screen/configuracion/settings_rt.dart';
import 'package:baby_espol/screen/configuracion/settings_c.dart';
import 'package:baby_espol/screen/actividad/activity_t.dart';
import 'package:baby_espol/screen/anuncio/anuncio_ct.dart';
import 'package:baby_espol/screen/pulsera/bracelet_c.dart';
import 'package:baby_espol/screen/anuncio/anuncio_r.dart';
import 'package:baby_espol/screen/ninos/child_rt.dart';
import 'package:baby_espol/screen/ninos/child_c.dart';
import 'package:baby_espol/datos/user.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  final List<String> lista_clases;
  final user usuario;

  Home({required this.usuario, required this.lista_clases});
  _Home createState() => _Home();
}

class _Home extends State<Home> {
  int _actual = 0;
  PageController? _controlador;

  @override
  void initState() {
    super.initState();
    _controlador = PageController(initialPage: _actual, keepPage: true);
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    List<Widget> children = [];

    if (widget.usuario.tipo == 'representante') {
      children.add(Anuncio_R(
          screenSize: screenSize,
          usuario: widget.usuario,
          lista_clases: widget.lista_clases));
      children.add(Child_RT(usuario: widget.usuario, screenSize: screenSize));
      children.add(
          Localization_CRT(usuario: widget.usuario, screenSize: screenSize));
      children.add(Setting_RT(
          screenSize: screenSize,
          usuario: widget.usuario,
          telefono: widget.usuario.telefono,
          contrasena: widget.usuario.contrasena));
    } else if (widget.usuario.tipo == 'tutor') {
      children.add(Anuncio_CT(
          screenSize: screenSize,
          usuario: widget.usuario,
          lista_clases: widget.lista_clases));
      children.add(Activity_T(
          screenSize: screenSize,
          usuario: widget.usuario,
          lista_clases: widget.lista_clases));
      children.add(Child_RT(usuario: widget.usuario, screenSize: screenSize));
      children.add(
          Localization_CRT(usuario: widget.usuario, screenSize: screenSize));
      children.add(Setting_RT(
          screenSize: screenSize,
          usuario: widget.usuario,
          telefono: widget.usuario.telefono,
          contrasena: widget.usuario.contrasena));
    } else if (widget.usuario.tipo == 'coordinador') {
      children.add(Anuncio_CT(
          screenSize: screenSize,
          usuario: widget.usuario,
          lista_clases: widget.lista_clases));
      children.add(Bracelet_C(screenSize: screenSize));
      children.add(Child_C(
          usuario: widget.usuario,
          screenSize: screenSize,
          lista_clases: widget.lista_clases));
      children.add(
          Localization_CRT(usuario: widget.usuario, screenSize: screenSize));
      children.add(Setting_C(
          usuario: widget.usuario,
          screenSize: screenSize,
          telefono: widget.usuario.telefono,
          contrasena: widget.usuario.contrasena));
    }

    return Scaffold(
      bottomNavigationBar: _bottomBar(widget.usuario),
      backgroundColor: Colors.white,
      body: PageView(
        controller: _controlador,
        children: children,
        onPageChanged: (int index) {
          setState(() {
            _actual = index;
          });
        },
      ),
    );
  }

  CurvedNavigationBar _bottomBar(user usuario) {
    List<Widget> iconos = [];
    if (usuario.tipo == 'coordinador') {
      iconos.add(Icon(Icons.message_outlined, size: 30, color: Colors.white));
      iconos.add(Icon(Icons.watch, size: 30, color: Colors.white));
      iconos.add(Icon(Icons.child_care, size: 30, color: Colors.white));
      iconos.add(Icon(Icons.map_outlined, size: 30, color: Colors.white));
      iconos.add(Icon(Icons.settings, size: 30, color: Colors.white));
    } else if (usuario.tipo == 'tutor') {
      iconos.add(Icon(Icons.message_outlined, size: 30, color: Colors.white));
      iconos.add(Icon(Icons.checklist_outlined, size: 30, color: Colors.white));
      iconos.add(Icon(Icons.child_care, size: 30, color: Colors.white));
      iconos.add(Icon(Icons.map_outlined, size: 30, color: Colors.white));
      iconos.add(Icon(Icons.settings, size: 30, color: Colors.white));
    } else {
      iconos.add(Icon(Icons.message_outlined, size: 30, color: Colors.white));
      iconos.add(Icon(Icons.child_care, size: 30, color: Colors.white));
      iconos.add(Icon(Icons.map_outlined, size: 30, color: Colors.white));
      iconos.add(Icon(Icons.settings, size: 30, color: Colors.white));
    }
    return CurvedNavigationBar(
      index: _actual,
      color: Color.fromARGB(255, 79, 206, 86),
      backgroundColor: Colors.white,
      animationDuration: const Duration(milliseconds: 300),
      items: iconos,
      onTap: (int index) {
        setState(() {
          _actual = index;
          _controlador!.animateToPage(index,
              duration: const Duration(milliseconds: 300), curve: Curves.ease);
        });
      },
    );
  }
}
