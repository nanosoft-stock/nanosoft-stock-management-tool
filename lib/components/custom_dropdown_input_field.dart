import 'package:flutter/material.dart';
import 'package:stock_management_tool/components/custom_dropdown_%20menu.dart';
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
    );
  }
}
