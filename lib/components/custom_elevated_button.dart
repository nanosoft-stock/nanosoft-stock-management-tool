import 'package:flutter/material.dart';
import 'package:stock_management_tool/constants/constants.dart';

class CustomElevatedButton extends StatelessWidget {
  const CustomElevatedButton({
    super.key,
    required this.text,
    required this.onPressed,
  });

  final String text;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          elevation: 3,
          backgroundColor: kButtonBackgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: kBorderRadius,
          ),
        ),
        onPressed: onPressed,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 15.0,
            horizontal: 10.0,
          ),
          child: Text(
            text,
            softWrap: false,
            style: kButtonTextStyle,
          ),
        ),
      ),
    );
  }
}
