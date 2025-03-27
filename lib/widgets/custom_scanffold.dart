import 'package:acopiatech/constants/images_routes.dart';
import 'package:flutter/material.dart';

class CustomScanffold extends StatelessWidget {
  const CustomScanffold({super.key, this.child});

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          Image(
            image: AssetImage(ImagesRoutes.fondoBienvenida),
            fit: BoxFit.cover,
            height: double.infinity,
            width: double.infinity,
          ),
          SafeArea(
            child: child!,
          )
        ],
      ),
    );
  }
}