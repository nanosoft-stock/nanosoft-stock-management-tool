import 'package:flutter/material.dart';
import 'package:stock_management_tool/constants/constants.dart';

class CustomCheckboxListTile extends StatelessWidget {
  const CustomCheckboxListTile({
    super.key,
    required this.title,
    required this.value,
    this.tristate = false,
    required this.onChanged,
  });

  final String title;
  final bool? value;
  final bool tristate;
  final Function(bool?) onChanged;

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      title: Text(
        title,
        style: kLabelTextStyle,
      ),
      value: value,
      tristate: tristate,
      splashRadius: 0,
      dense: true,
      activeColor: kCheckboxCheckedColor,
      controlAffinity: ListTileControlAffinity.leading,
      onChanged: onChanged,
      enableFeedback: false,
    );
  }
}
