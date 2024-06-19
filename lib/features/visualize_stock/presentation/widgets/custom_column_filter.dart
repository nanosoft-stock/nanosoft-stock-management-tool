import 'package:flutter/material.dart';
import 'package:stock_management_tool/core/constants/constants.dart';
import 'package:stock_management_tool/core/constants/enums.dart';
import 'package:stock_management_tool/core/helper/string_casting_extension.dart';
import 'package:stock_management_tool/features/visualize_stock/presentation/widgets/custom_checkbox_list_tile.dart';
import 'package:stock_management_tool/features/visualize_stock/presentation/widgets/custom_icon_button.dart';

class CustomColumnFilter extends StatelessWidget {
  const CustomColumnFilter({
    super.key,
    required this.isClose,
    required this.fieldFilter,
    required this.closeOnTap,
    required this.backOnTap,
    required this.filterOnPressed,
    required this.clearOnPressed,
    required this.changeVisibilityOnTap,
    required this.sortOnPressed,
    required this.filterBySelected,
    required this.filterValueChanged,
    required this.searchValueChanged,
    required this.checkboxToggled,
  });

  final bool isClose;
  final Map<String, dynamic> fieldFilter;
  final Function() closeOnTap;
  final Function() backOnTap;
  final Function() filterOnPressed;
  final Function() clearOnPressed;
  final Function(bool) changeVisibilityOnTap;
  final Function(Sort) sortOnPressed;
  final Function(String) filterBySelected;
  final Function(String) filterValueChanged;
  final Function(String) searchValueChanged;
  final Function(String, bool?) checkboxToggled;

