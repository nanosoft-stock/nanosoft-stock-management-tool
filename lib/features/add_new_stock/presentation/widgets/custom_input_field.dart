import 'package:flutter/material.dart';
import 'package:stock_management_tool/core/components/custom_dropdown_and_checkbox_input_field.dart';
import 'package:stock_management_tool/core/components/custom_text_and_checkbox_input_field.dart';
import 'package:stock_management_tool/core/helper/case_helper.dart';

class CustomInputField extends StatelessWidget {
  const CustomInputField({
    super.key,
    required this.field,
    this.requestFocusOnTap = true,
    required this.onSelected,
    required this.onChecked,
  });

  final Map<String, dynamic> field;
  final bool requestFocusOnTap;
  final void Function(String, String) onSelected;
  final void Function(String, bool) onChecked;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(7.5),
      child: field["items"] != null
          ? CustomDropdownAndCheckboxInputField(
              text: CaseHelper.convert(field["name_case"], field["field"]),
              controller: TextEditingController(text: field["text_value"]),
              items: field["items"],
              isLockable: field["is_lockable"],
              alignLockable: !field["is_lockable"],
              isDisabled: field["is_disabled"],
              requestFocusOnTap: requestFocusOnTap,
              onSelected: (value) {
                onSelected(field["field"], value);
              },
              onChecked: () {
                onChecked(field["field"], !field["is_disabled"]);
              },
            )
          : CustomTextAndCheckboxInputField(
              text: CaseHelper.convert(field["name_case"], field["field"]),
              controller: TextEditingController(text: field["text_value"]),
              isLockable: field["is_lockable"],
              alignLockable: !field["is_lockable"],
              isDisabled: field["is_disabled"],
              onSelected: (value) {
                onSelected(field["field"], value);
              },
              onChecked: () {
                onChecked(field["field"], !field["is_disabled"]);
              },
            ),
    );
  }
}
