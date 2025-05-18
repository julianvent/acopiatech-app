import 'package:acopiatech/constants/colors_palette.dart';
import 'package:flutter/material.dart';

class CustomAppBar {
  final String title;
  final Icon? icon;
  final void Function()? onPressed;
  const CustomAppBar({required this.title, this.icon, this.onPressed});

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
    backgroundColor: Colors.white,
  );

  get navigatorAppBar => AppBar(
    title: Text(
      title,
      style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
    ),
    backgroundColor: ColorsPalette.neutralGray,
    foregroundColor: Colors.white,
  );
}
