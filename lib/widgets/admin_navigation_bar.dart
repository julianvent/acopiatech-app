import 'package:acopiatech/constants/images_routes.dart';
import 'package:acopiatech/views/admin/admin_account_view.dart';
import 'package:acopiatech/views/admin/admin_home_view.dart';
import 'package:acopiatech/views/admin/admin_recollection_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AdminNavigationBar extends StatelessWidget {
  const AdminNavigationBar({super.key});

  @override
  Widget build(BuildContext context) {
    final NavigationController controller = Get.put(NavigationController());

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
              icon: Icon(Icons.person, size: 30),
              label: 'Cuenta',
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

class NavigationController extends GetxController {
  final Rx<int> selectedIndex = 0.obs;

  final views = [
    const AdminHomeView(),
    const AdminRecollectionView(),
    const AdminAccountView(),
    Container(color: Colors.greenAccent),
  ];
}
