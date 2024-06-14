import 'package:flutter/material.dart';
import 'package:stock_management_tool/features/add_new_category/presentation/views/add_new_category_view.dart';
import 'package:stock_management_tool/features/add_new_product/presentation/views/add_new_product_view.dart';
import 'package:stock_management_tool/features/add_new_stock/presentation/views/add_new_stock_view.dart';
import 'package:stock_management_tool/features/home/presentation/models/nav_item_model.dart';
import 'package:stock_management_tool/features/home/presentation/models/nav_item_view.dart';
import 'package:stock_management_tool/features/locate_stock/presentation/views/locate_stock_view.dart';
import 'package:stock_management_tool/features/modify_category/presentation/views/modify_category_view.dart';
import 'package:stock_management_tool/features/modify_product/presentation/views/modify_product_view.dart';
import 'package:stock_management_tool/features/modify_stock/presentation/views/modify_stock_view.dart';
import 'package:stock_management_tool/features/print_id/presentation/views/print_id_view.dart';
import 'package:stock_management_tool/features/visualize_stock/presentation/views/visualise_stock_view.dart';

class NavItemAndViewModel {
  static final Map allNavItemAndView = {
    "Add New Stock": NavItemAndView(
      navItem: NavItemModel(
        title: 'Add New Stock',
        icon: Icons.add_box_outlined,
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
    "Add New Category": NavItemAndView(
      navItem: NavItemModel(
        title: 'Add New Category',
        icon: Icons.add_box_outlined,
      ),
      view: const AddNewCategoryView(),
    ),
    "Visualise Stock": NavItemAndView(
      navItem: NavItemModel(
        title: 'Visualise Stock',
        icon: Icons.table_chart_outlined,
        isSelected: true,
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
      view: const ModifyStockView(),
    ),
    "Modify Product": NavItemAndView(
      navItem: NavItemModel(
        title: 'Modify Product',
        icon: Icons.edit_note_outlined,
      ),
      view: const ModifyProductView(),
    ),
    "Modify Category": NavItemAndView(
      navItem: NavItemModel(
        title: 'Modify Category',
        icon: Icons.edit_note_outlined,
      ),
      view: const ModifyCategoryView(),
    ),
    "Print Id": NavItemAndView(
      navItem: NavItemModel(
        title: 'Print Id',
        icon: Icons.local_printshop_outlined,
      ),
      view: PrintIdView(),
    ),
  };

  static final NavItemModel logOutItemMenuNavItem = NavItemModel(
    title: 'Log out',
    icon: Icons.logout,
  );
}
