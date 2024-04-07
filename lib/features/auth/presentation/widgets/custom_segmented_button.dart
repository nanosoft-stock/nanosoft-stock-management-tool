import 'package:flutter/material.dart';
import 'package:stock_management_tool/constants/constants.dart';

class CustomSegmentedButton extends StatelessWidget {
  const CustomSegmentedButton({
    super.key,
    required this.isLogin,
    required this.onSelectionChanged,
  });

  final bool isLogin;
  final void Function(Set)? onSelectionChanged;

  ButtonSegment<bool> _buttonSegment(value, boolean) {
    return ButtonSegment(
      value: value,
      label: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Text(
          value ? "Login" : "Sign Up",
          style: boolean ? kButtonTextStyle : kLabelTextStyle,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SegmentedButton(
      segments: [
        _buttonSegment(true, isLogin),
        _buttonSegment(false, !isLogin),
      ],
      selected: {isLogin},
      selectedIcon: const SizedBox.shrink(),
      style: ButtonStyle(
        shape: MaterialStateProperty.all<OutlinedBorder>(
          RoundedRectangleBorder(
            borderRadius: kBorderRadius,
          ),
        ),
      ),
      onSelectionChanged: onSelectionChanged,
    );
  }
}
