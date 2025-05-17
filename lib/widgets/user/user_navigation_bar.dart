import 'package:acopiatech/widgets/user/user_menu_app_bar.dart';
import 'package:acopiatech/widgets/user/user_navigation_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserNavigationBar extends StatelessWidget {
  const UserNavigationBar({super.key});

  @override
  Widget build(BuildContext context) {
    final UserNavigationController controller = Get.put(
      UserNavigationController(),
      permanent: false,
    );

    return Scaffold(
      appBar: UserMenuAppBar(controller: controller),
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
