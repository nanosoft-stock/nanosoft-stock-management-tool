import 'package:flutter/material.dart';

class CustomDropDownMenu extends StatelessWidget {
  const CustomDropDownMenu(
      {super.key, required this.controller,
      required this.items,
      required this.onSelected});

  final TextEditingController controller;
  final List items;
  final onSelected;

  @override
  Widget build(BuildContext context) {
    return DropdownMenu(
      controller: controller,
      width: 200,
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
        onSelected.call();
        print(text);
      },
    );
  }
}
