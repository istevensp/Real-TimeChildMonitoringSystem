import 'package:baby_espol/screen/extra/rest_api.dart';
import 'package:baby_espol/screen/extra/home.dart';
import 'package:baby_espol/estilo/alerta.dart';
import 'package:baby_espol/estilo/boton.dart';
import 'package:baby_espol/estilo/texto.dart';
import 'package:baby_espol/datos/user.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController passwordcontroller = TextEditingController();
  TextEditingController usercontroller = TextEditingController();
  bool? visioncontroller = true;
  List<String> lista_clases = [];
  bool loading = false;

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
                  SizedBox(height: 75.0),
                  texto('BIENVENIDO', Colors.white, 30.0, FontWeight.bold),
                  SizedBox(height: 25.0),
                  rellenar(
                      controlador: usercontroller,
                      preficono: Icon(Icons.person_outline),
                      pista: 'Usuario'),
                  SizedBox(height: 15.0),
                  TextFormField(
                    controller: passwordcontroller,
                    obscureText: visioncontroller!,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 10.0,
                        horizontal: 10.0,
                      ),
                      prefixIcon: Icon(Icons.lock_outline_rounded),
                      suffixIcon: InkWell(
                        onTap: () {
                          setState(() {
                            visioncontroller = !visioncontroller!;
                          });
                        },
                        child: Icon(
                            visioncontroller!
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: Colors.grey),
                      ),
                      hintText: 'Contraseña',
                    ),
                  ),
                  SizedBox(height: 5.0),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pushReplacementNamed('/recuperate');
                    },
                    child: texto('¿Olvidaste tu contraseña?', Colors.black, 15,
                        FontWeight.bold,
                        estiloDeco: TextDecorationStyle.solid),
                  ),
                  SizedBox(height: 80),
                  ElevatedButton(
                    onPressed: () async {
                      setState(() {
                        loading = true;
                      });
                      user usuario = await construirUsuario(context,
                          usercontroller.text, passwordcontroller.text);
                      if (usuario.usuario != '') {
                        lista_clases = await clases(context, usuario.usuario);
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Home(
                                usuario: usuario, lista_clases: lista_clases),
                          ),
                        );
                      } else {
                        alerta(
                            context,
                            Icon(Icons.error, color: Colors.red, size: 35),
                            'Credenciales incorrectas',
                            17);
                        setState(() {
                          loading = false;
                        });
                      }
                    },
                    style: estilo_boton(
                      color: Colors.green[300],
                      estilo_texto: TextStyle(
                          fontSize: 18.0, fontWeight: FontWeight.bold),
                    ),
                    child: loading
                        ? CircularProgressIndicator()
                        : Text("INICIAR SESIÓN"),
                  ),
                  Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      texto('¿No tienes una cuenta?', Colors.black, 15,
                          FontWeight.bold),
                      InkWell(
                        onTap: () {
                          Navigator.of(context)
                              .pushReplacementNamed('/register');
                        },
                        child: texto(
                            'Registrate', Colors.white, 15, FontWeight.bold,
                            estiloDeco: TextDecorationStyle.solid),
                      )
                    ],
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
