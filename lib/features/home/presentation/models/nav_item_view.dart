import 'package:flutter/material.dart';
import 'package:stock_management_tool/features/home/presentation/models/nav_item_model.dart';

class NavItemAndView {
  NavItemAndView({
    required this.navItem,
    required this.view,
  });

  final NavItemModel navItem;
  final Widget view;
}
