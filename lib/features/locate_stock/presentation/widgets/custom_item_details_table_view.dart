import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stock_management_tool/components/custom_checkbox.dart';
import 'package:stock_management_tool/constants/constants.dart';
import 'package:stock_management_tool/constants/enums.dart';
import 'package:stock_management_tool/helper/string_casting_extension.dart';
import 'package:two_dimensional_scrollables/two_dimensional_scrollables.dart';

class CustomItemDetailsTableView extends StatelessWidget {
  const CustomItemDetailsTableView({
    super.key,
    required this.items,
    required this.searchBy,
    this.showDetails = true,
    required this.constraints,
    required this.onCheckBoxToggled,
    required this.onAllCheckBoxToggled,
  });

  final List items;
  final String searchBy;
  final bool showDetails;
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
    List<String> columns = searchBy == "Container Id" ? containerColumns : warehouseColumns;
    columns = showDetails ? itemColumns : columns;

    double pad = 15.0;
    if (constraints.maxWidth > 834) {
      pad = (constraints.maxWidth - 834) / 2;
    }

    return Padding(
      padding: EdgeInsets.fromLTRB(pad, 15.0, pad, 0),
      child: Container(
        height: (items.length > 5 ? 6 : items.length + 1) * 43.0,
        decoration: BoxDecoration(
          color: kTertiaryBackgroundColor,
          borderRadius: kBorderRadius,
          boxShadow: kBoxShadowList,
          border: Border.all(width: 2),
        ),
        clipBehavior: Clip.hardEdge,
        child: TableView(
          delegate: TableCellBuilderDelegate(
            columnCount: columns.length,
            rowCount: items.length + 1,
            pinnedRowCount: 1,
            columnBuilder: (int index) {
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
                extent: FixedTableSpanExtent(200),
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
                extent: FixedTableSpanExtent(43),
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
                              locked: items
                                  .every((element) => element["is_selected"] == CheckBoxState.all),
                              partial: items.any(
                                      (element) => element["is_selected"] == CheckBoxState.all) &&
                                  !items.every(
                                      (element) => element["is_selected"] == CheckBoxState.all),
                              onChecked: () {
                                CheckBoxState state;

                                if (items.every((element) => [
                                      CheckBoxState.empty,
                                      CheckBoxState.partial
                                    ].contains(element["is_selected"]))) {
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
                  bool locked =
                      [CheckBoxState.all, CheckBoxState.partial].contains(item["is_selected"]);
                  bool partial = item["is_selected"] == CheckBoxState.partial;

                  return TableViewCell(
                    child: Center(
                      child: CustomCheckbox(
                        locked: locked,
                        partial: partial,
                        onChecked: () {
                          String id = "";
                          if (showDetails == true) {
                            id = item["id"];
                          } else if (searchBy == "Container Id") {
                            id = item["container_id"];
                          } else if (searchBy == "Warehouse Location Id") {
                            id = item["warehouse_location_id"];
                          }

                          CheckBoxState state;
                          if ([CheckBoxState.empty, CheckBoxState.partial]
                              .contains(item["is_selected"])) {
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
                  text = showDetails ? item["id"] : item["item_quantity"].toString();
                }
                if (vicinity.column == 2) {
                  if (searchBy != "Warehouse Location Id") {
                    text = item["container_id"];
                  } else {
                    text =
                        showDetails ? item["container_id"] : item["container_quantity"].toString();
                  }
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
