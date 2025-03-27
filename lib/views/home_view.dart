import 'package:acopiatech/constants/colors_palette.dart';
import 'package:acopiatech/constants/images_routes.dart';
import 'package:acopiatech/views/shop_view.dart';
import 'package:flutter/material.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';


class HomeView extends StatefulWidget {
  int _recolectionRequest = 0;
  HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int _bottomNavIndex = 0;
  // List<Widget> _pages = const [
  //   HomeView(),
  //   MyShopView()

  // ];

  Widget _handleRecolectionRequest() {
    if (widget._recolectionRequest == 0) {
      widget._recolectionRequest = 1;
      return Padding(
        padding: EdgeInsets.all(20),
        child: Container(
          width: 600,
          height: 150,
          alignment: Alignment.center,
          margin: EdgeInsets.only(top: 50),
          decoration: BoxDecoration(
            color: ColorsPalette.backgroundDarkGreen,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: [
              SizedBox(height: 20),
              Text(
                'No cuentas con recolecciones\n¡Solicita una ahora!',
                style: TextStyle(color: Colors.white, fontSize: 18),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorsPalette.lightGreen,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  alignment: Alignment.center,
                  fixedSize: Size(200, 50),
                ),

                label: Row(
                  children: [
                    Text(
                      'Solicitar recolección ',
                      style: TextStyle(color: Colors.white),
                    ),
                    Icon(Icons.add, color: ColorsPalette.darkGreen),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      return SizedBox(
        child: Container(
          child: Column(
            children: [
              Text(
                'En mantenimiento',
                style: TextStyle(color: Colors.black, fontSize: 20),
              ),
            ],
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.asset(
              ImagesRoutes.logoAcopiatech,
              fit: BoxFit.contain,
              height: 50,
            ),
            Icon(Icons.notifications, color: ColorsPalette.neutralGray),
          ],
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          _handleRecolectionRequest(),
          AnimatedBottomNavigationBar(
            splashColor: ColorsPalette.hardGreen,
            activeColor: ColorsPalette.darkGreen,
            inactiveColor: ColorsPalette.neutralGray, // Colors.black.withOpacity(0.5)
            icons: [
              Icons.home,
              Icons.shopping_cart,
              Icons.person,
              Icons.settings_outlined,
            ],
            activeIndex: 0,
            gapLocation: GapLocation.center,
            notchSmoothness: NotchSmoothness.softEdge,
            onTap: (index) {
              setState(() {
                
              });
            },
          )
        ]),
      ),
    );
  }
}
