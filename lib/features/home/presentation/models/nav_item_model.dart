import 'package:flutter/material.dart';

class NavItemModel {
  NavItemModel({
    required this.index,
    required this.title,
    required this.icon,
    this.isSelected = false,
  });

  final int index;
  final String title;
  final IconData icon;
  bool isSelected;
}
