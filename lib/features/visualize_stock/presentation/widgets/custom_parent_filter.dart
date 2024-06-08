import 'package:flutter/material.dart';
import 'package:stock_management_tool/constants/constants.dart';
import 'package:stock_management_tool/features/visualize_stock/presentation/widgets/custom_icon_button.dart';
import 'package:stock_management_tool/helper/string_casting_extension.dart';

class CustomParentFilter extends StatelessWidget {
  const CustomParentFilter({
    super.key,
    required this.fieldFilters,
    required this.closeOnTap,
    required this.fieldFilterOnPressed,
    required this.onReorder,
    required this.changeVisibilityOnTap,
  });

  final List fieldFilters;
  final Function() closeOnTap;
  final Function(String) fieldFilterOnPressed;
  final Function(List) onReorder;
  final Function(String, bool) changeVisibilityOnTap;

  @override
  Widget build(BuildContext context) {
    List localFieldFilters = [...fieldFilters];

    return Column(
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
                "All Filters",
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
                      "Reset",
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
                child: StatefulBuilder(
                  builder: (BuildContext context,
                      void Function(void Function()) setState) {
                    return ReorderableListView(
                      shrinkWrap: true,
                      physics: const BouncingScrollPhysics(),
                      proxyDecorator: (Widget child, int index,
                          Animation<double> animation) {
                        return child;
                      },
                      onReorder: (oldIndex, newIndex) {
                        setState(() {
                          if (oldIndex < newIndex) {
                            newIndex -= 1;
                          }
                          final item = localFieldFilters.removeAt(oldIndex);
                          localFieldFilters.insert(newIndex, item);
                        });
                        onReorder(localFieldFilters);
                      },
                      children: localFieldFilters
                          .map(
                            (e) => Padding(
                              key: Key(e["field"]),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 3.0, vertical: 4.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: kTertiaryBackgroundColor,
                                  // index % 2 == 0
                                  //     ? kTertiaryBackgroundColor
                                  //     : kButtonBackgroundColor,
                                  borderRadius: kBorderRadius,
                                  boxShadow: kBoxShadowList,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10.0, vertical: 6.0),
                                  child: Row(
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          fieldFilterOnPressed(e["field"]);
                                        },
                                        child: Text(
                                          e["field"].toString().toTitleCase(),
                                          style: kLabelTextStyle,
                                        ),
                                      ),
                                      // Padding(
                                      //   padding:
                                      //       const EdgeInsets
                                      //           .only(
                                      //           right:
                                      //               40.0),
                                      //   child: Container(
                                      //     decoration:
                                      //         BoxDecoration(
                                      //       color:
                                      //           kPrimaryBackgroundColor,
                                      //       borderRadius:
                                      //           kBorderRadius,
                                      //     ),
                                      //     child:
                                      //         SegmentedButton(
                                      //       segments: const [
                                      //         ButtonSegment(
                                      //           value:
                                      //               true,
                                      //           icon: Icon(
                                      //               Icons
                                      //                   .playlist_add_check),
                                      //         ),
                                      //         ButtonSegment(
                                      //           value:
                                      //               false,
                                      //           icon: Icon(
                                      //               Icons
                                      //                   .playlist_remove_rounded),
                                      //         ),
                                      //       ],
                                      //       showSelectedIcon:
                                      //           false,
                                      //       selected: {
                                      //         e["show_column"]
                                      //       },
                                      //       selectedIcon:
                                      //           const SizedBox
                                      //               .shrink(),
                                      //       style:
                                      //           ButtonStyle(
                                      //         shape: WidgetStateProperty
                                      //             .all<
                                      //                 OutlinedBorder>(
                                      //           RoundedRectangleBorder(
                                      //             borderRadius:
                                      //                 kBorderRadius,
                                      //           ),
                                      //         ),
                                      //       ),
                                      //       onSelectionChanged:
                                      //           (value) {
                                      //         setState(
                                      //             () {
                                      //           e["show_column"] =
                                      //               value
                                      //                   .first;
                                      //         });
                                      //         changeVisibilityOnTap(
                                      //             e["field"],
                                      //             value.first);
                                      //       },
                                      //     ),
                                      //   ),
                                      // ),
                                      // CustomFilterButton(
                                      //   field: e["field"],
                                      //   onPressed: () {},
                                      // ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
