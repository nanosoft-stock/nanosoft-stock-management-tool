import 'package:flutter/material.dart';
import 'package:stock_management_tool/components/custom_container.dart';
import 'package:stock_management_tool/constants/constants.dart';
import 'package:stock_management_tool/features/visualize_stock/presentation/widgets/custom_icon_button.dart';
import 'package:stock_management_tool/helper/string_casting_extension.dart';

class CustomParentFilter extends StatelessWidget {
  const CustomParentFilter({
    super.key,
    required this.fieldFilters,
    required this.closeOnTap,
  });

  final List fieldFilters;
  final Function() closeOnTap;

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
                          "Filter",
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
                              StatefulBuilder(
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
                                        final item =
                                            fieldFilters.removeAt(oldIndex);
                                        fieldFilters.insert(newIndex, item);
                                      });
                                    },
                                    children: fieldFilters
                                        .map((e) => Padding(
                                              key: UniqueKey(),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 3.0,
                                                      vertical: 4.0),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color:
                                                      kTertiaryBackgroundColor,
                                                  // index % 2 == 0
                                                  //     ? kTertiaryBackgroundColor
                                                  //     : kButtonBackgroundColor,
                                                  borderRadius: kBorderRadius,
                                                  boxShadow: kBoxShadowList,
                                                ),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Row(
                                                    children: [
                                                      Expanded(
                                                        child: Text(
                                                          e["field"]
                                                              .toString()
                                                              .toTitleCase(),
                                                          style:
                                                              kLabelTextStyle,
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                                right: 30.0),
                                                        child: Container(
                                                          decoration:
                                                              BoxDecoration(
                                                            color:
                                                                kPrimaryBackgroundColor,
                                                            borderRadius:
                                                                kBorderRadius,
                                                          ),
                                                          child:
                                                              SegmentedButton(
                                                            segments: const [
                                                              ButtonSegment(
                                                                value: true,
                                                                icon: Icon(Icons
                                                                    .playlist_add_check),
                                                              ),
                                                              ButtonSegment(
                                                                value: false,
                                                                icon: Icon(Icons
                                                                    .playlist_remove_rounded),
                                                              ),
                                                            ],
                                                            showSelectedIcon:
                                                                false,
                                                            selected: {
                                                              e["show_column"]
                                                            },
                                                            selectedIcon:
                                                                const SizedBox
                                                                    .shrink(),
                                                            style: ButtonStyle(
                                                              shape: MaterialStateProperty
                                                                  .all<
                                                                      OutlinedBorder>(
                                                                RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      kBorderRadius,
                                                                ),
                                                              ),
                                                            ),
                                                            onSelectionChanged:
                                                                (value) {
                                                              setState(() {
                                                                e["show_column"] =
                                                                    value.first;
                                                              });
                                                            },
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ))
                                        .toList(),
                                  );
                                  // return ReorderableListView.builder(
                                  //   shrinkWrap: true,
                                  //   itemCount: fieldFilters.length,
                                  //   physics: const BouncingScrollPhysics(),
                                  //   proxyDecorator: (Widget child, int index,
                                  //       Animation<double> animation) {
                                  //     return child;
                                  //   },
                                  //   onReorder: (oldIndex, newIndex) {
                                  //     setState(() {
                                  //       if (oldIndex < newIndex) {
                                  //         newIndex -= 1;
                                  //       }
                                  //       final item =
                                  //           fieldFilters.removeAt(oldIndex);
                                  //       fieldFilters.insert(newIndex, item);
                                  //     });
                                  //   },
                                  //   itemBuilder:
                                  //       (BuildContext context, int index) {
                                  //     return Padding(
                                  //       key: UniqueKey(),
                                  //       padding: const EdgeInsets.symmetric(
                                  //           horizontal: 3.0, vertical: 4.0),
                                  //       child: Container(
                                  //         decoration: BoxDecoration(
                                  //           color: kTertiaryBackgroundColor,
                                  //           // index % 2 == 0
                                  //           //     ? kTertiaryBackgroundColor
                                  //           //     : kButtonBackgroundColor,
                                  //           borderRadius: kBorderRadius,
                                  //           boxShadow: kBoxShadowList,
                                  //         ),
                                  //         child: Padding(
                                  //           padding: const EdgeInsets.all(8.0),
                                  //           child: Row(
                                  //             children: [
                                  //               Expanded(
                                  //                 child: Text(
                                  //                   fieldFilters[index]["field"]
                                  //                       .toString()
                                  //                       .toTitleCase(),
                                  //                   style: kLabelTextStyle,
                                  //                 ),
                                  //               ),
                                  //               Padding(
                                  //                 padding:
                                  //                     const EdgeInsets.only(
                                  //                         right: 30.0),
                                  //                 child: Container(
                                  //                   decoration: BoxDecoration(
                                  //                     color:
                                  //                         kPrimaryBackgroundColor,
                                  //                     borderRadius:
                                  //                         kBorderRadius,
                                  //                   ),
                                  //                   child: SegmentedButton(
                                  //                     segments: const [
                                  //                       ButtonSegment(
                                  //                         value: true,
                                  //                         icon: Icon(Icons
                                  //                             .playlist_add_check),
                                  //                       ),
                                  //                       ButtonSegment(
                                  //                         value: false,
                                  //                         icon: Icon(Icons
                                  //                             .playlist_remove_rounded),
                                  //                       ),
                                  //                     ],
                                  //                     showSelectedIcon: false,
                                  //                     selected: {
                                  //                       fieldFilters[index]
                                  //                           ["show_column"]
                                  //                     },
                                  //                     selectedIcon:
                                  //                         const SizedBox
                                  //                             .shrink(),
                                  //                     style: ButtonStyle(
                                  //                       shape: MaterialStateProperty
                                  //                           .all<
                                  //                               OutlinedBorder>(
                                  //                         RoundedRectangleBorder(
                                  //                           borderRadius:
                                  //                               kBorderRadius,
                                  //                         ),
                                  //                       ),
                                  //                     ),
                                  //                     onSelectionChanged:
                                  //                         (value) {
                                  //                       setState(() {
                                  //                         fieldFilters[index][
                                  //                                 "show_column"] =
                                  //                             value.first;
                                  //                       });
                                  //                     },
                                  //                   ),
                                  //                 ),
                                  //               ),
                                  //             ],
                                  //           ),
                                  //         ),
                                  //       ),
                                  //     );
                                  //   },
                                  // );
                                },
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
