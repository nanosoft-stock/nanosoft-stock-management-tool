import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:stock_management_tool/core/components/custom_container.dart';
import 'package:stock_management_tool/core/constants/constants.dart';
import 'package:stock_management_tool/core/helper/string_casting_extension.dart';
import 'package:stock_management_tool/features/locate_stock/presentation/widgets/custom_icon_button.dart';
import 'package:stock_management_tool/features/locate_stock/presentation/widgets/custom_overlay_effect.dart';

class CustomPendingMovesOverlay extends StatelessWidget {
  const CustomPendingMovesOverlay({
    super.key,
    required this.pendingStateItems,
    required this.hideOverlay,
    required this.onExpand,
    required this.onCompleted,
    required this.onRemove,
  });

  final Map pendingStateItems;
  final Function() hideOverlay;
  final Function(int, int, bool) onExpand;
  final Function(int) onCompleted;
  final Function(int) onRemove;

  @override
  Widget build(BuildContext context) {
    List keys = pendingStateItems.keys.toList();

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
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Padding(
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
                                                    "User: ",
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
                                                    DateFormat(
                                                            'dd/MM/yyyy HH:mm:ss')
                                                        .format(DateTime.parse(
                                                            pendingStateItems[keys[
                                                                        index]]
                                                                    [0]["date"]
                                                                .toString()
                                                                .toUpperCase())),
                                                    style: kLabelTextStyle,
                                                  ),
                                                  Text(
                                                    pendingStateItems[
                                                                keys[index]][0]
                                                            ["user"]
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
                                    ListView.builder(
                                        itemCount:
                                            pendingStateItems[keys[index]]
                                                .length,
                                        scrollDirection: Axis.vertical,
                                        controller: ScrollController(),
                                        physics: const ClampingScrollPhysics(),
                                        shrinkWrap: true,
                                        itemBuilder:
                                            (BuildContext context, int i) {
                                          return Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                GestureDetector(
                                                  onTap: () {
                                                    onExpand(
                                                        index,
                                                        i,
                                                        !pendingStateItems[
                                                                keys[index]][i]
                                                            ["is_expanded"]);
                                                  },
                                                  child: Row(
                                                    children: [
                                                      Column(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            "Container Id: ",
                                                            style:
                                                                kLabelTextStyle,
                                                          ),
                                                          Text(
                                                            "WH Id: ",
                                                            style:
                                                                kLabelTextStyle,
                                                          ),
                                                        ],
                                                      ),
                                                      const SizedBox(
                                                        width: 10,
                                                      ),
                                                      Column(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            pendingStateItems[keys[
                                                                        index]][i]
                                                                    [
                                                                    "container_id"]
                                                                .toString(),
                                                            style:
                                                                kLabelTextStyle,
                                                          ),
                                                          Text(
                                                            pendingStateItems[keys[
                                                                        index]][i]
                                                                    [
                                                                    "warehouse_location_id"]
                                                                .toString(),
                                                            style:
                                                                kLabelTextStyle,
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                if (pendingStateItems[
                                                        keys[index]][i]
                                                    ["is_expanded"])
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 10.0),
                                                    child: Row(
                                                      children: [
                                                        Expanded(
                                                          child: Container(
                                                            height: 100,
                                                            clipBehavior:
                                                                Clip.hardEdge,
                                                            decoration:
                                                                BoxDecoration(
                                                              color:
                                                                  kTertiaryBackgroundColor,
                                                              borderRadius:
                                                                  kBorderRadius,
                                                              boxShadow:
                                                                  kBoxShadowList,
                                                            ),
                                                            child:
                                                                SingleChildScrollView(
                                                              child: Wrap(
                                                                children: pendingStateItems[
                                                                            keys[index]][i]
                                                                        [
                                                                        "items"]
                                                                    .map(
                                                                      (e) =>
                                                                          Padding(
                                                                        padding: const EdgeInsets
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
                                                                            padding:
                                                                                const EdgeInsets.all(5.0),
                                                                            child:
                                                                                Text(
                                                                              e,
                                                                              style: GoogleFonts.lato(
                                                                                textStyle: const TextStyle(
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
                                                                    .cast<
                                                                        Widget>(),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                              ],
                                            ),
                                          );
                                        }),
                                  ],
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
