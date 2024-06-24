import 'package:flutter/material.dart';
import 'package:stock_management_tool/core/components/custom_autocomplete_text_input_field_with_tool_tip.dart';
import 'package:stock_management_tool/core/components/custom_text_input_field_with_tool_tip.dart';

class CustomFieldDetails extends StatelessWidget {
  const CustomFieldDetails({
    super.key,
    required this.fieldFormKey,
    required this.detailKey,
    required this.displayField,
    required this.text,
    required this.message,
    required this.options,
    required this.fieldDetails,
    required this.validator,
    required this.onSelected,
    required this.onSubmitted,
  });

  final GlobalKey<FormFieldState<dynamic>>? fieldFormKey;
  final String detailKey;
  final String displayField;
  final String text;
  final String message;
  final Map<String, dynamic> options;
  final Map<String, dynamic> fieldDetails;
  final String? Function(String?) validator;
  final Function(String) onSelected;
  final Function(String) onSubmitted;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(7.5),
      child: detailKey != "field"
          ? CustomAutocompleteTextInputFieldWithToolTip(
              text: text,
              isEnabled: fieldDetails[displayField]["can_edit"],
              message: message,
              initialValue: fieldDetails[displayField][detailKey],
              items: options[detailKey] ?? [],
              validator: validator,
              onSelected: onSelected,
            )
          : CustomTextInputFieldWithToolTip(
              fieldFormKey: fieldFormKey,
              text: text,
              isEnabled: fieldDetails[displayField]["can_edit"],
              message: message,
              initialValue: fieldDetails[displayField][detailKey],
              validator: (value) {
                int len = fieldDetails.values
                    .where(
                        (e) => e["field"].toLowerCase() == value!.toLowerCase())
                    .length;
                if (value == "") {
                  return "Field name can't be empty";
                } else if (len > 1) {
                  return "Field name already exists";
                }

                return null;
              },
              onChanged: onSelected,
              onSubmitted: onSubmitted,
            ),
    );
  }
}
