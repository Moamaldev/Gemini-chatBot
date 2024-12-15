import 'package:flutter/material.dart';
import 'package:geminiai/screens/OnbordingScreen.dart';
import 'package:lottie/lottie.dart';

class Splashscreen extends StatelessWidget {
  const Splashscreen({super.key});

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;

    Future.delayed(const Duration(seconds: 5), () {
      Navigator.pushReplacement(
        // ignore: use_build_context_synchronously
        context,
        MaterialPageRoute(builder: (context) => const Onbordingscreen()),
      );
    });

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Padding(
        padding: const EdgeInsets.only(top: 150.0),
        child: Center(
          child: Column(
            children: [
              Lottie.asset('assets/Animation - 1734256924721.json',
                  width: w * 0.5),
              Image.asset(
                'assets/splashscreen.png',
                color: Colors.blueAccent,
                width: w * 0.5,
              )
            ],
          ),
        ),
      ),
    );
  }
}
