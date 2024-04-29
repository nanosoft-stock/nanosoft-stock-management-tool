import 'package:flutter/material.dart';
import 'package:multiple_search_selection/multiple_search_selection.dart';
import 'package:stock_management_tool/components/custom_container.dart';
import 'package:stock_management_tool/components/custom_dropdown_input_field.dart';
import 'package:stock_management_tool/components/custom_elevated_button.dart';
import 'package:stock_management_tool/constants/constants.dart';
import 'package:stock_management_tool/constants/enums.dart';
import 'package:stock_management_tool/features/locate_stock/presentation/widgets/custom_icon_button.dart';
import 'package:stock_management_tool/features/locate_stock/presentation/widgets/custom_item_details_table_view.dart';
import 'package:stock_management_tool/features/locate_stock/presentation/widgets/custom_multiple_search_selection.dart';

class LocateStockInputRow extends StatelessWidget {
  LocateStockInputRow({
    super.key,
    required this.query,
    required this.showRemoveButton,
    required this.removeOnTap,
    required this.onSearchBySelected,
    required this.onIdSelected,
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

  final Map query;
  final bool showRemoveButton;
  final Function() removeOnTap;
  final Function(String) onSearchBySelected;
  final Function(List) onIdSelected;
  final Function(bool) onShowTableToggled;
  final Function(bool) onShowDetailsToggled;
  final Function(String, CheckBoxState) onCheckBoxToggled;
  final Function(CheckBoxState) onAllCheckBoxToggled;

  final OverlayPortalController overlayPortalController;
  final MultipleSearchController multipleSearchController = MultipleSearchController();
  final TextEditingController textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
      return CustomContainer(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Wrap(
                direction: Axis.horizontal,
                runSpacing: 15,
                alignment: WrapAlignment.end,
                runAlignment: WrapAlignment.center,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30.0),
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
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: CustomDropdownInputField(
                          text: "Search By",
                          controller: TextEditingController(text: query["search_by"]),
                          items: searchableIds,
                          onSelected: (value) {
                            if (searchableIds.contains(value) || value == "") {
                              onSearchBySelected(value);
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: SizedBox(
                      width: 322.5,
                      child: query["search_by"] != ""
                          ? CustomElevatedButton(
                              onPressed: () {
                                overlayPortalController.toggle();
                              },
                              child: OverlayPortal(
                                controller: overlayPortalController,
                                overlayChildBuilder: overlayChildBuilder,
                                child: Text(
                                  "Select ${query["search_by"]}",
                                  textAlign: TextAlign.center,
                                  softWrap: false,
                                  style: kButtonTextStyle,
                                ),
                              ),
                            )
                          : Container(),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: SizedBox(
                      width: 110,
                      child: query["search_by"] != "Item Id" &&
                              query["selected_ids_details"] != null &&
                              query["selected_ids_details"].isNotEmpty
                          ? SegmentedButton(
                              segments: const [
                                ButtonSegment<bool>(
                                  value: true,
                                  icon: Icon(Icons.grid_on_rounded),
                                ),
                                ButtonSegment<bool>(
                                  value: false,
                                  icon: Icon(Icons.grid_off_rounded),
                                )
                              ],
                              selected: {query["show_details"]},
                              selectedIcon: const SizedBox.shrink(),
                              style: ButtonStyle(
                                shape: MaterialStateProperty.all<OutlinedBorder>(
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
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: SizedBox(
                      width: 43,
                      child: query["selected_ids_details"] != null &&
                              query["selected_ids_details"].isNotEmpty
                          ? CustomIconButton(
                              onTap: () {
                                onShowTableToggled(!query["show_table"]);
                              },
                              icon: Icon(
                                query["show_table"]
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
              if (query["selected_ids_details"] != null &&
                  query["selected_ids_details"].isNotEmpty &&
                  query["show_table"])
                _buildQueryTable(constraints),
            ],
          ),
        ),
      );
    });
  }

  Widget overlayChildBuilder(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(250.0 + 52.0, 90.0, 52.0, 40.0),
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
                          title: "Select ${query["search_by"]}",
                          initialPickedItems: query["selected_ids"] ?? [],
                          items: query["all_ids"],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                    child: CustomElevatedButton(
                      onPressed: () {
                        overlayPortalController.hide();
                        onIdSelected(multipleSearchController.getPickedItems());
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
    );
  }

  Widget _buildQueryTable(BoxConstraints constraints) {
    return CustomItemDetailsTableView(
      items: !query["show_details"] ? query["unique_ids_details"] : query["selected_ids_details"],
      searchBy: query["search_by"],
      showDetails: query["show_details"],
      constraints: constraints,
      onCheckBoxToggled: onCheckBoxToggled,
      onAllCheckBoxToggled: onAllCheckBoxToggled,
    );
  }
}
