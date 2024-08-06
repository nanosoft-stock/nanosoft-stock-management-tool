import 'package:flutter/material.dart';
import 'package:material_table_view/material_table_view.dart';
import 'package:stock_management_tool/core/constants/constants.dart';
import 'package:stock_management_tool/core/constants/enums.dart';
import 'package:stock_management_tool/features/visualize_stock/presentation/widgets/custom_border.dart';

class CustomTableView extends StatelessWidget {
  const CustomTableView({
    super.key,
    required this.fields,
    required this.stocks,
    required this.filters,
    required this.sortOnPressed,
    required this.filterOnPressed,
  });

  final List fields;
  final List stocks;
  final Map filters;
  final Function(String, Sort) sortOnPressed;
  final Function(String) filterOnPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: kTertiaryBackgroundColor,
        borderRadius: kBorderRadius,
        boxShadow: kBoxShadowList,
        border: Border.all(width: 1),
      ),
      child: ClipRRect(
        borderRadius: kBorderRadius,
        child: SelectionArea(
          child: TableView.builder(
            controller: TableViewController(),
            rowCount: stocks.length,
            rowHeight: 25.0,
            columns: [
              const TableColumn(
                width: 100.0,
                minResizeWidth: 50,
                maxResizeWidth: 300,
              ),
              for (int i = 0; i < fields.length; i++)
                const TableColumn(
                  width: 150.0,
                  minResizeWidth: 50,
                  maxResizeWidth: 300,
                ),
            ],
            headerBuilder: (BuildContext context,
                Widget Function(
                        BuildContext, Widget Function(BuildContext, int))
                    contentBuilder) {
              return contentBuilder(
                context,
                (BuildContext context, int index) {
                  if (index == 0) {
                    return const SizedBox.shrink();
                  } else {
                    String name = fields[index - 1]["name"];

                    return CustomBorder(
                      child: Text(
                        name,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.fade,
                        softWrap: false,
                        style: kTableHeaderTextStyle,
                      ),
                    );
                  }
                },
              );
            },
            rowBuilder: (
              BuildContext context,
              int row,
              Widget Function(BuildContext, Widget Function(BuildContext, int))
                  contentBuilder,
            ) {
              return contentBuilder(
                context,
                (BuildContext context, int column) {
                  if (column == 0) {
                    return CustomBorder(
                      child: Text(
                        (row + 1).toString(),
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.fade,
                        softWrap: false,
                        style: kTableHeaderTextStyle,
                      ),
                    );
                  } else {
                    String text =
                        stocks[row][fields[column - 1]["field"]] ?? "";

                    return CustomBorder(
                      child: text != ""
                          ? Text(
                              text,
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.fade,
                              softWrap: false,
                              style: kTableValueTextStyle,
                            )
                          : const SizedBox.shrink(),
                    );
                  }
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
