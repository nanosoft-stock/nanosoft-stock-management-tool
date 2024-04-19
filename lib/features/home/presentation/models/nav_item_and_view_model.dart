import 'package:flutter/material.dart';
import 'package:stock_management_tool/features/add_new_product/presentation/views/add_new_product_view.dart';
import 'package:stock_management_tool/features/add_new_stock/presentation/views/add_new_stock_view.dart';
import 'package:stock_management_tool/features/home/presentation/models/nav_item_model.dart';
import 'package:stock_management_tool/features/home/presentation/models/nav_item_view.dart';
import 'package:stock_management_tool/features/locate_stock/presentation/views/locate_stock_view.dart';
import 'package:stock_management_tool/features/visualize_stock/presentation/views/visualise_stock_view.dart';
import 'package:stock_management_tool/screens/archive_product_screen.dart';
import 'package:stock_management_tool/screens/archive_stock_screen.dart';
import 'package:stock_management_tool/screens/modify_product_screen.dart';
import 'package:stock_management_tool/screens/modify_stock_screen.dart';

class NavItemAndViewModel {
  static final Map allNavItemAndView = {
    "Add New Stock": NavItemAndView(
      navItem: NavItemModel(
        title: 'Add New Stock',
        icon: Icons.add_box_outlined,
        isSelected: true,
      ),
      view: AddNewStockView(),
    ),
    "Add New Product": NavItemAndView(
      navItem: NavItemModel(
        title: 'Add New Product',
        icon: Icons.add_box_outlined,
      ),
      view: AddNewProductView(),
    ),
    "Visualise Stock": NavItemAndView(
      navItem: NavItemModel(
        title: 'Visualise Stock',
        icon: Icons.table_chart_outlined,
      ),
      view: VisualiseStockView(),
    ),
    "Locate Stock": NavItemAndView(
      navItem: NavItemModel(
        title: 'Locate Stock',
        icon: Icons.my_location_outlined,
      ),
      view: LocateStockView(),
    ),
    "Modify Stock": NavItemAndView(
      navItem: NavItemModel(
        title: 'Modify Stock',
        icon: Icons.edit_note_outlined,
      ),
      view: const ModifyStockScreen(),
    ),
    "Modify Product": NavItemAndView(
      navItem: NavItemModel(
        title: 'Modify Product',
        icon: Icons.edit_note_outlined,
      ),
      view: const ModifyProductScreen(),
    ),
    "Archive Stock": NavItemAndView(
      navItem: NavItemModel(
        title: 'Archive Stock',
        icon: Icons.archive_outlined,
      ),
      view: const ArchiveStockScreen(),
    ),
    "Archive Product": NavItemAndView(
      navItem: NavItemModel(
        title: 'Archive Product',
        icon: Icons.archive_outlined,
      ),
      view: const ArchiveProductScreen(),
    ),
  };

  static final NavItemModel logOutItemMenuNavItem = NavItemModel(
    title: 'Log out',
    icon: Icons.logout,
  );
}
