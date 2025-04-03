import 'package:acopiatech/constants/colors_palette.dart';
import 'package:acopiatech/constants/images_routes.dart';
import 'package:acopiatech/views/user/user_notification_view.dart';
import 'package:flutter/material.dart';

class UserMenuAppBar extends StatelessWidget implements PreferredSizeWidget {
  const UserMenuAppBar({super.key});

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
              Navigator.pop(context);
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
            icon: Icon(Icons.notifications, color: ColorsPalette.neutralGray),
          ),
        ],
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      elevation: 0.0,
    );
  }
}
