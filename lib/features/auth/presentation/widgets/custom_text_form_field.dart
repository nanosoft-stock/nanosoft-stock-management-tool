import 'package:flutter/material.dart';
import 'package:stock_management_tool/core/constants/constants.dart';

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField({
    super.key,
    required this.controller,
    required this.label,
    required this.type,
    required this.action,
    this.obscureText = false,
    this.onFieldSubmitted,
  });

  final TextEditingController controller;
  final String label;
  final TextInputType type;
  final TextInputAction action;
  final bool obscureText;
  final void Function(String)? onFieldSubmitted;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        width: 250,
        child: TextFormField(
          keyboardType: type,
          controller: controller,
          textInputAction: action,
          cursorColor: kCursorColor,
          obscureText: obscureText,
          onFieldSubmitted: onFieldSubmitted ?? (_) {},
          decoration: InputDecoration(
            filled: true,
            fillColor: kTertiaryBackgroundColor,
            border: const OutlineInputBorder(),
            labelText: label,
            labelStyle: kLabelTextStyle,
          ),
          style: kLabelTextStyle,
        ),
      ),
    );
  }
}
