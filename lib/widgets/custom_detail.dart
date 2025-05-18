import 'package:flutter/material.dart';

class CustomDetail extends StatelessWidget {
  final List<Widget> children;
  final double? spacing;
  final EdgeInsets? padding;
  final CrossAxisAlignment? crossAxisAlignment;
  final BorderRadius? borderRadius;
  const CustomDetail({
    super.key,
    required this.children,
    this.spacing,
    this.crossAxisAlignment,
    this.padding,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: borderRadius,
      ),
      child: Padding(
        padding:
            padding ??
            const EdgeInsets.symmetric(horizontal: 20.0, vertical: 30),
        child: Column(
          crossAxisAlignment: crossAxisAlignment ?? CrossAxisAlignment.start,
          spacing: spacing ?? 15,
          children: children,
        ),
      ),
    );
  }
}