  @override
  Widget build(BuildContext context) {
    List allUniqueValues = fieldFilter["unique_values"];

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(5.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomIconButton(
                icon: Icon(
                  isClose ? Icons.close_rounded : Icons.arrow_back,
                ),
                onTap: isClose ? closeOnTap : backOnTap,
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
                    onPressed: filterOnPressed,
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
                    onPressed: clearOnPressed,
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
                      padding: const EdgeInsets.symmetric(vertical: 5.0),
                      child: SegmentedButton(
                        segments: [
                          ButtonSegment(
                            value: true,
                            // icon: Icon(Icons.table_rows_rounded),
                            icon: const Icon(Icons.playlist_add_check),
                            label: Text(
                              "Show",
                              style: kLabelTextStyle,
                            ),
                          ),
                          ButtonSegment(
                            value: false,
                            icon: const Icon(Icons.playlist_remove_rounded),
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
                          shape: WidgetStateProperty.all<OutlinedBorder>(
                            RoundedRectangleBorder(
                              borderRadius: kBorderRadius,
                            ),
                          ),
                        ),
                        onSelectionChanged: (value) {
                          changeVisibilityOnTap(value.first);
                        },
                      ),
                    ),
                    const Divider(),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5.0),
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
                            icon: const Icon(Icons.arrow_downward_rounded),
                            label: Text(
                              "Ascending",
                              style: kLabelTextStyle,
                            ),
                          ),
                          ButtonSegment(
                            value: Sort.desc,
                            icon: const Icon(Icons.arrow_upward_rounded),
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
                          shape: WidgetStateProperty.all<OutlinedBorder>(
                            RoundedRectangleBorder(
                              borderRadius: kBorderRadius,
                            ),
                          ),
                        ),
                        onSelectionChanged: (value) {
                          sortOnPressed(
                              value.isNotEmpty ? value.first : Sort.none);
                        },
                      ),
                    ),
                    const Divider(),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5.0),
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
                      padding: const EdgeInsets.symmetric(vertical: 5.0),
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
                                  borderRadius: kBorderRadius,
                                  menuMaxHeight: 250,
                                  underline: Container(),
                                  value: fieldFilter["filter_by"] != ""
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
                                  items: fieldFilter["all_filter_by_values"]
                                      .map((String e) => DropdownMenuItem(
                                            value: e,
                                            child: Text(
                                              e,
                                              style: kLabelTextStyle,
                                            ),
                                          ))
                                      .toList()
                                      .cast<DropdownMenuItem<String>>(),
                                  onChanged: (value) {
                                    filterBySelected(value ?? "");
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
                              initialValue: fieldFilter["filter_value"],
                              style: kLabelTextStyle,
                              textInputAction: TextInputAction.done,
                              textAlignVertical: TextAlignVertical.top,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: kTertiaryBackgroundColor,
                                border: OutlineInputBorder(
                                  borderRadius: kBorderRadius,
                                ),
                                labelText: fieldFilter["filter_by"] != ""
                                    ? fieldFilter["filter_by"]
                                    : "Select Filter",
                                labelStyle: kLabelTextStyle,
                              ),
                              onChanged: filterValueChanged,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // if (fieldFilter["filter_field_2"] != null)
                    //   const SizedBox(height: 10.0),
                    // if (fieldFilter["filter_field_2"] != null)
                    //   Padding(
                    //     padding:
                    //         const EdgeInsets.symmetric(vertical: 5.0),
                    //     child: Row(
                    //       mainAxisAlignment: MainAxisAlignment.center,
                    //       children: [
                    //         Container(
                    //           decoration: BoxDecoration(
                    //             border: Border.all(),
                    //             borderRadius: kBorderRadius,
                    //           ),
                    //           child: Padding(
                    //             padding: const EdgeInsets.symmetric(
                    //               horizontal: 7.0,
                    //               vertical: 2.0,
                    //             ),
                    //             // padding: EdgeInsets.zero,
                    //             child: SizedBox(
                    //               // width: 200,
                    //               child: DropdownButton(
                    //                 autofocus: false,
                    //                 borderRadius: kBorderRadius,
                    //                 hint: SizedBox(
                    //                   width: 150,
                    //                   child: Text(
                    //                     "Select Filter",
                    //                     style: kLabelTextStyle,
                    //                   ),
                    //                 ),
                    //                 menuMaxHeight: 250,
                    //                 icon: const Icon(Icons
                    //                     .arrow_drop_down_outlined),
                    //                 underline: Container(),
                    //                 items: [
                    //                   "Equals",
                    //                   "Not Equals",
                    //                   "Begins With",
                    //                   "Not Begins With",
                    //                   "Contains",
                    //                   "Not Contains",
                    //                   "Ends With",
                    //                   "Not Ends With",
                    //                 ]
                    //                     .map(
                    //                       (e) => DropdownMenuItem(
                    //                         value: e,
                    //                         child: Text(
                    //                           e,
                    //                           style: kLabelTextStyle,
                    //                         ),
                    //                       ),
                    //                     )
                    //                     .toList(),
                    //                 onChanged: (value) {},
                    //               ),
                    //             ),
                    //           ),
                    //         ),
                    //         const SizedBox(
                    //           width: 20.0,
                    //         ),
                    //         SizedBox(
                    //           width: 200,
                    //           child: TextFormField(
                    //             controller: TextEditingController(),
                    //             enabled: false,
                    //             decoration: InputDecoration(
                    //               filled: true,
                    //               fillColor: kTertiaryBackgroundColor,
                    //               border: OutlineInputBorder(
                    //                 borderRadius: kBorderRadius,
                    //               ),
                    //               labelText: "Select Filter",
                    //               labelStyle: kLabelTextStyle,
                    //             ),
                    //             style: kLabelTextStyle,
                    //           ),
                    //         ),
                    //       ],
                    //     ),
                    //   ),

                    const Divider(),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(3.0, 5.0, 3.0, 5.0),
                      child: Row(
                        children: [
                          const Icon(Icons.search_outlined),
                          const SizedBox(
                            width: 5,
                          ),
                          Expanded(
                            child: SizedBox(
                              // width: 175,
                              height: 40,
                              child: TextFormField(
                                initialValue: fieldFilter["search_value"],
                                style: kLabelTextStyle,
                                textInputAction: TextInputAction.done,
                                textAlignVertical: TextAlignVertical.top,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: kTertiaryBackgroundColor,
                                  border: OutlineInputBorder(
                                    borderRadius: kBorderRadius,
                                  ),
                                  labelText: "Search",
                                  labelStyle: kLabelTextStyle,
                                ),
                                onChanged: searchValueChanged,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(3.0, 5.0, 3.0, 3.0),
                      child: Container(
                        height: 550,
                        decoration: BoxDecoration(
                          color: kTertiaryBackgroundColor,
                          borderRadius: kBorderRadius,
                          boxShadow: kBoxShadowList,
                        ),
                        child: allUniqueValues.isNotEmpty
                            // &&
                            //     fieldFilter["field"] != "date"
                            ? ListView.builder(
                                itemCount: allUniqueValues.length + 1,
                                shrinkWrap: true,
                                itemBuilder: (BuildContext context, int index) {
                                  String title = index != 0
                                      ? allUniqueValues[index - 1] ?? ""
                                      : "";

                                  if (index == 0) {
                                    return Padding(
                                      padding:
                                          const EdgeInsets.only(left: 50.0),
                                      child: SizedBox(
                                        width: 300,
                                        child: CustomCheckboxListTile(
                                          title: fieldFilter["search_value"] ==
                                                  ""
                                              ? "(Select all)"
                                              : "(Select all search results)",
                                          value: fieldFilter["all_selected"],
                                          tristate: true,
                                          onChanged: (value) {
                                            checkboxToggled(
                                                "select_all", value ?? false);
                                          },
                                        ),
                                      ),
                                    );
                                  } else {
                                    return Padding(
                                      padding:
                                          const EdgeInsets.only(left: 50.0),
                                      child: SizedBox(
                                        width: 300,
                                        child: CustomCheckboxListTile(
                                          title:
                                              title != "" ? title : "(Blanks)",
                                          value: fieldFilter[
                                                  "unique_values_details"]
                                              [title]["selected"],
                                          onChanged: (value) {
                                            checkboxToggled(title, value);
                                          },
                                        ),
                                      ),
                                    );
                                  }
                                },
                              )
                            : Center(
                                child: Text(
                                  "No Match",
                                  style: kLabelTextStyle,
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
      ],
    );
  }
}
