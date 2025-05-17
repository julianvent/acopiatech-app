import 'package:acopiatech/constants/colors_palette.dart';
import 'package:flutter/material.dart';

class CustomHomeButton extends StatelessWidget {
  final String title;
  final void Function()? onPressed;
  const CustomHomeButton({super.key, required this.title, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(horizontal: 70, vertical: 15),
        backgroundColor: ColorsPalette.backgroundDarkGreen,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      ),
      onPressed: onPressed,
      child: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
      ),
    );
  }
}
