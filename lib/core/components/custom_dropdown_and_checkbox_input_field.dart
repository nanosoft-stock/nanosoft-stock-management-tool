import 'package:flutter/material.dart';
import 'package:stock_management_tool/core/components/custom_checkbox.dart';
import 'package:stock_management_tool/core/components/custom_dropdown_menu.dart';
import 'package:stock_management_tool/core/constants/constants.dart';

class CustomDropdownAndCheckboxInputField extends StatelessWidget {
  const CustomDropdownAndCheckboxInputField({
    super.key,
    required this.text,
    required this.controller,
    required this.items,
    this.isLockable = false,
    this.alignLockable = false,
    this.isDisabled = false,
    this.requestFocusOnTap = true,
    required this.onSelected,
    required this.onChecked,
  });

  final String text;
  final TextEditingController controller;
  final List items;
  final bool isLockable;
  final bool alignLockable;
  final bool isDisabled;
  final bool requestFocusOnTap;
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
              decoration: BoxDecoration(
                borderRadius: kBorderRadius,
                boxShadow: kBoxShadowList,
              ),
              child: CustomDropdownMenu(
                controller: controller,
                isDisabled: isDisabled,
                debugLabel: text,
                requestFocusOnTap: requestFocusOnTap,
                items: items,
                onSelected: onSelected,
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

// import 'package:flutter/material.dart';
// import 'package:stock_management_tool/core/components/custom_checkbox.dart';
// import 'package:stock_management_tool/core/components/custom_dropdown_menu.dart';
// import 'package:stock_management_tool/core/constants/constants.dart';
//
// class CustomDropdownAndCheckboxInputField extends StatelessWidget {
//   const CustomDropdownAndCheckboxInputField({
//     super.key,
//     required this.text,
//     required this.controller,
//     required this.items,
//     this.isLockable = false,
//     this.alignLockable = false,
//     this.isDisabled = false,
//     required this.onSelected,
//     required this.onChecked,
//   });
//
//   final String text;
//   final TextEditingController controller;
//   final List items;
//   final bool isLockable;
//   final bool alignLockable;
//   final bool isDisabled;
//   final void Function(String) onSelected;
//   final void Function() onChecked;
//
//   @override
//   Widget build(BuildContext context) {
//     return FocusScope(
//       child: Focus(
//         onFocusChange: (hasFocus) {
//           if (!hasFocus) {
//             onSelected(controller.text);
//           }
//         },
//         child: SingleChildScrollView(
//           scrollDirection: Axis.horizontal,
//           child: Container(
//             decoration: BoxDecoration(
//               borderRadius: kBorderRadius,
//               color: kTertiaryBackgroundColor,
//               boxShadow: kBoxShadowList,
//             ),
//             child: Padding(
//               padding: const EdgeInsets.all(10.0),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.only(left: 2.5, right: 5),
//                     child: SizedBox(
//                       width: 95,
//                       child: Text(
//                         text,
//                         style: kLabelTextStyle,
//                       ),
//                     ),
//                   ),
//                   Container(
//                     decoration: BoxDecoration(
//                       borderRadius: kBorderRadius,
//                       boxShadow: kBoxShadowList,
//                     ),
//                     child: CustomDropdownMenu(
//                       controller: controller,
//                       items: items,
//                       onSelected: onSelected,
//                     ),
//                   ),
//                   if (isLockable)
//                     const SizedBox(
//                       width: 10.0,
//                     ),
//                   if (isLockable)
//                     CustomCheckbox(
//                       locked: isDisabled,
//                       onChecked: onChecked,
//                     ),
//                   if (alignLockable)
//                     const SizedBox(
//                       width: 10.0,
//                     ),
//                   if (alignLockable)
//                     const SizedBox(
//                       width: 43.0,
//                       height: 43.0,
//                     ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
//
