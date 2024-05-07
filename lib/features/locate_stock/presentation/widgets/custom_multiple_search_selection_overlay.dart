import 'package:flutter/material.dart';
import 'package:multiple_search_selection/multiple_search_selection.dart';
import 'package:stock_management_tool/components/custom_container.dart';
import 'package:stock_management_tool/components/custom_elevated_button.dart';
import 'package:stock_management_tool/constants/constants.dart';
import 'package:stock_management_tool/features/locate_stock/presentation/widgets/custom_multiple_search_selection.dart';
import 'package:stock_management_tool/features/locate_stock/presentation/widgets/custom_overlay_effect.dart';

class CustomMultipleSearchSelectionOverlay extends StatelessWidget {
  CustomMultipleSearchSelectionOverlay({
    super.key,
    required this.allIds,
    required this.rowData,
    required this.hideOverlay,
    required this.onIdEntered,
    required this.onDone,
  });

  final Map allIds;
  final Map rowData;
  final Function() hideOverlay;
  final Function(String) onIdEntered;
  final Function(List) onDone;

  final MultipleSearchController multipleSearchController =
      MultipleSearchController();

  @override
  Widget build(BuildContext context) {
    return CustomOverlayEffect(
      hideOverlay: hideOverlay,
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
                        multipleSearchController: multipleSearchController,
                        title: "Select ${rowData["search_by"]}s",
                        initialPickedItems: rowData["chosen_ids"] ?? [],
                        items: allIds[rowData["search_by"]] ?? [],
                        onIdEntered: onIdEntered,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                  child: CustomElevatedButton(
                    onPressed: () {
                      onDone(multipleSearchController.getPickedItems());
                    },
                    text: 'Done',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
