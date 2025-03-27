import 'package:acopiatech/constants/colors_palette.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyShopView());
}

class MyShopView extends StatelessWidget {
  const MyShopView({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: ColorsPalette.darkGreen),
      ),
      home: const ShopView(title: 'Shop_view'),
    );
  }
}

class ShopView extends StatefulWidget {
  const ShopView({super.key, required this.title});

  final String title;

  @override
  State<ShopView> createState() => _ShopViewState();
}

class _ShopViewState extends State<ShopView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: const Center(child: Text('Hola Jules')));
  }
}
