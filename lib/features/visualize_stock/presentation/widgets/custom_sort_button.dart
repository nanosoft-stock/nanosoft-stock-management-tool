import 'package:flutter/material.dart';
import 'package:stock_management_tool/constants/enums.dart';

class CustomSortButton extends StatelessWidget {
  const CustomSortButton({
    super.key,
    required this.field,
    required this.sort,
    required this.onPressed,
  });

  final String field;
  final Sort sort;
  final Function(String, Sort) onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onPressed(field, Sort.values[(Sort.values.indexOf(sort) + 1) % Sort.values.length]);
      },
      child: Builder(
        builder: (BuildContext context) {
          if (sort == Sort.none) {
            return const Icon(Icons.remove_rounded);
          } else if (sort == Sort.asc) {
            return const Icon(Icons.arrow_downward_rounded);
          } else {
            return const Icon(Icons.arrow_upward_rounded);
          }
        },
      ),
    );
  }
}
