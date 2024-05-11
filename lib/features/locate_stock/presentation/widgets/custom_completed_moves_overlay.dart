import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:stock_management_tool/components/custom_container.dart';
import 'package:stock_management_tool/constants/constants.dart';
import 'package:stock_management_tool/features/locate_stock/presentation/widgets/custom_overlay_effect.dart';
import 'package:stock_management_tool/helper/string_casting_extension.dart';

class CustomCompletedMovesOverlay extends StatelessWidget {
  const CustomCompletedMovesOverlay({
    super.key,
    required this.completedStateItems,
    required this.hideOverlay,
    required this.onExpand,
  });

  final List completedStateItems;
  final Function() hideOverlay;
  final Function(int, bool) onExpand;

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
                                "Recent Completed Items",
                                style: kLabelTextStyle,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: completedStateItems.length,
                          scrollDirection: Axis.vertical,
                          controller: ScrollController(),
                          physics: const BouncingScrollPhysics(),
                          shrinkWrap: true,
                          itemBuilder: (BuildContext context, int index) {
                            return GestureDetector(
                              onTap: () {
                                onExpand(index,
                                    !completedStateItems[index]["is_expanded"]);
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: kTertiaryBackgroundColor,
                                    borderRadius: kBorderRadius,
                                    boxShadow: kBoxShadowList,
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
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
                                              width: 50,
                                            ),
                                            Column(
                                              mainAxisSize: MainAxisSize.min,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  DateFormat(
                                                          'dd/MM/yyyy HH:mm:ss')
                                                      .format(DateTime.parse(
                                                          completedStateItems[
                                                                  index]["date"]
                                                              .toString()
                                                              .toUpperCase())),
                                                  style: kLabelTextStyle,
                                                ),
                                                Text(
                                                  completedStateItems[index]
                                                          ["container_id"]
                                                      .toString(),
                                                  style: kLabelTextStyle,
                                                ),
                                                Text(
                                                  completedStateItems[index][
                                                          "warehouse_location_id"]
                                                      .toString(),
                                                  style: kLabelTextStyle,
                                                ),
                                                Text(
                                                  completedStateItems[index]
                                                          ["staff"]
                                                      .toString()
                                                      .toTitleCase(),
                                                  style: kLabelTextStyle,
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        if (completedStateItems[index]
                                            ["is_expanded"])
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 10.0),
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  child: Container(
                                                    height: 100,
                                                    clipBehavior: Clip.hardEdge,
                                                    decoration: BoxDecoration(
                                                      color:
                                                          kTertiaryBackgroundColor,
                                                      borderRadius:
                                                          kBorderRadius,
                                                      boxShadow: kBoxShadowList,
                                                    ),
                                                    child:
                                                        SingleChildScrollView(
                                                      child: Wrap(
                                                        children:
                                                            completedStateItems[
                                                                        index]
                                                                    ["items"]
                                                                .map(
                                                                  (e) =>
                                                                      Padding(
                                                                    padding:
                                                                        const EdgeInsets
                                                                            .all(
                                                                            5.0),
                                                                    child:
                                                                        Container(
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        color:
                                                                            kSecondaryBackgroundColor,
                                                                        borderRadius:
                                                                            kBorderRadius,
                                                                        boxShadow:
                                                                            kBoxShadowList,
                                                                      ),
                                                                      child:
                                                                          Padding(
                                                                        padding: const EdgeInsets
                                                                            .all(
                                                                            5.0),
                                                                        child:
                                                                            Text(
                                                                          e,
                                                                          style:
                                                                              GoogleFonts.lato(
                                                                            textStyle:
                                                                                const TextStyle(
                                                                              fontSize: 15.0,
                                                                              fontWeight: FontWeight.w700,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                )
                                                                .toList()
                                                                .cast<Widget>(),
                                                      ),
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