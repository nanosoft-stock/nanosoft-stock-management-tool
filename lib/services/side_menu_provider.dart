import 'package:flutter/material.dart';
import 'package:flutter_side_menu/flutter_side_menu.dart';
import 'package:stock_management_tool/models/nav_item_model.dart';

class SideMenuProvider extends ChangeNotifier {
  NavItemModel? currentNavItemModel;

  static SideMenuController? sideMenuController = SideMenuController();

  void changeCurrentNavItemModel({
    required NavItemModel? navItemModel,
  }) {
    currentNavItemModel = navItemModel;
    // notifyListeners();
  }

  void toggleSideMenu() {
    sideMenuController?.toggle();
    notifyListeners();
  }

  void refresh() {
    notifyListeners();
  }
}
