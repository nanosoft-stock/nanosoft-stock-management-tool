import 'package:flutter/material.dart';
import 'package:stock_management_tool/constants/constants.dart';

class CustomTextInputField extends StatelessWidget {
  const CustomTextInputField({
    super.key,
    required this.text,
    required this.controller,
    required this.onSelected,
  });

  final String text;
  final TextEditingController controller;
  final void Function(String) onSelected;

  @override
  Widget build(BuildContext context) {
    return InkWell(
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
                    width: 200,
                    decoration: BoxDecoration(
                      borderRadius: kBorderRadius,
                      boxShadow: kBoxShadowList,
                    ),
                    child: TextFormField(
                      controller: controller,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: kInputFieldFillColor,
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: kBorderRadius,
                        ),
                      ),
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
