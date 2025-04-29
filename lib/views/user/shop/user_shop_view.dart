import 'package:acopiatech/constants/colors_palette.dart';
import 'package:acopiatech/widgets/user/user_text_field.dart';
import 'package:flutter/material.dart';

class UserShopView extends StatefulWidget {
  const UserShopView({super.key});

  @override
  State<UserShopView> createState() => _UserShopViewState();
}

class _UserShopViewState extends State<UserShopView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            height: 150,
            width: double.infinity,
            decoration: const BoxDecoration(
              color: ColorsPalette.backgroundDarkGreen,
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                spacing: 10,
                children: [
                  IconButton(
                    style: IconButton.styleFrom(
                      backgroundColor: ColorsPalette.backgroundDarkGreen,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero,
                        side: const BorderSide(
                          color: ColorsPalette.darkGreen,
                          width: 1.0,
                        ),
                      ),
                    ),
                    onPressed: () {},
                    icon: Icon(
                      Icons.filter_list_alt,
                      fill: 1.0,
                      size: 40,
                      color: ColorsPalette.darkGreen,
                    ),
                  ),
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        filled: true,
                        hintText: 'Buscar productos',
                        hintStyle: TextStyle(color: ColorsPalette.darkGreen),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(0.0),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      style: TextStyle(color: ColorsPalette.darkGreen),
                    ),
                  ),
                  IconButton(
                    style: IconButton.styleFrom(
                      backgroundColor: ColorsPalette.darkCian,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero,
                        side: const BorderSide(
                          color: ColorsPalette.darkCian,
                          width: 1.0,
                        ),
                      ),
                    ),
                    onPressed: () {},
                    icon: Icon(Icons.search, size: 40, color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: Column(
                children: [
                  Container(
                    child: Row(
                      spacing: 10,
                      children: [
                        Text(
                          "Nuestros productos",
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: ColorsPalette.darkGreen,
                          ),
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: Icon(Icons.shopping_cart_rounded),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 200,
                    child: CarouselView(
                      scrollDirection: Axis.horizontal,
                      itemExtent: 200,
                      children: List<Widget>.generate(10, (int index) {
                        return Container(color: ColorsPalette.lightGreen);
                      }),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
