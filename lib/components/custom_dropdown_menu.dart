import 'package:flutter/material.dart';

class CustomDropDownMenu {
  TextEditingController controller = TextEditingController();

  final onSelected = () {};

  Widget createDropdownMenu({
    required List items,
  }) {
    return DropdownMenu(
      controller: controller,
      textStyle: const TextStyle(
        fontSize: 16.0,
      ),
      inputDecorationTheme: const InputDecorationTheme(
        filled: true,
        border: InputBorder.none,
        fillColor: Color(0xEEE8DEF8),
      ),
      dropdownMenuEntries:
          items.map((e) => DropdownMenuEntry(value: e, label: e)).toList(),
      onSelected: (value) {
        String text;
        if (value == null) {
          text = controller.text;
        } else {
          text = value;
        }
        print(text);
      },
    );
  }
}
