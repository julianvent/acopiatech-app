import 'package:acopiatech/constants/colors_palette.dart';
import 'package:acopiatech/constants/images_routes.dart';
import 'package:acopiatech/views/user/user_notification_view.dart';
import 'package:acopiatech/widgets/user/user_navigation_controller.dart';
import 'package:flutter/material.dart';

class UserMenuAppBar extends StatelessWidget implements PreferredSizeWidget {
  final UserNavigationController controller;
  const UserMenuAppBar({super.key, required this.controller});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () {
              controller.selectedIndex.value = 0;
              PageController pageController = PageController();
              pageController.jumpToPage(0);
            },
            icon: Image.asset(
              ImagesRoutes.logoAcopiatech,
              height: 50,
              fit: BoxFit.contain,
            ),
            style: ButtonStyle(
              minimumSize: WidgetStatePropertyAll(const Size(100, 50)),
            ),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const UserNotificationView(),
                ),
              );
            },
            icon: Icon(Icons.notifications, color: Colors.white),
          ),
        ],
      ),
      backgroundColor: ColorsPalette.neutralGray,
      elevation: 0.0,
    );
  }
}
