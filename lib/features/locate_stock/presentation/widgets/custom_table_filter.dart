import 'package:flutter/material.dart';
import 'package:stock_management_tool/constants/constants.dart';
import 'package:stock_management_tool/features/visualize_stock/presentation/widgets/custom_icon_button.dart';
import 'package:stock_management_tool/helper/string_casting_extension.dart';

class CustomTableFilter extends StatelessWidget {
  const CustomTableFilter({
    super.key,
    required this.fieldFilters,
    required this.closeOnTap,
    required this.fieldFilterOnPressed,
  });

  final List fieldFilters;
  final Function() closeOnTap;
  final Function(String) fieldFilterOnPressed;

  @override
  Widget build(BuildContext context) {
    return Column(
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
                "All Filters",
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
                      "Reset",
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
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  itemCount: fieldFilters.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 3.0, vertical: 4.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: kTertiaryBackgroundColor,
                          // index % 2 == 0
                          //     ? kTertiaryBackgroundColor
                          //     : kButtonBackgroundColor,
                          borderRadius: kBorderRadius,
                          boxShadow: kBoxShadowList,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 6.0),
                          child: Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  fieldFilterOnPressed(
                                      fieldFilters[index]["field"]);
                                },
                                child: Text(
                                  fieldFilters[index]["field"]
                                      .toString()
                                      .toTitleCase(),
                                  style: kLabelTextStyle,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
