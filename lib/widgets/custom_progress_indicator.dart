import 'package:flutter/material.dart';

class CustomProgressIndicator extends StatelessWidget {
  final String loadingText;
  final double spacing;
  const CustomProgressIndicator({
    super.key,
    required this.loadingText,
    required this.spacing,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: spacing,
        children: [Text(loadingText), CircularProgressIndicator()],
      ),
    );
  }
}
