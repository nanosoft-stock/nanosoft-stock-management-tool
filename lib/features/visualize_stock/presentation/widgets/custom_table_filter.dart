import 'package:flutter/material.dart';
import 'package:stock_management_tool/core/constants/constants.dart';
import 'package:stock_management_tool/core/helper/string_casting_extension.dart';
import 'package:stock_management_tool/features/visualize_stock/presentation/widgets/custom_icon_button.dart';

class CustomTableFilter extends StatelessWidget {
  const CustomTableFilter({
    super.key,
    required this.fields,
    required this.closeOnTap,
    required this.resetAllFiltersOnPressed,
    required this.fieldFilterOnPressed,
    required this.onReorder,
    required this.changeVisibilityOnTap,
  });

  final List fields;
  final Function() closeOnTap;
  final Function() resetAllFiltersOnPressed;
  final Function(String) fieldFilterOnPressed;
  final Function(List) onReorder;
  final Function(String, bool) changeVisibilityOnTap;

  @override
  Widget build(BuildContext context) {
    List localFieldFilters = List.from(fields);

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
                child: StatefulBuilder(
                  builder: (BuildContext context,
                      void Function(void Function()) setState) {
                    return ReorderableListView(
                      shrinkWrap: true,
                      physics: const BouncingScrollPhysics(),
                      proxyDecorator: (Widget child, int index,
                          Animation<double> animation) {
                        return child;
                      },
                      onReorder: (oldIndex, newIndex) {
                        setState(() {
                          if (oldIndex < newIndex) {
                            newIndex -= 1;
                          }
                          final item = localFieldFilters.removeAt(oldIndex);
                          localFieldFilters.insert(newIndex, item);
                        });
                        onReorder(localFieldFilters);
                      },
                      children: localFieldFilters
                          .map(
                            (field) => Padding(
                              key: Key(field),
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
                                      horizontal: 10.0, vertical: 7.5),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: GestureDetector(
                                          onTap: () {
                                            fieldFilterOnPressed(field);
                                          },
                                          child: Text(
                                            field.toString().toTitleCase(),
                                            style: kLabelTextStyle,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          )
                          .toList(),
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
