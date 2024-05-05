import 'package:flutter/material.dart';
import 'package:stock_management_tool/components/custom_dropdown_menu.dart';
import 'package:stock_management_tool/constants/constants.dart';

class CustomDropdownInputField extends StatelessWidget {
  const CustomDropdownInputField({
    super.key,
    required this.text,
    required this.controller,
    required this.items,
    required this.onSelected,
  });

  final String text;
  final TextEditingController controller;
  final List items;
  final void Function(String) onSelected;

  @override
  Widget build(BuildContext context) {
    return FocusScope(
      child: Focus(
        onFocusChange: (hasFocus) {
          if (!hasFocus) {
            onSelected(controller.text);
          }
        },
        child: Center(
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
                      padding: const EdgeInsets.only(left: 2.5, right: 5),
                      child: SizedBox(
                        width: 95,
                        child: Text(
                          text,
                          style: kLabelTextStyle,
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: kBorderRadius,
                        boxShadow: kBoxShadowList,
                      ),
                      child: CustomDropdownMenu(
                        controller: controller,
                        items: items,
                        onSelected: onSelected,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
