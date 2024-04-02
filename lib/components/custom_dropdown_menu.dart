import 'package:flutter/material.dart';
import 'package:stock_management_tool/constants/constants.dart';

class CustomDropdownMenu extends StatelessWidget {
  const CustomDropdownMenu({
    super.key,
    required this.controller,
    required this.items,
    required this.onSelected,
  });

  final TextEditingController controller;
  final List items;
  final void Function() onSelected;

  @override
  Widget build(BuildContext context) {
    return DropdownMenu(
      controller: controller,
      width: 200,
      textStyle: kLabelTextStyle,
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: kBorderRadius,
        ),
        fillColor: kInputFieldFillColor,
      ),
      dropdownMenuEntries: items
          .map(
            (e) => DropdownMenuEntry(
              value: e,
              label: e,
              style: ButtonStyle(
                textStyle: MaterialStateProperty.all<TextStyle>(
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
        onSelected.call();
      },
    );
  }
}
