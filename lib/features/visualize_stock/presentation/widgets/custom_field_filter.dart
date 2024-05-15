import 'package:flutter/material.dart';
import 'package:stock_management_tool/components/custom_container.dart';
import 'package:stock_management_tool/constants/constants.dart';
import 'package:stock_management_tool/constants/enums.dart';
import 'package:stock_management_tool/features/visualize_stock/presentation/widgets/custom_icon_button.dart';
import 'package:stock_management_tool/helper/string_casting_extension.dart';

class CustomFieldFilter extends StatelessWidget {
  const CustomFieldFilter({
    super.key,
    required this.fieldFilter,
    required this.closeOnTap,
    required this.sortOnPressed,
  });

  final Map fieldFilter;
  final Function() closeOnTap;
  final Function(String, Sort) sortOnPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: kSecondaryBackgroundColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(10.0),
          bottomLeft: Radius.circular(10.0),
        ),
        boxShadow: kBoxShadowList,
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: CustomContainer(
          child: Container(
            decoration: BoxDecoration(
              color: kPrimaryBackgroundColor,
              borderRadius: kBorderRadius,
            ),
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomIconButton(
                          icon: const Icon(Icons.close_rounded),
                          onTap: closeOnTap,
                        ),
                        Text(
                          fieldFilter["field"].toString().toTitleCase(),
                          style: kLabelTextStyle,
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: kBorderRadius,
                                ),
                              ),
                              onPressed: () {},
                              child: Text(
                                "Filter",
                                style: kLabelTextStyle,
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: kBorderRadius,
                                ),
                              ),
                              onPressed: () {},
                              child: Text(
                                "Clear",
                                style: kLabelTextStyle,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Divider(),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5.0),
                      child: ClipRRect(
                        borderRadius: kBorderRadius,
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        child: SingleChildScrollView(
                          physics: BouncingScrollPhysics(),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 5.0,
                                ),
                                child: Row(
                                  children: [
                                    Icon(Icons.table_rows_outlined),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      "Show/Hide Column",
                                      style: kLabelTextStyle,
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 5.0),
                                child: SegmentedButton(
                                  segments: [
                                    ButtonSegment(
                                      value: true,
                                      // icon: Icon(Icons.table_rows_rounded),
                                      icon: Icon(Icons.playlist_add_check),
                                      label: Text(
                                        "Show",
                                        style: kLabelTextStyle,
                                      ),
                                    ),
                                    ButtonSegment(
                                      value: false,
                                      icon: Icon(Icons.playlist_remove_rounded),
                                      label: Text(
                                        "Hide",
                                        style: kLabelTextStyle,
                                      ),
                                    ),
                                  ],
                                  showSelectedIcon: false,
                                  selected: {fieldFilter["show_column"]},
                                  selectedIcon: const SizedBox.shrink(),
                                  style: ButtonStyle(
                                    shape: MaterialStateProperty.all<
                                        OutlinedBorder>(
                                      RoundedRectangleBorder(
                                        borderRadius: kBorderRadius,
                                      ),
                                    ),
                                  ),
                                  onSelectionChanged: (value) {},
                                ),
                              ),
                              Divider(),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 5.0),
                                child: Row(
                                  children: [
                                    Icon(Icons.swap_vert_outlined),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      "Sort",
                                      style: kLabelTextStyle,
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: SegmentedButton(
                                  segments: [
                                    ButtonSegment(
                                      value: Sort.asc,
                                      icon: Icon(Icons.arrow_downward_rounded),
                                      label: Text(
                                        "Ascending",
                                        style: kLabelTextStyle,
                                      ),
                                    ),
                                    ButtonSegment(
                                      value: Sort.desc,
                                      icon: Icon(Icons.arrow_upward_rounded),
                                      label: Text(
                                        "Descending",
                                        style: kLabelTextStyle,
                                      ),
                                    ),
                                  ],
                                  showSelectedIcon: false,
                                  emptySelectionAllowed: true,
                                  selected: fieldFilter["sort"] != Sort.none
                                      ? {fieldFilter["sort"]}
                                      : {},
                                  selectedIcon: const SizedBox.shrink(),
                                  style: ButtonStyle(
                                    shape: MaterialStateProperty.all<
                                        OutlinedBorder>(
                                      RoundedRectangleBorder(
                                        borderRadius: kBorderRadius,
                                      ),
                                    ),
                                  ),
                                  onSelectionChanged: (value) {
                                    sortOnPressed(
                                        fieldFilter["field"], value.isNotEmpty ? value.first : Sort.none);
                                  },
                                ),
                              ),
                              Divider(),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 5.0),
                                child: Row(
                                  children: [
                                    Icon(Icons.filter_alt_outlined),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      "Filter",
                                      style: kLabelTextStyle,
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 5.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      height: 40,
                                      decoration: BoxDecoration(
                                        border: Border.all(),
                                        borderRadius: kBorderRadius,
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 10.0,
                                        ),
                                        child: SizedBox(
                                          child: DropdownButton(
                                            autofocus: false,
                                            borderRadius: kBorderRadius,
                                            hint: SizedBox(
                                              width: 129,
                                              child: Text(
                                                "Select Filter",
                                                style: kLabelTextStyle,
                                              ),
                                            ),
                                            menuMaxHeight: 250,
                                            icon: Icon(
                                                Icons.arrow_drop_down_outlined),
                                            underline: Container(),
                                            items: [
                                              "Equals",
                                              "Not Equals",
                                              "Begins With",
                                              "Not Begins With",
                                              "Contains",
                                              "Not Contains",
                                              "Ends With",
                                              "Not Ends With",
                                            ]
                                                .map(
                                                  (e) => DropdownMenuItem(
                                                    value: e,
                                                    child: Text(
                                                      e,
                                                      style: kLabelTextStyle,
                                                    ),
                                                  ),
                                                )
                                                .toList(),
                                            onChanged: (value) {},
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 20.0,
                                    ),
                                    SizedBox(
                                      width: 175,
                                      height: 40,
                                      child: TextFormField(
                                        controller: TextEditingController(),
                                        decoration: InputDecoration(
                                          filled: true,
                                          fillColor: kTertiaryBackgroundColor,
                                          border: OutlineInputBorder(
                                              borderRadius: kBorderRadius),
                                          labelText: "Select Filter",
                                          labelStyle: kLabelTextStyle,
                                        ),
                                        style: kLabelTextStyle,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              if (false) SizedBox(height: 10.0),
                              if (false)
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 5.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(),
                                          borderRadius: kBorderRadius,
                                          // BorderRadius
                                          //     .circular(
                                          //         5.0),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 7.0,
                                            vertical: 2.0,
                                          ),
                                          // padding: EdgeInsets.zero,
                                          child: SizedBox(
                                            // width: 200,
                                            child: DropdownButton(
                                              autofocus: false,
                                              borderRadius: kBorderRadius,
                                              hint: SizedBox(
                                                width: 150,
                                                child: Text(
                                                  "Select Filter",
                                                  style: kLabelTextStyle,
                                                ),
                                              ),
                                              menuMaxHeight: 250,
                                              // isDense: true,
                                              icon: Icon(Icons
                                                  .arrow_drop_down_outlined),
                                              underline: Container(),
                                              items: [
                                                "Equals",
                                                "Not Equals",
                                                "Begins With",
                                                "Not Begins With",
                                                "Contains",
                                                "Not Contains",
                                                "Ends With",
                                                "Not Ends With",
                                              ]
                                                  .map(
                                                    (e) => DropdownMenuItem(
                                                      value: e,
                                                      child: Text(
                                                        e,
                                                        style: kLabelTextStyle,
                                                      ),
                                                    ),
                                                  )
                                                  .toList(),
                                              onChanged: (value) {},
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 20.0,
                                      ),
                                      SizedBox(
                                        width: 200,
                                        child: TextFormField(
                                          controller: TextEditingController(),
                                          enabled: false,
                                          decoration: InputDecoration(
                                            filled: true,
                                            fillColor: kTertiaryBackgroundColor,
                                            border: OutlineInputBorder(
                                                borderRadius: kBorderRadius),
                                            labelText: "Select Filter",
                                            labelStyle: kLabelTextStyle,
                                          ),
                                          style: kLabelTextStyle,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              Divider(),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 5.0),
                                child: Row(
                                  children: [
                                    Icon(Icons.search_outlined),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      "Search",
                                      style: kLabelTextStyle,
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(
                                    3.0, 5.0, 3.0, 3.0),
                                child: Container(
                                  height: 500,
                                  decoration: BoxDecoration(
                                    color: kTertiaryBackgroundColor,
                                    borderRadius: kBorderRadius,
                                    boxShadow: kBoxShadowList,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
