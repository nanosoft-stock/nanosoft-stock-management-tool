import 'package:flutter/material.dart';
import 'package:stock_management_tool/core/helper/case_helper.dart';
import 'package:stock_management_tool/features/add_new_product/presentation/widgets/custom_autocomplete_text_input_field.dart';
import 'package:stock_management_tool/features/add_new_product/presentation/widgets/custom_text_input_field.dart';

class CustomInputField extends StatelessWidget {
  const CustomInputField(
      {super.key, required this.field, required this.onSelected});

  final Map<String, dynamic> field;
  final void Function(String, String) onSelected;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(7.5),
      child: field["items"] != null
          ? CustomAutocompleteTextInputField(
              text: CaseHelper.convert(field["name_case"], field["field"]),
              initialValue: field["text_value"],
              items: field["items"],
              validator: (value) {
                if (field["field"] == "category") {
                  if (value == null || value.trim() == "") {
                    return "Category can't be empty";
                  } else if (!field["items"].contains(value)) {
                    return "Category not recognised";
                  }
                } else if (field["field"] == "sku") {
                  if (value == null || value.trim() == "") {
                    return "SKU can't be empty";
                  }
                }
                return null;
              },
              onSelected: (value) {
                onSelected(field["field"], value);
              },
            )
          : CustomTextInputField(
              text: CaseHelper.convert(field["name_case"], field["field"]),
              initialValue: field["text_value"],
              validator: (value) {
                if (field["field"] == "category") {
                  if (value == null || value.trim() == "") {
                    return "Category can't be empty";
                  } else if (!field["items"].contains(value)) {
                    return "Category not recognised";
                  }
                } else if (field["field"] == "sku") {
                  if (value == null || value.trim() == "") {
                    return "SKU can't be empty";
                  }
                }
                return null;
              },
              onSelected: (value) {
                onSelected(field["field"], value);
              },
            ),
    );
  }
}
