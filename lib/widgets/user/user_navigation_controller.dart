import 'package:acopiatech/views/user/collection/user_collection_view.dart';
import 'package:acopiatech/views/user/home/user_home_view.dart';
import 'package:acopiatech/views/user/user_menu_view.dart';
import 'package:acopiatech/views/user/shop/user_shop_view.dart';
import 'package:get/get.dart';

class UserNavigationController extends GetxController {
  final Rx<int> selectedIndex = 0.obs;

  final views = [
    const UserHomeView(),
    const UserCollectionView(),
    const UserShopView(),
    const UserMenuView(),
  ];

  setView(int index) {
    selectedIndex.value = index;
  }
}
