import 'package:flutter/material.dart';

class NavItemModel {
  NavItemModel({
    required this.title,
    required this.icon,
    this.isSelected = false,
  });

  final String title;
  final IconData icon;
  bool isSelected;
}
