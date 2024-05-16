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
    required this.filterBySelected,
    required this.filterValueEntered,
  });

  final Map<String, dynamic> fieldFilter;
  final Function() closeOnTap;
  final Function(String, Sort) sortOnPressed;
  final Function(String, String) filterBySelected;
  final Function(String, String) filterValueEntered;

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
                            const SizedBox(
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
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5.0),
                    child: Divider(),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5.0),
                      child: ClipRRect(
                        borderRadius: kBorderRadius,
                        child: SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 5.0,
                                ),
                                child: Row(
                                  children: [
                                    const Icon(Icons.table_rows_outlined),
                                    const SizedBox(
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
                                      icon:
                                          const Icon(Icons.playlist_add_check),
                                      label: Text(
                                        "Show",
                                        style: kLabelTextStyle,
                                      ),
                                    ),
                                    ButtonSegment(
                                      value: false,
                                      icon: const Icon(
                                          Icons.playlist_remove_rounded),
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
                              const Divider(),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 5.0),
                                child: Row(
                                  children: [
                                    const Icon(Icons.swap_vert_outlined),
                                    const SizedBox(
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
                                      icon: const Icon(
                                          Icons.arrow_downward_rounded),
                                      label: Text(
                                        "Ascending",
                                        style: kLabelTextStyle,
                                      ),
                                    ),
                                    ButtonSegment(
                                      value: Sort.desc,
                                      icon: const Icon(
                                          Icons.arrow_upward_rounded),
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
                                        fieldFilter["field"],
                                        value.isNotEmpty
                                            ? value.first
                                            : Sort.none);
                                  },
                                ),
                              ),
                              const Divider(),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 5.0),
                                child: Row(
                                  children: [
                                    const Icon(Icons.filter_alt_outlined),
                                    const SizedBox(
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
                                          child: DropdownButton<String>(
                                            autofocus: false,
                                            borderRadius: kBorderRadius,
                                            menuMaxHeight: 250,
                                            underline: Container(),
                                            // style: kLabelTextStyle,
                                            value:
                                                fieldFilter["filter_by"] != ""
                                                    ? fieldFilter["filter_by"]
                                                    : null,
                                            hint: SizedBox(
                                              width: 129,
                                              child: Text(
                                                "Select Filter",
                                                style: kLabelTextStyle,
                                              ),
                                            ),
                                            icon: const Icon(
                                                Icons.arrow_drop_down_outlined),
                                            items: fieldFilter[
                                                    "all_filter_by_values"]
                                                .map((String e) =>
                                                    DropdownMenuItem(
                                                      value: e,
                                                      child: Text(
                                                        e,
                                                        style: kLabelTextStyle,
                                                      ),
                                                    ))
                                                .toList()
                                                .cast<
                                                    DropdownMenuItem<String>>(),
                                            onChanged: (value) {
                                              filterBySelected(
                                                  fieldFilter["field"],
                                                  value ?? "");
                                            },
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 20.0,
                                    ),
                                    SizedBox(
                                      width: 175,
                                      height: 40,
                                      child: TextFormField(
                                        controller: TextEditingController(
                                            text: fieldFilter["filter_value"]
                                            // != ""
                                            // ? fieldFilter["filter_value"]
                                            // : null,
                                            ),
                                        style: kLabelTextStyle,
                                        textInputAction: TextInputAction.done,
                                        textAlignVertical:
                                            TextAlignVertical.top,
                                        decoration: InputDecoration(
                                          filled: true,
                                          fillColor: kTertiaryBackgroundColor,
                                          border: OutlineInputBorder(
                                            borderRadius: kBorderRadius,
                                          ),
                                          labelText:
                                              fieldFilter["filter_by"] != ""
                                                  ? fieldFilter["filter_by"]
                                                  : "Select Filter",
                                          labelStyle: kLabelTextStyle,
                                        ),
                                        onFieldSubmitted: (value) {
                                          filterValueEntered(
                                              fieldFilter["field"], value);
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              if (fieldFilter["filter_field_2"] != null)
                                const SizedBox(height: 10.0),
                              if (fieldFilter["filter_field_2"] != null)
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
                                              icon: const Icon(Icons
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
                                      const SizedBox(
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
                                              borderRadius: kBorderRadius,
                                            ),
                                            labelText: "Select Filter",
                                            labelStyle: kLabelTextStyle,
                                          ),
                                          style: kLabelTextStyle,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              const Divider(),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 5.0),
                                child: Row(
                                  children: [
                                    const Icon(Icons.search_outlined),
                                    const SizedBox(
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
                                  height: 550,
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
