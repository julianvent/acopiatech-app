import 'package:acopiatech/constants/images_routes.dart';
import 'package:flutter/material.dart';

class CustomScaffold extends StatelessWidget {
  const CustomScaffold({
    super.key,
    this.child,
    this.canPop = true,
    this.isNotLogin = true,
  });

  final Widget? child;
  final bool canPop;
  final bool isNotLogin;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0),
        extendBodyBehindAppBar: true,
        body: Stack(
          children: [
            Positioned.fill(
              child: IgnorePointer(
                ignoring: true,
                child: Image(
                  image: AssetImage(ImagesRoutes.fondoBienvenida),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SafeArea(child: child!),
          ],
        ),
    );
  }
}
