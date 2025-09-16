// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:flutter_application_car_rentil/home_page.dart';
import 'package:flutter_application_car_rentil/splach_screen.dart';
import 'package:flutter_application_car_rentil/welcome_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: WelcomePage()
    );
  }
}
