import 'package:flutter/material.dart';

ButtonStyle estilo_boton({
  Color? color,
  TextStyle? estilo_texto,
}) {
  return ElevatedButton.styleFrom(
    padding: EdgeInsets.fromLTRB(70.0, 15, 70.0, 15),
    backgroundColor: color,
    textStyle: estilo_texto,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(30),
    ),
  );
}
