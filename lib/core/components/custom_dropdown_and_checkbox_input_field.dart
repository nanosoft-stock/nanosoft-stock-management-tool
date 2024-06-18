import 'package:flutter/material.dart';
import 'package:stock_management_tool/core/components/custom_checkbox.dart';
import 'package:stock_management_tool/core/components/custom_dropdown_menu.dart';
import 'package:stock_management_tool/core/constants/constants.dart';

class CustomDropdownAndCheckboxInputField extends StatelessWidget {
  const CustomDropdownAndCheckboxInputField({
    super.key,
    required this.text,
    required this.controller,
    required this.items,
    this.lockable = false,
    this.alignLockable = false,
    this.locked = false,
    required this.onSelected,
    required this.onChecked,
  });

  final String text;
  final TextEditingController controller;
  final List items;
  final bool lockable;
  final bool alignLockable;
  final bool locked;
  final void Function(String) onSelected;
  final void Function() onChecked;

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
                    if (lockable)
                      const SizedBox(
                        width: 10.0,
                      ),
                    if (lockable)
                      CustomCheckbox(
                        locked: locked,
                        onChecked: onChecked,
                      ),
                    if (alignLockable)
                      const SizedBox(
                        width: 10.0,
                      ),
                    if (alignLockable)
                      const SizedBox(
                        width: 43.0,
                        height: 43.0,
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
