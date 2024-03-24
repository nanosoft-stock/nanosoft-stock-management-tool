import 'package:flutter/material.dart';
import 'package:stock_management_tool/constants/constants.dart';

class CustomElevatedButton extends StatelessWidget {
  CustomElevatedButton(
      {super.key, required this.text, required this.onPressed});

  String text;
  var onPressed;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          elevation: 3,
          backgroundColor: kButtonBackgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: kBorderRadius,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 15.0,
            horizontal: 10.0,
          ),
          child: Text(
            text,
            softWrap: false,
            style: const TextStyle(fontSize: 14.0),
          ),
        ),
      ),
    );
  }
}
