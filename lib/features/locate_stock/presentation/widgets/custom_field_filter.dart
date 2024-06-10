import 'package:flutter/material.dart';
import 'package:stock_management_tool/constants/constants.dart';
import 'package:stock_management_tool/features/visualize_stock/presentation/widgets/custom_checkbox_list_tile.dart';
import 'package:stock_management_tool/features/visualize_stock/presentation/widgets/custom_icon_button.dart';
import 'package:stock_management_tool/helper/string_casting_extension.dart';

class CustomFieldFilter extends StatelessWidget {
  const CustomFieldFilter({
    super.key,
    required this.fieldFilter,
    required this.backOnTap,
    required this.filterOnPressed,
    required this.clearOnPressed,
    required this.filterBySelected,
    required this.filterValueChanged,
    required this.searchValueChanged,
    required this.checkboxToggled,
  });

  final Map<String, dynamic> fieldFilter;
  final Function() backOnTap;
  final Function() filterOnPressed;
  final Function(String) clearOnPressed;
  final Function(String, String) filterBySelected;
  final Function(String, String) filterValueChanged;
  final Function(String, String) searchValueChanged;
  final Function(String, String, bool?) checkboxToggled;

  @override
  Widget build(BuildContext context) {
    List allUniqueValues = fieldFilter["all_unique_values"]
        .where((e) => e["show"] == true)
        .toList();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(5.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomIconButton(
                icon: const Icon(
                  Icons.arrow_back,
                ),
                onTap: backOnTap,
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
                    onPressed: () {
                      filterOnPressed();
                    },
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
                    onPressed: () {
                      clearOnPressed(fieldFilter["field"]);
                    },
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
              child: Column(
                children: [
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
                        // SizedBox(
                        //   width: 175,
                        //   height: 40,
                        //   child: DropdownButtonFormField<String>(
                        //     borderRadius: kBorderRadius,
                        //     menuMaxHeight: 250,
                        //     decoration: InputDecoration(
                        //       filled: true,
                        //       fillColor: kButtonBackgroundColor,
                        //       border: OutlineInputBorder(
                        //         borderRadius: kBorderRadius,
                        //       ),
                        //       labelText: "Select Filter",
                        //       labelStyle: kLabelTextStyle,
                        //     ),
                        //     value: fieldFilter["filter_by"] != ""
                        //         ? fieldFilter["filter_by"]
                        //         : null,
                        //     icon: const Icon(
                        //         Icons.arrow_drop_down_outlined),
                        //     items: fieldFilter[
                        //             "all_filter_by_values"]
                        //         .map((String e) => DropdownMenuItem(
                        //               value: e,
                        //               child: Text(
                        //                 e,
                        //                 style: kLabelTextStyle,
                        //               ),
                        //             ))
                        //         .toList()
                        //         .cast<DropdownMenuItem<String>>(),
                        //     onChanged: (value) {
                        //       filterBySelected(fieldFilter["field"],
                        //           value ?? "");
                        //     },
                        //   ),
                        // ),
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
                                icon:
                                    const Icon(Icons.arrow_drop_down_outlined),
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
                                  filterBySelected(
                                      fieldFilter["field"], value ?? "");
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
                            onChanged: (value) {
                              filterValueChanged(fieldFilter["field"], value);
                            },
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
                              onChanged: (value) {
                                searchValueChanged(fieldFilter["field"], value);
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(3.0, 5.0, 3.0, 3.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: kTertiaryBackgroundColor,
                          borderRadius: kBorderRadius,
                          boxShadow: kBoxShadowList,
                        ),
                        child: allUniqueValues.isNotEmpty &&
                                fieldFilter["field"] != "date"
                            ? ListView.builder(
                                itemCount: allUniqueValues.length + 1,
                                shrinkWrap: true,
                                itemBuilder: (BuildContext context, int index) {
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
                                                fieldFilter["field"],
                                                "select_all",
                                                value ?? false);
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
                                          title: allUniqueValues[index - 1]
                                                      ["title"] !=
                                                  ""
                                              ? allUniqueValues[index - 1]
                                                  ["title"]
                                              : "(Blanks)",
                                          value: allUniqueValues[index - 1]
                                              ["selected"],
                                          onChanged: (value) {
                                            checkboxToggled(
                                                fieldFilter["field"],
                                                allUniqueValues[index - 1]
                                                    ["title"],
                                                value);
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
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
