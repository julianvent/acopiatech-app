import 'package:acopiatech/views/user/collection/user_collection_view.dart';
import 'package:acopiatech/views/user/home/user_home_view.dart';
import 'package:acopiatech/views/user/user_menu_view.dart';
import 'package:acopiatech/views/user/user_shop_view.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

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
