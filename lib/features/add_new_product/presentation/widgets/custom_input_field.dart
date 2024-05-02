import 'package:flutter/material.dart';
import 'package:stock_management_tool/components/custom_dropdown_input_field.dart';
import 'package:stock_management_tool/components/custom_text_input_field.dart';
import 'package:stock_management_tool/helper/string_casting_extension.dart';

class CustomInputField extends StatelessWidget {
  const CustomInputField(
      {super.key,
      required this.fields,
      required this.index,
      required this.onSelected});

  final int index;
  final List fields;
  final void Function(String) onSelected;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(7.5),
      child: fields[index].field != "sku"
          ? CustomDropdownInputField(
              text: fields[index].isTitleCase
                  ? fields[index].field.toString().toTitleCase()
                  : fields[index].field.toString().toUpperCase(),
              controller: TextEditingController(text: fields[index].textValue),
              items: fields[index].items,
              onSelected: onSelected,
            )
          : CustomTextInputField(
              text: fields[index].isTitleCase
                  ? fields[index].field.toString().toTitleCase()
                  : fields[index].field.toString().toUpperCase(),
              controller: TextEditingController(text: fields[index].textValue),
              onSelected: onSelected,
            ),
    );
  }
}
