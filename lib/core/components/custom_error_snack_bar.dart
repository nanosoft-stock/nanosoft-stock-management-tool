import 'package:flutter/material.dart';
import 'package:stock_management_tool/core/constants/constants.dart';

class CustomErrorSnackBar {
  CustomErrorSnackBar({required this.content, required this.margin});

  final Widget content;
  final EdgeInsetsGeometry margin;

  SnackBar build() {
    return SnackBar(
      content: content,
      elevation: 5,
      backgroundColor: kErrorSnackBarColor,
      duration: const Duration(milliseconds: 3000),
      behavior: SnackBarBehavior.floating,
      margin: margin,
      shape: RoundedRectangleBorder(
        borderRadius: kBorderRadius,
      ),
    );
  }
}
