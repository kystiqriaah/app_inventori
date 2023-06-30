import 'dart:async';

import 'package:app_inventori/view/login.dart';
import 'package:flutter/material.dart';
import 'package:footer/footer.dart';
import 'package:footer/footer_view.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    startScreen();
  }

  void startScreen() {
    var duration = const Duration(seconds: 5);
    Timer(duration, () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) {
          return const Login();
        }),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: FooterView(
        footer: Footer(
          padding: const EdgeInsets.only(bottom: 50),
          backgroundColor: Colors.white,
          child: const Text(
            'Copyright 2023, Kysti Qoriah',
            style: TextStyle(
              fontWeight: FontWeight.w300,
              fontSize: 12.0,
              color: Color(0xFF162A49),
            ),
          ),
        ),
        children: [
          Center(
            child: Container(
              padding: const EdgeInsets.only(top: 200),
              child: Column(
                children: [
                  Center(
                    child: Image.asset(
                      'assets/itg.png',
                      height: 150,
                      fit: BoxFit.contain,
                    ),
                  ),
                  const Text(
                    "Inventori",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
