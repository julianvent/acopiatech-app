import 'package:flutter/material.dart';

class CustomCardText extends Text {
  const CustomCardText(super.data, {super.key});

  @override
  Widget build(BuildContext context) {
    return Flexible(child: Text(data!, overflow: TextOverflow.ellipsis));
  }
}
