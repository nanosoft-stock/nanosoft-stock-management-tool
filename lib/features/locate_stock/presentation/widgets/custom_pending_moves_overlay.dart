import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:stock_management_tool/components/custom_container.dart';
import 'package:stock_management_tool/constants/constants.dart';
import 'package:stock_management_tool/features/locate_stock/presentation/widgets/custom_icon_button.dart';
import 'package:stock_management_tool/features/locate_stock/presentation/widgets/custom_overlay_effect.dart';
import 'package:stock_management_tool/helper/string_casting_extension.dart';

class CustomPendingMovesOverlay extends StatelessWidget {
  const CustomPendingMovesOverlay({
    super.key,
    required this.pendingStateItems,
    required this.hideOverlay,
    required this.onCompleted,
    required this.onRemove,
  });

  final List pendingStateItems;
  final Function() hideOverlay;
  final Function(int) onCompleted;
  final Function(int) onRemove;

  @override
  Widget build(BuildContext context) {
    return CustomOverlayEffect(
      hideOverlay: hideOverlay,
      child: SizedBox(
        width: 500,
        height: 600,
        child: CustomContainer(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Container(
              decoration: BoxDecoration(
                color: kPrimaryBackgroundColor,
                borderRadius: kBorderRadius,
              ),
              child: CustomContainer(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 5.0),
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: kButtonBackgroundColor,
                            borderRadius: kBorderRadius,
                            boxShadow: kBoxShadowList,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Center(
                              child: Text(
                                "Total Pending Moves: ${pendingStateItems.length}",
                                style: kLabelTextStyle,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: pendingStateItems.length,
                          scrollDirection: Axis.vertical,
                          controller: ScrollController(),
                          physics: const BouncingScrollPhysics(),
                          shrinkWrap: true,
                          itemBuilder: (BuildContext context, int index) {
                            return Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: kTertiaryBackgroundColor,
                                  borderRadius: kBorderRadius,
                                  boxShadow: kBoxShadowList,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Column(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Date: ",
                                                style: kLabelTextStyle,
                                              ),
                                              Text(
                                                "Container Id: ",
                                                style: kLabelTextStyle,
                                              ),
                                              Text(
                                                "WH Id: ",
                                                style: kLabelTextStyle,
                                              ),
                                              Text(
                                                "Staff: ",
                                                style: kLabelTextStyle,
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Column(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                DateFormat('dd/MM/yyyy HH:mm:ss')
                                                    .format(DateTime.parse(
                                                        pendingStateItems[index]
                                                                ["date"]
                                                            .toString()
                                                            .toUpperCase())),
                                                style: kLabelTextStyle,
                                              ),
                                              Text(
                                                pendingStateItems[index]
                                                        ["container_id"]
                                                    .toString(),
                                                style: kLabelTextStyle,
                                              ),
                                              Text(
                                                pendingStateItems[index][
                                                        "warehouse_location_id"]
                                                    .toString(),
                                                style: kLabelTextStyle,
                                              ),
                                              Text(
                                                pendingStateItems[index]
                                                        ["staff"]
                                                    .toString()
                                                    .toTitleCase(),
                                                style: kLabelTextStyle,
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          CustomIconButton(
                                            backgroundColor:
                                                kPassBackgroundColor,
                                            icon: Icon(
                                              Icons.check_rounded,
                                              color: kPassForegroundColor,
                                            ),
                                            onTap: () {
                                              onCompleted(index);
                                            },
                                          ),
                                          CustomIconButton(
                                            backgroundColor:
                                                kFailBackgroundColor,
                                            icon: Icon(
                                              Icons.close_rounded,
                                              color: kFailForegroundColor,
                                            ),
                                            onTap: () {
                                              onRemove(index);
                                            },
                                          ),
                                        ],
                                      ),
                                    ],
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
            ),
          ),
        ),
      ),
    );
  }
}
