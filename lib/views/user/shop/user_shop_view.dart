import 'package:acopiatech/constants/colors_palette.dart';
import 'package:acopiatech/constants/images_routes.dart';
import 'package:acopiatech/widgets/product_card_builder.dart';
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
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            Container(
              height: 100,
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
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: Column(
                spacing: 20,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    child: Row(
                      spacing: 10,
                      children: [
                        Text(
                          "Nuestros productos",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: ColorsPalette.darkGreen,
                          ),
                        ),
                        Spacer(),
                        IconButton(
                          onPressed: () {},
                          icon: Icon(
                            Icons.shopping_cart_rounded,
                            size: 30,
                            fill: 1.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    child: ProductCardBuilder(
                      imageUrls: [
                        ImagesRoutes.lgP710Optimus,
                        ImagesRoutes.mascota,
                      ],
                    ),
                  ),
                  SizedBox(
                    width: double.maxFinite,
                    child: Text(
                      'Lo más vendido',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: ColorsPalette.darkGreen,
                      ),
                    ),
                  ),
                  SizedBox(
                    child: ProductCardBuilder(
                      imageUrls: [
                        ImagesRoutes.logoAcopiatech,
                        ImagesRoutes.logotipoA,
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
