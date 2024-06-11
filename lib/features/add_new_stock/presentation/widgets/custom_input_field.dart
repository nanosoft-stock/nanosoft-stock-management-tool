import 'package:flutter/material.dart';
import 'package:stock_management_tool/core/components/custom_dropdown_and_checkbox_input_field.dart';
import 'package:stock_management_tool/core/components/custom_text_and_checkbox_input_field.dart';
import 'package:stock_management_tool/core/helper/string_casting_extension.dart';

class CustomInputField extends StatelessWidget {
  const CustomInputField({
    super.key,
    required this.fields,
    required this.index,
    required this.onSelected,
    required this.onChecked,
  });

  final int index;
  final List fields;
  final void Function(String) onSelected;
  final void Function() onChecked;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(7.5),
      child: fields[index].isWithSKU
          ? CustomDropdownAndCheckboxInputField(
              text: fields[index].isTitleCase
                  ? fields[index].field.toString().toTitleCase()
                  : fields[index].field.toString().toUpperCase(),
              controller: TextEditingController(text: fields[index].textValue),
              items: fields[index].items,
              lockable: fields[index].lockable,
              alignLockable: !fields[index].lockable,
              locked: fields[index].locked,
              onSelected: onSelected,
              onChecked: onChecked,
            )
          : CustomTextAndCheckboxInputField(
              text: fields[index].isTitleCase
                  ? fields[index].field.toString().toTitleCase()
                  : fields[index].field.toString().toUpperCase(),
              controller: TextEditingController(text: fields[index].textValue),
              lockable: fields[index].lockable,
              alignLockable: !fields[index].lockable,
              locked: fields[index].locked,
              onSelected: onSelected,
              onChecked: onChecked,
            ),
    );
  }
}
