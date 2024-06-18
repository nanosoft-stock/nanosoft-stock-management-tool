import 'package:flutter/material.dart';
import 'package:stock_management_tool/core/constants/constants.dart';

class CustomDropdownMenu extends StatelessWidget {
  const CustomDropdownMenu({
    super.key,
    required this.controller,
    required this.items,
    this.requestFocusOnTap = true,
    required this.onSelected,
  });

  final TextEditingController controller;
  final List items;
  final bool requestFocusOnTap;
  final void Function(String) onSelected;

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: kBorderRadius,
      child: DropdownMenu(
        controller: controller,
        width: 200,
        menuHeight: 200,
        textStyle: kLabelTextStyle,
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: kBorderRadius,
          ),
          fillColor: kInputFieldFillColor,
        ),
        requestFocusOnTap: requestFocusOnTap,
        dropdownMenuEntries: items
            .map(
              (e) => DropdownMenuEntry(
                value: e,
                label: e,
                style: ButtonStyle(
                  textStyle: WidgetStateProperty.all<TextStyle>(
                    kLabelTextStyle,
                  ),
                ),
              ),
            )
            .toList(),
        onSelected: (value) {
          String text;
          if (value == null) {
            text = controller.text;
          } else {
            text = value;
          }
          controller.text = text;
          onSelected(controller.text);
        },
      ),
    );
  }
}