import 'package:baby_espol/screen/intro/recuperate.dart';
import 'package:baby_espol/screen/intro/register.dart';
import 'package:baby_espol/screen/extra/splash.dart';
import 'package:baby_espol/screen/intro/login.dart';
import 'package:flutter/material.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primaryColor: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity),
      initialRoute: '/splash',
      routes: {
        '/splash': (context) => Splash(),
        '/login': (context) => Login(),
        '/register': (context) => Register(),
        '/recuperate': (context) => Recuperate()
      },
    );
  }
}
