import 'package:flutter/material.dart';

void alerta(BuildContext context, Icon icono, String texto, double tamano) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Center(
          child: Row(
            children: [
              icono,
              Spacer(),
              Text(texto, style: TextStyle(fontSize: tamano)),
            ],
          ),
        ),
      );
    },
  );
}
