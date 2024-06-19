import 'package:flutter/material.dart';
import 'package:stock_management_tool/core/helper/case_helper.dart';
import 'package:stock_management_tool/features/add_new_stock/presentation/widgets/custom_autocomplete_text_input_field_and_checkbox.dart';
import 'package:stock_management_tool/features/add_new_stock/presentation/widgets/custom_text_input_field_and_checkbox.dart';

class CustomInputField extends StatelessWidget {
  const CustomInputField({
    super.key,
    required this.field,
    required this.onSelected,
    required this.onChecked,
  });

  final Map<String, dynamic> field;
  final void Function(String, String) onSelected;
  final void Function(String, bool) onChecked;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(7.5),
      child: field["items"] != null
          ? CustomAutocompleteTextInputFieldAndCheckbox(
              text: CaseHelper.convert(field["name_case"], field["field"]),
              initialValue: field["text_value"],
              items: field["items"],
              isLockable: field["is_lockable"],
              alignLockable: !field["is_lockable"],
              isDisabled: field["is_disabled"],
              validator: (value) {
                if (field["field"] == "category") {
                  if (value == null || value.trim() == "") {
                    return "Category can't be empty";
                  } else if (!field["items"].contains(value)) {
                    return "Category not recognised";
                  }
                } else if (field["field"] == "item id") {
                  if (value == null || value.trim() == "") {
                    return "Item Id can't be empty";
                  }
                }
                return null;
              },
              onSelected: (value) {
                onSelected(field["field"], value);
              },
              onChecked: () {
                onChecked(field["field"], !field["is_disabled"]);
              },
            )
          : CustomTextInputFieldAndCheckbox(
              text: CaseHelper.convert(field["name_case"], field["field"]),
              initialValue: field["text_value"],
              isLockable: field["is_lockable"],
              alignLockable: !field["is_lockable"],
              isDisabled: field["is_disabled"],
              validator: (value) {
                if (field["field"] == "category") {
                  if (value == null || value.trim() == "") {
                    return "Category can't be empty";
                  } else if (!field["items"].contains(value)) {
                    return "Category not recognised";
                  }
                } else if (field["field"] == "item id") {
                  if (value == null || value.trim() == "") {
                    return "Item Id can't be empty";
                  }
                }
                return null;
              },
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
