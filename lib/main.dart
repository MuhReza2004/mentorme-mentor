import 'package:flutter/material.dart';
import 'package:mentormementor/Screen/SplashScreen.dart';
import 'package:mentormementor/Screen/projectForMentor.dart';
import 'package:mentormementor/Screen/register.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const RegisterPage(),
    );
  }
}
