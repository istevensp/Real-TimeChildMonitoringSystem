import 'package:baby_espol/screen/extra/rest_api.dart';
import 'package:baby_espol/estilo/alerta.dart';
import 'package:baby_espol/estilo/boton.dart';
import 'package:baby_espol/estilo/texto.dart';
import 'package:baby_espol/datos/user.dart';
import 'package:flutter/material.dart';

class Recuperate extends StatefulWidget {
  @override
  _RecuperateState createState() => _RecuperateState();
}

class _RecuperateState extends State<Recuperate> {
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController usercontroller = TextEditingController();
  bool active = false;
  late user usuario;

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white70,
        body: SingleChildScrollView(
          child: Container(
            height: (screenSize.height) - (0.1 * screenSize.height),
            padding: EdgeInsets.fromLTRB(32, 32, 32, 32),
            child: Center(
              child: Column(
                children: [
                  SizedBox(height: 75),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      texto('Recupera tu cuenta', Colors.white, 30.0,
                          FontWeight.bold),
                      texto('Ingresa su usuario', Colors.black, 18.0,
                          FontWeight.bold),
                    ],
                  ),
                  SizedBox(height: 25.0),
                  TextField(
                    controller: usercontroller,
                    enabled: !active,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 10.0),
                      hintText: 'Usuario',
                      prefixIcon: Icon(Icons.person_outline),
                      suffixIcon: IconButton(
                        onPressed: () async {
                          if (usercontroller.text == '') {
                            alerta(
                                context,
                                Icon(Icons.warning_outlined,
                                    color: Colors.yellow, size: 35),
                                'Ingrese usuario',
                                17);
                          } else {
                            usuario = await recuperarUsuario(
                                context, usercontroller.text);
                            if (usuario.usuario != '') {
                              setState(() {
                                active = true;
                              });
                            }
                          }
                        },
                        icon: Icon(Icons.send_outlined),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  active
                      ? Container(
                          padding: EdgeInsets.fromLTRB(32, 32, 32, 32),
                          decoration: BoxDecoration(
                            color: Colors.black87,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Column(
                            children: [
                              rellenar(
                                  controlador: emailcontroller,
                                  preficono: Icon(Icons.email_outlined),
                                  pista: 'Correo'),
                              SizedBox(
                                height: 10,
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  if (emailcontroller.text == '') {
                                    alerta(
                                        context,
                                        Icon(Icons.warning_outlined,
                                            color: Colors.yellow, size: 35),
                                        'Ingrese su correo',
                                        17);
                                  } else {
                                    if (usuario.correo ==
                                        emailcontroller.text) {
                                      //Enviar correo
                                    } else {
                                      alerta(
                                          context,
                                          Icon(Icons.warning_outlined,
                                              color: Colors.yellow, size: 35),
                                          'Correo incorrecto',
                                          17);
                                    }
                                  }
                                },
                                style: estilo_boton(
                                  color: Colors.green[300],
                                  estilo_texto: TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold),
                                ),
                                child: Text("RECUPERAR"),
                              ),
                            ],
                          ),
                        )
                      : Container(),
                  SizedBox(
                    height: 10,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pushReplacementNamed('/login');
                    },
                    child: Text(
                      'Recuerdo mi contraseña',
                      style: TextStyle(
                          color: Colors.white,
                          decorationStyle: TextDecorationStyle.solid,
                          fontSize: 15,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
