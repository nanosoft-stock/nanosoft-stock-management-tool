import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:stock_management_tool/components/custom_container.dart';
import 'package:stock_management_tool/components/custom_dropdown_input_field.dart';
import 'package:stock_management_tool/components/custom_elevated_button.dart';
import 'package:stock_management_tool/constants/constants.dart';

class CustomPreviewMoveOverlayEntry extends StatelessWidget {
  const CustomPreviewMoveOverlayEntry({
    super.key,
    required this.selectedItems,
    required this.hideOverlay,
    required this.onContainerIdEntered,
    required this.onWarehouseLocationIdEntered,
    required this.onMoveItemsTap,
  });

  final Map selectedItems;
  final Function() hideOverlay;
  final Function(String) onContainerIdEntered;
  final Function(String) onWarehouseLocationIdEntered;
  final Function() onMoveItemsTap;

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
                  width: 675,
                  height: 360,
                  child: CustomContainer(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Container(
                        color: kPrimaryBackgroundColor,
                        child: CustomContainer(
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: SizedBox(
                              width: 400,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: SizedBox(
                                      width: 200,
                                      height: 300,
                                      child: Column(
                                        // mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(4.0),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: kButtonBackgroundColor,
                                                borderRadius: kBorderRadius,
                                                boxShadow: kBoxShadowList,
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Center(
                                                  child: Text(
                                                      "Item Total:  ${selectedItems["items"].length}",
                                                      style: kLabelTextStyle
                                                      //         .copyWith(
                                                      //   color: kButtonTextColor,
                                                      // ),
                                                      ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: ListView.builder(
                                              itemCount:
                                                  selectedItems["items"].length,
                                              scrollDirection: Axis.vertical,
                                              controller: ScrollController(),
                                              physics:
                                                  const BouncingScrollPhysics(),
                                              shrinkWrap: true,
                                              itemBuilder:
                                                  (BuildContext context,
                                                      int index) {
                                                return Padding(
                                                  padding:
                                                      const EdgeInsets.all(4.0),
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      color:
                                                          kTertiaryBackgroundColor,
                                                      borderRadius:
                                                          kBorderRadius,
                                                      boxShadow: kBoxShadowList,
                                                    ),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Center(
                                                        child: Text(
                                                            "Item Id:   ${selectedItems["items"][index]["item_id"]}",
                                                            style:
                                                                kLabelTextStyle
                                                            //     .copyWith(
                                                            //   color:
                                                            //       kButtonTextColor,
                                                            // ),
                                                            ),
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: SizedBox(
                                            width: 330.0,
                                            child: CustomDropdownInputField(
                                              text: "Container Id",
                                              controller: TextEditingController(
                                                  text: selectedItems[
                                                      "container_text"]),
                                              items: selectedItems[
                                                  "container_ids"],
                                              onSelected: (value) {
                                                onContainerIdEntered(value);
                                              },
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: SizedBox(
                                            width: 330.0,
                                            child: CustomDropdownInputField(
                                              text: "Warehouse Location Id",
                                              controller: TextEditingController(
                                                  text: selectedItems[
                                                      "warehouse_location_text"]),
                                              items: selectedItems[
                                                  "warehouse_location_ids"],
                                              onSelected: (value) {
                                                onWarehouseLocationIdEntered(
                                                    value);
                                              },
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 15),
                                        Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: SizedBox(
                                            width: 330.0,
                                            child: CustomElevatedButton(
                                              onPressed: () {
                                                onMoveItemsTap();
                                              },
                                              text: "Move Items",
                                            ),
                                          ),
                                        ),
                                      ],
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
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
