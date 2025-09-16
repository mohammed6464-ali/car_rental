import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_application_car_rentil/home_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key, required Null Function() onFinished});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // بعد 3 ثواني يروح لصفحة تانية
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B1430), // كحلي غامق
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // اللوجو صورة عادية
            Image.asset(
              'assets/img/logo1.png',
              width: 220,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 20),
            const Text(
              "FLYING CAR",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                letterSpacing: 4,
                color: Color(0xFF5E97E5), // أزرق فاتح
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// مثال لصفحة تانية
