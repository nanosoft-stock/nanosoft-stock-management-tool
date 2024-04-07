import 'package:flutter/material.dart';
import 'package:stock_management_tool/components/custom_elevated_button.dart';

class CustomSubmitButton extends StatelessWidget {
  const CustomSubmitButton({
    super.key,
    required this.text,
    required this.onPressed,
  });

  final String text;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 8.0),
      child: SizedBox(
        width: 250,
        child: CustomElevatedButton(
          text: text,
          onPressed: onPressed,
        ),
      ),
    );
  }
}
