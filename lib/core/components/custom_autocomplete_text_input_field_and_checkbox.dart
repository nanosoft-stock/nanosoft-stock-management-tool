import 'package:flutter/material.dart';
import 'package:stock_management_tool/core/components/custom_checkbox.dart';
import 'package:stock_management_tool/core/constants/constants.dart';

class CustomAutocompleteTextInputFieldAndCheckbox extends StatelessWidget {
  const CustomAutocompleteTextInputFieldAndCheckbox({
    super.key,
    required this.text,
    required this.initialValue,
    required this.items,
    this.isLockable = false,
    this.alignLockable = false,
    this.isDisabled = false,
    required this.validator,
    required this.onSelected,
    required this.onChecked,
  });

  final String text;
  final String initialValue;
  final List<String> items;
  final bool isLockable;
  final bool alignLockable;
  final bool isDisabled;
  final String? Function(String?) validator;
  final void Function(String) onSelected;
  final void Function() onChecked;

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
                child: Text(
                  text,
                  style: kLabelTextStyle,
                ),
              ),
            ),
            Container(
              width: 200,
              decoration: BoxDecoration(
                borderRadius: kBorderRadius,
                boxShadow: kBoxShadowList,
              ),
              child: Autocomplete<String>(
                optionsBuilder: (TextEditingValue value) {
                  if (value.text == "") {
                    return items;
                  }
                  return items.where((e) =>
                      e.toLowerCase().contains(value.text.toLowerCase()));
                },
                onSelected: (value) {
                  onSelected(value);
                },
                optionsViewBuilder: (BuildContext context,
                    void Function(String) onSelected,
                    Iterable<String> options) {
                  return Align(
                    alignment: Alignment.topLeft,
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(
                        maxWidth: 200.0,
                        maxHeight: 200.0,
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          color: kDropdownMenuFillColor,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(4.0)),
                          boxShadow: kBoxShadowList,
                        ),
                        child: ListView.builder(
                          itemCount: options.length,
                          shrinkWrap: true,
                          physics: const ClampingScrollPhysics(),
                          itemBuilder: (BuildContext context, int index) {
                            return GestureDetector(
                              onTap: () {
                                onSelected(options.elementAt(index));
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Text(
                                  options.elementAt(index),
                                  style: kLabelTextStyle,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  );
                },
                fieldViewBuilder: (BuildContext context,
                    TextEditingController controller,
                    FocusNode node,
                    void Function() onFieldSubmitted) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    controller.text = initialValue;
                  });

                  return TextFormField(
                    enabled: !isDisabled,
                    controller: controller,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: kInputFieldFillColor,
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: kBorderRadius,
                      ),
                    ),
                    focusNode: node,
                    validator: validator,
                    onChanged: (value) {
                      controller.text = value;
                    },
                    onFieldSubmitted: (value) {
                      if (value.trim() == "" ||
                          items
                              .where((e) =>
                                  e.toLowerCase().contains(value.toLowerCase()))
                              .isEmpty) {
                        onSelected(value);
                      } else {
                        onFieldSubmitted();
                      }
                    },
                    style: kLabelTextStyle,
                  );
                },
              ),
            ),
            if (isLockable)
              const SizedBox(
                width: 10.0,
              ),
            if (isLockable)
              CustomCheckbox(
                locked: isDisabled,
                onChecked: onChecked,
              ),
            if (alignLockable)
              const SizedBox(
                width: 10.0,
              ),
            if (alignLockable)
              const SizedBox(
                width: 43.0,
                height: 43.0,
              ),
          ],
        ),
      ),
    );
  }
}
