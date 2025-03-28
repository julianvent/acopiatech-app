import 'package:acopiatech/constants/colors_palette.dart';
import 'package:flutter/material.dart';

class WelcomeButtom extends StatelessWidget {
  const WelcomeButtom({super.key, this.buttonText, this.onTapWidget});

  final String? buttonText;
  final Widget? onTapWidget;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (e) => onTapWidget!),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(40),
            bottomLeft: Radius.circular(40),
          ),
        ),
        child: Text(
          buttonText!,
          style: TextStyle(
            color: ColorsPalette.neutralGray,
            fontSize: 14,
            fontWeight: FontWeight.w300,
          ),
        ),
      ),
    );
  }
}
