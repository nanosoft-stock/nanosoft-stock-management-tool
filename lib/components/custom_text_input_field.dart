import 'package:flutter/material.dart';
import 'package:stock_management_tool/constants/constants.dart';
import 'package:stock_management_tool/helper/string_casting_extension.dart';

class CustomTextInputField extends StatelessWidget {
  CustomTextInputField({
    super.key,
    required this.text,
    required this.controller,
  });

  String text;
  TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Center(
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
    );
  }
}
