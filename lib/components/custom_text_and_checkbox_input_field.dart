import 'package:flutter/material.dart';
import 'package:stock_management_tool/constants/constants.dart';
import 'package:stock_management_tool/helper/string_casting_extension.dart';

class CustomTextAndCheckboxInputField extends StatelessWidget {
  CustomTextAndCheckboxInputField({
    super.key,
    required this.text,
    required this.controller,
    this.lockable = false,
    this.alignLockable = false,
    this.locked = false,
  });

  String text;
  TextEditingController controller;
  bool lockable;
  bool alignLockable;
  bool locked;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Container(
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
                  padding: const EdgeInsets.only(left: 2.5),
                  child: SizedBox(
                    width: 100,
                    child: Text(
                      text.toTitleCase(),
                      style: const TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold,
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
                  ),
                ),
                if (lockable)
                  const SizedBox(
                    width: 10.0,
                  ),
                if (lockable)
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Material(
                      elevation: 7,
                      child: Container(
                        width: 23.0,
                        height: 23.0,
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(4),
                          // boxShadow: kBoxShadowList,
                          // borderRadius: kBorderRadius,
                        ),
                        child: Center(
                          child: Container(
                            width: 21.0,
                            height: 21.0,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(4),
                              // borderRadius: kBorderRadius,
                            ),
                            child: Center(
                              child: Container(
                                width: 15,
                                height: 15,
                                decoration: BoxDecoration(
                                  color: Colors.purple,
                                  borderRadius: BorderRadius.circular(3),
                                  // borderRadius: kBorderRadius,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    // Checkbox(
                    //   value: locked,
                    //   onChanged: (val) {
                    //     locked = !locked;
                    //     print(val);
                    //   },
                    // ),
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
        ),
      ),
    );
  }
}
