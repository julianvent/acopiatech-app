import 'package:acopiatech/constants/colors_palette.dart';
import 'package:flutter/material.dart';

class CustomAppBar {
  final String title;
  final Icon? icon;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final void Function()? onPressed;

  const CustomAppBar({
    required this.title,
    this.icon,
    this.onPressed,
    this.backgroundColor,
    this.foregroundColor,
  });

  get addAppBar => AppBar(
    title: Text(
      title,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: Colors.black,
      ),
    ),
    actions: [
      Padding(
        padding: EdgeInsets.only(right: 20),
        child: IconButton(
          onPressed: onPressed,
          icon: icon ?? Icon(Icons.add),
          color: ColorsPalette.neutralGray,
          iconSize: 30,
        ),
      ),
    ],
    toolbarHeight: 65.0,
    backgroundColor: backgroundColor ?? Colors.white,
    foregroundColor: foregroundColor,
  );

  get navigatorAppBar => AppBar(
    title: Text(
      title,
      style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
    ),
    backgroundColor: backgroundColor ?? ColorsPalette.neutralGray,
    foregroundColor: foregroundColor ?? Colors.white,
  );
}
