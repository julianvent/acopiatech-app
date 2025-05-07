import 'package:acopiatech/views/admin/admin_home_view.dart';
import 'package:acopiatech/views/admin/admin_menu_view.dart';
import 'package:acopiatech/views/admin/admin_shop_view.dart';
import 'package:acopiatech/views/admin/collection/admin_collection_view.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class AdminNavigationController extends GetxController {
  final Rx<int> selectedIndex = 0.obs;

  final views = [
    const AdminHomeView(),
    const AdminCollectionView(),
    const AdminShopView(),
    const AdminMenuView(),
  ];

  setView(int index) {
    selectedIndex.value = index;
  }
}
