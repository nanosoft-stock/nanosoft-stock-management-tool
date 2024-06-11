import 'package:flutter/material.dart';
import 'package:stock_management_tool/core/constants/constants.dart';

class CustomCheckbox extends StatelessWidget {
  const CustomCheckbox({
    super.key,
    required this.locked,
    this.partial = false,
    required this.onChecked,
  });

  final bool locked;
  final bool partial;
  final void Function() onChecked;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onChecked();
      },
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Material(
            elevation: 7,
            borderRadius: BorderRadius.circular(4),
            child: Container(
              width: 20.0,
              height: 20.0,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Center(
                child: Container(
                  width: 18.0,
                  height: 18.0,
                  padding: EdgeInsets.symmetric(vertical: partial ? 7 : 0),
                  decoration: BoxDecoration(
                    color: kTertiaryBackgroundColor,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Center(
                    child: Container(
                      width: 13,
                      height: 13,
                      decoration: BoxDecoration(
                        color: partial || locked
                            ? kCheckboxCheckedColor
                            : kTertiaryBackgroundColor,
                        borderRadius: BorderRadius.circular(partial ? 1 : 3),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
