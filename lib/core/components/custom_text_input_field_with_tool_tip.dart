import 'package:flutter/material.dart';
import 'package:stock_management_tool/core/constants/constants.dart';

class CustomTextInputFieldWithToolTip extends StatelessWidget {
  const CustomTextInputFieldWithToolTip({
    super.key,
    this.fieldFormKey,
    required this.text,
    required this.isEnabled,
    required this.message,
    required this.initialValue,
    required this.validator,
    required this.onChanged,
    required this.onSubmitted,
  });

  final GlobalKey<FormFieldState<dynamic>>? fieldFormKey;
  final String text;
  final bool isEnabled;
  final String message;
  final String initialValue;
  final String? Function(String?) validator;
  final void Function(String) onChanged;
  final void Function(String) onSubmitted;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: kBorderRadius,
        color: kTertiaryBackgroundColor,
        boxShadow: kBoxShadowList,
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 2.5, right: 5),
              child: SizedBox(
                width: 95,
                child: Tooltip(
                  message: message,
                  textStyle: kLabelTextStyle.copyWith(
                      color: Colors.black87, fontSize: 13),
                  decoration: BoxDecoration(
                    color: kPrimaryBackgroundColor,
                    borderRadius: BorderRadius.circular(5),
                    boxShadow: kBoxShadowList,
                  ),
                  child: Text(
                    text,
                    style: kLabelTextStyle,
                  ),
                ),
              ),
            ),
            Container(
              width: 200,
              decoration: BoxDecoration(
                borderRadius: kBorderRadius,
                boxShadow: kBoxShadowList,
              ),
              child: TextFormField(
                key: fieldFormKey,
                enabled: isEnabled,
                controller: TextEditingController(text: initialValue),
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: kInputFieldFillColor,
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: kBorderRadius,
                  ),
                ),
                focusNode: FocusNode(debugLabel: text),
                validator: validator,
                onChanged: onChanged,
                onFieldSubmitted: onSubmitted,
                style: kLabelTextStyle,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
