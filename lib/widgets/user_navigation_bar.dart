import 'package:acopiatech/views/user/user_home_view.dart';
import 'package:acopiatech/views/user/user_menu_view.dart';
import 'package:acopiatech/views/user/user_recollection_view.dart';
import 'package:acopiatech/views/user/user_shop_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserNavigationBar extends StatelessWidget {
  const UserNavigationBar({super.key});

  @override
  Widget build(BuildContext context) {
    final UserNavigationController controller = Get.put(
      UserNavigationController(),
    );

    return Scaffold(
      bottomNavigationBar: Obx(
        () => NavigationBar(
          height: 80,
          elevation: 0,
          selectedIndex: controller.selectedIndex.value,
          onDestinationSelected:
              (index) => controller.selectedIndex.value = index,
          destinations: [
            NavigationDestination(
              icon: Icon(CupertinoIcons.home, size: 30),
              label: 'Inicio',
            ),
            NavigationDestination(
              icon: Icon(Icons.recycling, size: 30),
              label: 'Recolección',
            ),
            NavigationDestination(
              icon: Icon(Icons.shopping_cart_outlined, size: 30),
              label: 'Tienda',
            ),
            NavigationDestination(
              icon: Icon(Icons.menu, size: 30),
              label: 'Menú',
            ),
          ],
        ),
      ),
      body: Obx(() => controller.views[controller.selectedIndex.value]),
    );
  }
}

class UserNavigationController extends GetxController {
  final Rx<int> selectedIndex = 0.obs;

  final views = [
    const UserHomeView(),
    const UserRecollectionView(),
    const UserShopView(),
    const UserMenuView(),
  ];
}
