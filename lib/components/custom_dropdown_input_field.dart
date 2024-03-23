import 'package:flutter/material.dart';

class CustomDropdownInputField extends StatelessWidget {
  CustomDropdownInputField(
      {super.key,
      required this.text,
      required this.controller,
      required this.items,
      required this.onSelected});

  String text;
  TextEditingController controller;
  List items;
  final onSelected;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            color: Colors.white,
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
                      text,
                      style: const TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                DropdownMenu(
                  controller: controller,
                  width: 200,
                  textStyle: const TextStyle(
                    fontSize: 16.0,
                  ),
                  inputDecorationTheme: InputDecorationTheme(
                    filled: true,
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    fillColor: const Color(0xEEE8DEF8),
                  ),
                  dropdownMenuEntries: items
                      .map(
                        (e) => DropdownMenuEntry(
                          value: e,
                          label: e,
                        ),
                      )
                      .toList(),
                  onSelected: (value) {
                    String text;
                    if (value == null) {
                      text = controller.text;
                    } else {
                      text = value;
                    }
                    onSelected.call();
                    print(text);
                  },
                ),
                // CustomDropDownMenu(
                //   controller: controller,
                //   items: items,
                //   onSelected: onSelected,
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
