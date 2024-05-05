import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:multiple_search_selection/multiple_search_selection.dart';
import 'package:stock_management_tool/components/custom_container.dart';
import 'package:stock_management_tool/components/custom_elevated_button.dart';
import 'package:stock_management_tool/constants/constants.dart';
import 'package:stock_management_tool/features/locate_stock/presentation/widgets/custom_multiple_search_selection.dart';

class CustomMultipleSearchSelectionOverlayEntry extends StatelessWidget {
  const CustomMultipleSearchSelectionOverlayEntry({
    super.key,
    required this.allIds,
    required this.rowData,
    required this.controller,
    required this.hideOverlay,
    required this.onDone,
  });

  final Map allIds;
  final Map rowData;
  final MultipleSearchController controller;
  final Function() hideOverlay;
  final Function() onDone;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Stack(
        children: [
          GestureDetector(
            onTap: () {
              hideOverlay();
            },
            behavior: HitTestBehavior.opaque,
          ),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
            child: Center(
              child: Padding(
                padding:
                    const EdgeInsets.fromLTRB(250.0 + 52.0, 90.0, 52.0, 40.0),
                child: SizedBox(
                  width: 500,
                  child: CustomContainer(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: kTertiaryBackgroundColor,
                              borderRadius: kBorderRadius,
                              boxShadow: kBoxShadowList,
                            ),
                            child: SizedBox(
                              height: 420.0,
                              child: Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: CustomMultipleSearchSelection(
                                  multipleSearchController: controller,
                                  title: "Select ${rowData["search_by"]}s",
                                  initialPickedItems:
                                      rowData["chosen_ids"] ?? [],
                                  items: allIds[rowData["search_by"]],
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                            child: CustomElevatedButton(
                              onPressed: () {
                                onDone();
                              },
                              text: 'Done',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
