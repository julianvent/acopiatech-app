import 'package:flutter/material.dart';

class CustomDetail extends StatelessWidget {
  final List<Widget> children;
  final double? spacing;
  const CustomDetail({super.key, required this.children, this.spacing});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      decoration: BoxDecoration(color: Colors.white),
      // ------ Mapa ------
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: spacing ?? 15,
          children: children,
        ),
      ),
    );
  }
}
