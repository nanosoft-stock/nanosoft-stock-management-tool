import 'package:flutter/material.dart';
import 'package:stock_management_tool/core/components/custom_checkbox.dart';
import 'package:stock_management_tool/core/constants/constants.dart';

class CustomTextAndCheckboxInputField extends StatelessWidget {
  const CustomTextAndCheckboxInputField({
    super.key,
    required this.text,
    required this.controller,
    this.isLockable = false,
    this.alignLockable = false,
    this.isDisabled = false,
    required this.onSelected,
    required this.onChecked,
  });

  final String text;
  final TextEditingController controller;
  final bool isLockable;
  final bool alignLockable;
  final bool isDisabled;
  final void Function(String) onSelected;
  final void Function() onChecked;

  @override
  Widget build(BuildContext context) {
    return Container(
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
                enabled: !isDisabled,
                initialValue: controller.text,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: kInputFieldFillColor,
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: kBorderRadius,
                  ),
                ),
                focusNode: FocusNode(debugLabel: text),
                onChanged: (value) {
                  onSelected(value);
                },
                style: kLabelTextStyle,
              ),
            ),
            if (isLockable)
              const SizedBox(
                width: 10.0,
              ),
            if (isLockable)
              CustomCheckbox(
                locked: isDisabled,
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
    );
  }
}
