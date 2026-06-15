import 'package:baby_espol/screen/extra/rest_api.dart';
import 'package:baby_espol/estilo/alerta.dart';
import 'package:baby_espol/estilo/boton.dart';
import 'package:baby_espol/estilo/texto.dart';
import 'package:flutter/material.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  TextEditingController confirmpasswordcontroller = TextEditingController();
  TextEditingController lastnamecontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController phonecontroller = TextEditingController();
  TextEditingController namecontroller = TextEditingController();
  TextEditingController usercontroller = TextEditingController();
  bool? visioncontroller1 = true;
  bool? visioncontroller2 = true;
  String? typecontroller;

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white70,
        body: StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return SingleChildScrollView(
              child: Container(
                height: (screenSize.height) - (0.1 * screenSize.height),
                padding: EdgeInsets.fromLTRB(32, 32, 32, 32),
                child: Center(
                  child: Column(
                    children: [
                      SizedBox(height: 75.0),
                      texto('Crea una cuenta', Colors.white, 30.0,
                          FontWeight.bold),
                      texto('Es rapido y fácil', Colors.black, 15.0,
                          FontWeight.bold),
                      SizedBox(height: 25.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: rellenar(
                                controlador: namecontroller,
                                preficono: Icon(Icons.edit_outlined),
                                pista: 'Nombre'),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: rellenar(
                                controlador: lastnamecontroller,
                                preficono: Icon(Icons.edit_outlined),
                                pista: 'Apellido'),
                          ),
                        ],
                      ),
                      SizedBox(height: 10.0),
                      rellenar(
                          controlador: usercontroller,
                          preficono: Icon(Icons.person_outline),
                          pista: 'Usuario'),
                      SizedBox(height: 10.0),
                      rellenar(
                          controlador: emailcontroller,
                          preficono: Icon(Icons.email_outlined),
                          pista: 'Correo electronico'),
                      SizedBox(height: 10.0),
                      TextFormField(
                        controller: passwordcontroller,
                        obscureText: visioncontroller1!,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 10.0),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          prefixIcon: Icon(Icons.lock_outline_rounded),
                          suffixIcon: InkWell(
                            onTap: () {
                              setState(() {
                                visioncontroller1 = !visioncontroller1!;
                              });
                            },
                            child: Icon(
                                visioncontroller1!
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: Colors.grey),
                          ),
                          hintText: 'Contraseña',
                        ),
                      ),
                      SizedBox(height: 10.0),
                      TextFormField(
                        controller: confirmpasswordcontroller,
                        obscureText: visioncontroller2!,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 10.0),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          prefixIcon: Icon(Icons.lock_outline_rounded),
                          suffixIcon: InkWell(
                            onTap: () {
                              setState(() {
                                visioncontroller2 = !visioncontroller2!;
                              });
                            },
                            child: Icon(
                                visioncontroller2!
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: Colors.grey),
                          ),
                          hintText: 'Confirmar contraseña',
                        ),
                      ),
                      SizedBox(height: 10.0),
                      rellenar(
                          controlador: phonecontroller,
                          preficono: Icon(Icons.call_outlined),
                          pista: 'Celular',
                          ingreso_texto: TextInputType.number),
                      SizedBox(height: 10.0),
                      DropdownButtonFormField(
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.group_outlined),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 10.0),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        isDense: true,
                        isExpanded: true,
                        value: typecontroller,
                        hint: Text('Selecciona un rol'),
                        items: <String>['Representante', 'Coordinador', 'Tutor']
                            .map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            typecontroller = newValue;
                          });
                        },
                      ),
                      SizedBox(height: 10.0),
                      ElevatedButton(
                        onPressed: () {
                          if (passwordcontroller.text !=
                              confirmpasswordcontroller.text) {
                            alerta(
                                context,
                                Icon(Icons.warning_outlined,
                                    color: Colors.yellow, size: 35),
                                'Contraseña no coincide',
                                17);
                          } else {
                            crearUsuario(
                                context,
                                usercontroller.text,
                                passwordcontroller.text,
                                namecontroller.text,
                                lastnamecontroller.text,
                                emailcontroller.text,
                                phonecontroller.text,
                                typecontroller!);
                          }
                        },
                        style: estilo_boton(
                          color: Colors.green[300],
                          estilo_texto: TextStyle(
                              fontSize: 18.0, fontWeight: FontWeight.bold),
                        ),
                        child: Text("REGISTRARTE"),
                      ),
                      SizedBox(height: 10.0),
                      InkWell(
                        onTap: () {
                          Navigator.of(context).pushReplacementNamed('/login');
                        },
                        child: texto('¿Ya tienes una cuenta?', Colors.white,
                            15.0, FontWeight.bold,
                            estiloDeco: TextDecorationStyle.solid),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
