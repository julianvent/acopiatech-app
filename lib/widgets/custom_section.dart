import 'package:acopiatech/constants/colors_palette.dart';
import 'package:flutter/material.dart';

class CustomSection extends StatelessWidget {
  final String title;
  final Color? background;
  final Color? color;
  const CustomSection({
    super.key,
    required this.title,
    this.background,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: background ?? Colors.white,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(12),
          bottomRight: Radius.circular(12),
        ),
      ),
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w700,
          color: color ?? Colors.black,
        ),
      ),
    );
  }
}
