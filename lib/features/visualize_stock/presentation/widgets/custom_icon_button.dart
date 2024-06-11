import 'package:flutter/material.dart';
import 'package:stock_management_tool/core/constants/constants.dart';

class CustomIconButton extends StatelessWidget {
  const CustomIconButton({
    super.key,
    required this.icon,
    this.backgroundColor = Colors.white,
    required this.onTap,
  });

  final Icon icon;
  final Color backgroundColor;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Material(
          elevation: 5,
          borderRadius: BorderRadius.circular(7),
          child: Container(
            height: 27.0,
            width: 27.0,
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(7),
              boxShadow: kBoxShadowList,
            ),
            child: Center(
              child: icon,
            ),
          ),
        ),
      ),
    );
  }
}
