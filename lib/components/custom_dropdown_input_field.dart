import 'package:flutter/material.dart';
import 'package:stock_management_tool/constants/constants.dart';
import 'package:stock_management_tool/helper/string_casting_extension.dart';

class CustomDropdownInputField extends StatelessWidget {
  CustomDropdownInputField({
    super.key,
    required this.text,
    required this.controller,
    required this.items,
    required this.onSelected,
  });

  String text;
  TextEditingController controller;
  List items;
  final onSelected;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: InkWell(
        onFocusChange: (hasFocus) {
          if (!hasFocus) {
            onSelected.call();
          }
        },
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: kBorderRadius,
              color: kTertiaryBackgroundColor,
              boxShadow: kBoxShadowList,
            ),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 2.5),
                    child: SizedBox(
                      width: 100,
                      child: Text(
                        text.toTitleCase(),
                        style: const TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: kBorderRadius,
                      boxShadow: kBoxShadowList,
                    ),
                    child: DropdownMenu(
                      controller: controller,
                      width: 200,
                      textStyle: const TextStyle(
                        fontSize: 16.0,
                      ),
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
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
