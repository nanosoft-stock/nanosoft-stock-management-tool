import 'package:flutter/material.dart';
import 'package:stock_management_tool/core/constants/constants.dart';
import 'package:stock_management_tool/core/helper/string_casting_extension.dart';
import 'package:stock_management_tool/features/locate_stock/presentation/widgets/custom_icon_button.dart';

class CustomTableFilter extends StatelessWidget {
  const CustomTableFilter({
    super.key,
    required this.fieldFilters,
    required this.closeOnTap,
    required this.resetAllFiltersOnPressed,
    required this.fieldFilterOnPressed,
  });

  final List fieldFilters;
  final Function() closeOnTap;
  final Function() resetAllFiltersOnPressed;
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
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: kBorderRadius,
                  ),
                ),
                onPressed: () {
                  resetAllFiltersOnPressed();
                },
                child: Text(
                  "Reset",
                  style: kLabelTextStyle,
                ),
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
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    fieldFilterOnPressed(fieldFilters[index]);
                                  },
                                  child: Text(
                                    fieldFilters[index]
                                        .toString()
                                        .toTitleCase(),
                                    style: kLabelTextStyle,
                                  ),
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
