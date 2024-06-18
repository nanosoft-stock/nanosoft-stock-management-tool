import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stock_management_tool/core/constants/constants.dart';

class CustomElevatedButton extends StatelessWidget {
  const CustomElevatedButton({
    super.key,
    this.text,
    this.child,
    required this.onPressed,
  });

  final String? text;
  final Widget? child;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: ElevatedButton(
        focusNode: FocusNode(onKeyEvent: (FocusNode node, KeyEvent event) {
          if (event is KeyDownEvent &&
              event.logicalKey == LogicalKeyboardKey.enter) {
            FocusScope.of(context).nextFocus();
            onPressed();
            return KeyEventResult.handled;
          }
          return KeyEventResult.ignored;
        }),
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
          child: child ??
              Text(
                text!,
                softWrap: false,
                style: kButtonTextStyle,
              ),
        ),
      ),
    );
  }
}
