import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stock_management_tool/core/constants/constants.dart';
import 'package:stock_management_tool/core/constants/enums.dart';
import 'package:stock_management_tool/core/helper/string_casting_extension.dart';
import 'package:stock_management_tool/features/locate_stock/presentation/widgets/custom_checkbox.dart';
import 'package:two_dimensional_scrollables/two_dimensional_scrollables.dart';

class CustomItemDetailsTableView extends StatelessWidget {
  const CustomItemDetailsTableView({
    super.key,
    required this.items,
    required this.searchBy,
    required this.viewMode,
    required this.constraints,
    required this.onCheckBoxToggled,
    required this.onAllCheckBoxToggled,
  });

  final List items;
  final String searchBy;
  final StockViewMode viewMode;
  final BoxConstraints constraints;
  final Function(String, CheckBoxState) onCheckBoxToggled;
  final Function(CheckBoxState) onAllCheckBoxToggled;

  final List<String> itemColumns = const [
    "Select",
    "Item Id",
    "Container Id",
    "Warehouse Location",
  ];

  final List<String> containerColumns = const [
    "Select",
    "Item Quantity",
    "Container Id",
    "Warehouse Location",
  ];

  final List<String> warehouseColumns = const [
    "Select",
    "Item Quantity",
    "Container Quantity",
    "Warehouse Location",
  ];

  @override
  Widget build(BuildContext context) {
    List<String> columns = [];

    if (viewMode == StockViewMode.item) columns = itemColumns;
    if (viewMode == StockViewMode.container) columns = containerColumns;
    if (viewMode == StockViewMode.warehouse) columns = warehouseColumns;

    double pad = 15.0;
    if (constraints.maxWidth > 834 + 130) {
      pad = (constraints.maxWidth - 834 + 130) / 2;
    }

    return Padding(
      padding: EdgeInsets.fromLTRB(pad, 15.0, pad, 0),
      child: Container(
        height: (items.length > 7 ? 8 : items.length + 1) * 30.5,
        decoration: BoxDecoration(
          color: kTertiaryBackgroundColor,
          borderRadius: kBorderRadius,
          boxShadow: kBoxShadowList,
          border: Border.all(width: 2),
        ),
        clipBehavior: Clip.hardEdge,
        child: TableView(
          horizontalDetails: const ScrollableDetails.horizontal(
            physics: ClampingScrollPhysics(),
          ),
          verticalDetails: const ScrollableDetails.vertical(
            physics: BouncingScrollPhysics(),
          ),
          delegate: TableCellBuilderDelegate(
            columnCount: columns.length,
            rowCount: items.length + 1,
            pinnedRowCount: 1,
            columnBuilder: (int index) {
              return TableSpan(
                backgroundDecoration: const TableSpanDecoration(
                  border: TableSpanBorder(
                    leading: BorderSide(
                      color: Colors.black54,
                    ),
                    trailing: BorderSide(
                      color: Colors.black54,
                    ),
                  ),
                ),
                extent: FixedTableSpanExtent(index == 0 ? 70 : 200),
              );
            },
            rowBuilder: (int index) {
              return const TableSpan(
                backgroundDecoration: TableSpanDecoration(
                  border: TableSpanBorder(
                    leading: BorderSide(
                      color: Colors.black54,
                    ),
                    trailing: BorderSide(
                      color: Colors.black54,
                    ),
                  ),
                ),
                extent: FixedTableSpanExtent(30),
              );
            },
            cellBuilder: (BuildContext context, TableVicinity vicinity) {
              if (vicinity.row == 0) {
                return TableViewCell(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      columns[vicinity.column] != "Select"
                          ? Text(
                              columns[vicinity.column].toTitleCase(),
                              style: GoogleFonts.lato(
                                textStyle: const TextStyle(
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            )
                          : CustomCheckbox(
                              locked: items.every((element) =>
                                  element["state"] == CheckBoxState.all),
                              partial: items.any((element) =>
                                      element["state"] == CheckBoxState.all ||
                                      element["state"] ==
                                          CheckBoxState.partial) &&
                                  !items.every((element) =>
                                      element["state"] == CheckBoxState.all),
                              onChecked: () {
                                CheckBoxState state;

                                if (items.every((element) => [
                                      CheckBoxState.empty,
                                      CheckBoxState.partial
                                    ].contains(element["state"]))) {
                                  state = CheckBoxState.all;
                                } else {
                                  state = CheckBoxState.empty;
                                }

                                onAllCheckBoxToggled(state);
                              },
                            ),
                    ],
                  ),
                );
              } else {
                Map item = (items[vicinity.row - 1]);
                if (vicinity.column == 0) {
                  return TableViewCell(
                    child: Center(
                      child: CustomCheckbox(
                        locked: item["state"] != CheckBoxState.empty,
                        partial: item["state"] == CheckBoxState.partial,
                        onChecked: () {
                          String id = "";
                          if (viewMode == StockViewMode.item) {
                            id = item["item_id"];
                          } else if (viewMode == StockViewMode.container) {
                            id = item["container_id"];
                          } else if (viewMode == StockViewMode.warehouse) {
                            id = item["warehouse_location_id"];
                          }

                          CheckBoxState state;
                          if (item["state"] != CheckBoxState.all) {
                            state = CheckBoxState.all;
                          } else {
                            state = CheckBoxState.empty;
                          }

                          onCheckBoxToggled(id, state);
                        },
                      ),
                    ),
                  );
                }

                String text = "";
                if (vicinity.column == 1) {
                  text = viewMode == StockViewMode.item
                      ? item["item_id"]
                      : item["item_quantity"];
                }
                if (vicinity.column == 2) {
                  text = viewMode != StockViewMode.warehouse
                      ? item["container_id"]
                      : item["container_quantity"];
                }
                if (vicinity.column == 3) {
                  text = item["warehouse_location_id"];
                }

                return TableViewCell(
                  child: Center(
                    child: SelectableText(
                      text,
                      style: GoogleFonts.lato(),
                    ),
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
