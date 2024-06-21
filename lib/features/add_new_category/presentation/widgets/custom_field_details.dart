import 'package:flutter/material.dart';
import 'package:stock_management_tool/core/components/custom_autocomplete_text_input_field_with_tool_tip.dart';
import 'package:stock_management_tool/core/components/custom_text_input_field_with_tool_tip.dart';

class CustomFieldDetails extends StatelessWidget {
  const CustomFieldDetails({
    super.key,
    required this.detailKey,
    required this.text,
    required this.message,
    required this.options,
    required this.fieldDetails,
    required this.validator,
    required this.onSelected,
    required this.onSubmitted,
  });

  final String detailKey;
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
              isEnabled: fieldDetails["can_edit"],
              message: message,
              initialValue: fieldDetails[detailKey],
              items: options[detailKey] ?? [],
              validator: validator,
              onSelected: onSelected,
            )
          : CustomTextInputFieldWithToolTip(
              text: text,
              isEnabled: fieldDetails["can_edit"],
              message: message,
              initialValue: fieldDetails[detailKey],
              validator: validator,
              onChanged: onSelected,
              onSubmitted: onSubmitted,
            ),
    );
  }
}
