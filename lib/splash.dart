import 'package:chatbot/home.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class Splash extends StatelessWidget {
  const Splash({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Chatbot()),
      );
    });
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(child: Lottie.asset('assets/Chatbot Ai animated.json')),
    );
  }
}
