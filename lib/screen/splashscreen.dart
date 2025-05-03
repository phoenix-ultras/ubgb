import 'dart:async';

import 'package:flutter/material.dart';

import 'package:ubgb/screen/loginscreen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  double screenwidth = 0;
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
    Future.delayed(
        const Duration(
          seconds: 5,
        ), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    screenwidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
          child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 30),
            child: ClipRRect(
              child: CircleAvatar(
                minRadius: 200,

                backgroundColor: Colors.transparent,
                backgroundImage: AssetImage('assets/images/splash.jpg'),
                foregroundColor: Colors.black,
                // foregroundImage: AssetImage('assets/images/splash.jpg'),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 90, left: 40),
            child: Text(
              'UBGB SC/ST EWC',
              style: TextStyle(color: Colors.white, fontSize: 40),
            ),
          )
        ],
      )),
    );
  }
}
