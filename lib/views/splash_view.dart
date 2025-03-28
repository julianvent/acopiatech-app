import 'package:acopiatech/constants/animations_routes.dart';
import 'package:acopiatech/main.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class SplashView extends StatelessWidget {
  const SplashView({super.key});

  get splashView => null;

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: Column(
        children: [
          Center(child: LottieBuilder.asset(AnimationsRoutes.loading)),
        ],
      ),
      nextScreen: const HomePage(),
      splashIconSize: 300,
      backgroundColor: Colors.white,
    );
  }
}