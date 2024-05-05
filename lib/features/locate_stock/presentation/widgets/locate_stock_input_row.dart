import 'package:flutter/material.dart';
import 'package:multiple_search_selection/multiple_search_selection.dart';
import 'package:stock_management_tool/components/custom_container.dart';
import 'package:stock_management_tool/components/custom_dropdown_input_field.dart';
import 'package:stock_management_tool/components/custom_elevated_button.dart';
import 'package:stock_management_tool/constants/constants.dart';
import 'package:stock_management_tool/constants/enums.dart';
import 'package:stock_management_tool/features/locate_stock/presentation/widgets/custom_icon_button.dart';
import 'package:stock_management_tool/features/locate_stock/presentation/widgets/custom_item_details_table_view.dart';

class LocateStockInputRow extends StatelessWidget {
  LocateStockInputRow({
    super.key,
    required this.rowData,
    required this.allIds,
    required this.showRemoveButton,
    required this.removeOnTap,
    required this.onSearchBySelected,
    required this.onChooseIds,
    required this.onIdsChosen,
    required this.onShowTableToggled,
    required this.onShowDetailsToggled,
    required this.overlayPortalController,
    required this.onCheckBoxToggled,
    required this.onAllCheckBoxToggled,
  });

  final List searchableIds = const [
    "Item Id",
    "Container Id",
    "Warehouse Location Id",
    "Custom Search",
  ];

  final Map rowData;
  final Map allIds;
  final bool showRemoveButton;
  final Function() removeOnTap;
  final Function(String) onSearchBySelected;
  final Function() onChooseIds;
  final Function(List) onIdsChosen;
  final Function(bool) onShowTableToggled;
  final Function(StockViewMode) onShowDetailsToggled;
  final Function(String, CheckBoxState) onCheckBoxToggled;
  final Function(CheckBoxState) onAllCheckBoxToggled;

  final OverlayPortalController overlayPortalController;
  final MultipleSearchController multipleSearchController =
      MultipleSearchController();
  final TextEditingController textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      return CustomContainer(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: showRemoveButton
                        ? CustomIconButton(
                            onTap: removeOnTap,
                            icon: const Icon(
                              Icons.close_rounded,
                              size: 26,
                            ),
                          )
                        : const SizedBox(
                            width: 43,
                            height: 43,
                          ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: CustomDropdownInputField(
                      text: "Search By",
                      controller:
                          TextEditingController(text: rowData["search_by"]),
                      items: searchableIds,
                      onSelected: (value) {
                        if (searchableIds.contains(value) || value == "") {
                          onSearchBySelected(value);
                        }
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: SizedBox(
                      width: 322.5,
                      child: rowData["search_by"] != ""
                          ? CustomElevatedButton(
                              onPressed: () {
                                onChooseIds();
                                // overlayPortalController.toggle();
                              },
                              child:
                                  // OverlayPortal(
                                  //   controller: overlayPortalController,
                                  //   overlayChildBuilder: overlayChildBuilder,
                                  //   child:
                                  Text(
                                "Select ${rowData["search_by"]}s",
                                textAlign: TextAlign.center,
                                softWrap: false,
                                style: kButtonTextStyle,
                              ),
                              // ),
                            )
                          : Container(),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: SizedBox(
                      width: 43,
                      child: rowData["items"] != null &&
                              rowData["items"].isNotEmpty
                          ? CustomIconButton(
                              onTap: () {
                                onShowTableToggled(!rowData["show_table"]);
                              },
                              icon: Icon(
                                rowData["show_table"]
                                    ? Icons.keyboard_arrow_up_outlined
                                    : Icons.keyboard_arrow_down_outlined,
                                size: 26,
                              ),
                            )
                          : Container(),
                    ),
                  ),
                ],
              ),
              if (rowData["items"] != null &&
                  rowData["items"].isNotEmpty &&
                  rowData["show_table"])
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: SizedBox(
                        width: 400,
                        child: rowData["items"] != null &&
                                rowData["items"].isNotEmpty
                            ? SegmentedButton(
                                segments: const [
                                  ButtonSegment<StockViewMode>(
                                    value: StockViewMode.item,
                                    label: Text("Item"),
                                    // icon: Icon(Icons.grid_on_rounded),
                                  ),
                                  ButtonSegment<StockViewMode>(
                                    value: StockViewMode.container,
                                    label: Text("Container"),
                                    // icon: Icon(Icons.grid_off_rounded),
                                  ),
                                  ButtonSegment<StockViewMode>(
                                    value: StockViewMode.warehouse,
                                    label: Text("Warehouse"),
                                    // icon: Icon(Icons.grid_off_rounded),
                                  ),
                                ],
                                selected: {rowData["view_mode"]},
                                selectedIcon: const SizedBox.shrink(),
                                style: ButtonStyle(
                                  shape:
                                      MaterialStateProperty.all<OutlinedBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: kBorderRadius,
                                    ),
                                  ),
                                ),
                                onSelectionChanged: (value) {
                                  onShowDetailsToggled(value.first);
                                },
                              )
                            : Container(),
                      ),
                    ),
                  ],
                ),
              if (rowData["items"] != null &&
                  rowData["items"].isNotEmpty &&
                  rowData["show_table"])
                _buildQueryTable(constraints),
            ],
          ),
        ),
      );
    });
  }

  // Widget overlayChildBuilder(BuildContext context) {
  //   return Center(
  //     child: Padding(
  //       padding: const EdgeInsets.fromLTRB(250.0 + 52.0, 90.0, 52.0, 40.0),
  //       child: SizedBox(
  //         width: 500,
  //         child: CustomContainer(
  //           child: Padding(
  //             padding: const EdgeInsets.all(20.0),
  //             child: Column(
  //               crossAxisAlignment: CrossAxisAlignment.end,
  //               mainAxisSize: MainAxisSize.min,
  //               children: [
  //                 Container(
  //                   decoration: BoxDecoration(
  //                     color: kTertiaryBackgroundColor,
  //                     borderRadius: kBorderRadius,
  //                     boxShadow: kBoxShadowList,
  //                   ),
  //                   child: SizedBox(
  //                     height: 420.0,
  //                     child: Padding(
  //                       padding: const EdgeInsets.all(15.0),
  //                       child: CustomMultipleSearchSelection(
  //                         multipleSearchController: multipleSearchController,
  //                         title: "Select ${rowData["search_by"]}s",
  //                         initialPickedItems: rowData["chosen_ids"] ?? [],
  //                         items: allIds[rowData["search_by"]],
  //                       ),
  //                     ),
  //                   ),
  //                 ),
  //                 Padding(
  //                   padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
  //                   child: CustomElevatedButton(
  //                     onPressed: () {
  //                       overlayPortalController.hide();
  //                       onIdsChosen(multipleSearchController.getPickedItems());
  //                     },
  //                     text: 'Done',
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }

  Widget _buildQueryTable(BoxConstraints constraints) {
    List items = [];
    StockViewMode viewMode = rowData["view_mode"];
    if (viewMode == StockViewMode.item) items = rowData["items"];
    if (viewMode == StockViewMode.container) items = rowData["containers"];
    if (viewMode == StockViewMode.warehouse)
      items = rowData["warehouse_locations"];

    return CustomItemDetailsTableView(
      items: items,
      searchBy: rowData["search_by"],
      viewMode: viewMode,
      constraints: constraints,
      onCheckBoxToggled: onCheckBoxToggled,
      onAllCheckBoxToggled: onAllCheckBoxToggled,
    );
  }
}
