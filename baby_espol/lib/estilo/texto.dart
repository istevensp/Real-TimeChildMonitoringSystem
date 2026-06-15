import 'package:flutter/material.dart';

Widget texto(String texto, Color color, double tamano, FontWeight estilo,
    {TextDecorationStyle? estiloDeco}) {
  return Text(
    texto,
    style: TextStyle(
      color: color,
      fontSize: tamano,
      fontWeight: estilo,
      decorationStyle: estiloDeco ?? TextDecorationStyle.solid,
    ),
  );
}

Widget texto_exp(String texto, Color color, double tamano, FontWeight estilo,
    TextOverflow exceso, int maximo, bool vF) {
  return Text(
    texto,
    style: TextStyle(
      color: color,
      fontSize: tamano,
      fontWeight: estilo,
    ),
    overflow: exceso,
    maxLines: maximo,
    softWrap: vF,
  );
}

Widget rellenar({
  TextEditingController? controlador,
  Icon? preficono,
  String? pista,
  TextInputType? ingreso_texto,
  bool? activo,
}) {
  return TextFormField(
    controller: controlador,
    enabled: activo ?? true,
    keyboardType: ingreso_texto ?? TextInputType.text,
    decoration: InputDecoration(
      contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.white),
        borderRadius: BorderRadius.circular(10.0),
      ),
      prefixIcon: preficono,
      hintText: pista,
    ),
  );
}

Widget rellenar_edit({
  TextEditingController? controlador,
  void Function(String)? cambio,
  TextInputType? ingreso_texto,
  bool? activo,
  bool? vision,
}) {
  return TextFormField(
    onChanged: cambio,
    controller: controlador,
    enabled: activo ?? true,
    obscureText: vision ?? false,
    keyboardType: ingreso_texto ?? TextInputType.text,
    decoration: InputDecoration(
      contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.white),
        borderRadius: BorderRadius.circular(10.0),
      ),
    ),
  );
}
