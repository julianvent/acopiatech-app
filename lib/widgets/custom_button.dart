import 'package:acopiatech/constants/colors_palette.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String title;
  final Icon? icon;
  final Color? backgroundColor;
  final void Function()? onPressed;
  const CustomButton({
    super.key,
    required this.title,
    this.onPressed,
    this.icon,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(horizontal: 70, vertical: 15),
        backgroundColor: backgroundColor ?? ColorsPalette.backgroundDarkGreen,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        foregroundColor: Colors.white,
      ),
      onPressed: onPressed,
      label: Text(
        title,
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
      ),
      icon: icon,
    );
  }
}
