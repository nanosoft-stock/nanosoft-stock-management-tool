import 'package:flutter/material.dart';
import 'package:multiple_search_selection/multiple_search_selection.dart';
import 'package:stock_management_tool/components/custom_container.dart';
import 'package:stock_management_tool/components/custom_dropdown_input_field.dart';
import 'package:stock_management_tool/components/custom_elevated_button.dart';
import 'package:stock_management_tool/constants/constants.dart';
import 'package:stock_management_tool/features/locate_stock/presentation/widgets/custom_multiple_search_selection.dart';

class LocateStockInputRow extends StatelessWidget {
  LocateStockInputRow({
    super.key,
    required this.index,
    required this.locatedItems,
    required this.showRemoveButton,
    required this.removeOnTap,
    required this.onSearchBySelected,
    required this.onIdSelected,
    required this.overlayPortalController,
  });

  final List searchableIds = const [
    "Item Id",
    "Container Id",
    "Warehouse Location Id",
    "Custom Search",
  ];

  final int index;
  final List locatedItems;
  final bool showRemoveButton;
  final Function() removeOnTap;
  final Function(String) onSearchBySelected;
  final Function(List) onIdSelected;

  final OverlayPortalController overlayPortalController;
  final MultipleSearchController multipleSearchController = MultipleSearchController();
  final TextEditingController textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
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
                          ? GestureDetector(
                              onTap: removeOnTap,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(7),
                                  boxShadow: kBoxShadowList,
                                ),
                                child: const SizedBox(
                                  width: 30,
                                  height: 30,
                                  child: Icon(
                                    Icons.close_rounded,
                                    size: 26,
                                  ),
                                ),
                              ),
                            )
                          : const SizedBox(
                              width: 30,
                              height: 30,
                            ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: CustomDropdownInputField(
                        text: "Search By",
                        controller: TextEditingController(text: locatedItems[index]["search_by"]),
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
                    child: locatedItems[index]["search_by"] != ""
                        ? CustomElevatedButton(
                            onPressed: () {
                              overlayPortalController.toggle();
                            },
                            child: OverlayPortal(
                              controller: overlayPortalController,
                              overlayChildBuilder: overlayChildBuilder,
                              child: Text(
                                "Select ${locatedItems[index]["search_by"]}",
                                textAlign: TextAlign.center,
                                softWrap: false,
                                style: kButtonTextStyle,
                              ),
                            ),
                          )
                        : Container(),
                  ),
                ),
              ],
            ),
            if (locatedItems[index]["selected_ids"] != null &&
                locatedItems[index]["selected_ids"].isNotEmpty)
              Text(locatedItems[index]["selected_ids"].toString()),
          ],
        ),
      ),
    );
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
                          title: "Select ${locatedItems[index]["search_by"]}",
                          initialPickedItems: locatedItems[index]["selected_ids"] ?? [],
                          items: locatedItems[index]["all_ids"],
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
}
