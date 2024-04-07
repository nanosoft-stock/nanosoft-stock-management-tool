import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:stock_management_tool/components/custom_elevated_button.dart';
import 'package:stock_management_tool/components/field_sort_widget.dart';
import 'package:stock_management_tool/constants/constants.dart';
import 'package:stock_management_tool/helper/string_casting_extension.dart';
import 'package:stock_management_tool/injection_container.dart';
import 'package:stock_management_tool/models/all_predefined_data.dart';
import 'package:stock_management_tool/providers/export_stock_provider.dart';
import 'package:stock_management_tool/services/firestore_rest_api.dart';
import 'package:two_dimensional_scrollables/two_dimensional_scrollables.dart';

class CustomDataGrid extends StatelessWidget {
  const CustomDataGrid({super.key});

  Future<void> fetchData({required var provider}) async {
    Set fields = {};
    for (String category in AllPredefinedData.data["categories"]) {
      fields.addAll(AllPredefinedData.data[category]["fields"].map((e) => e["field"]));
    }

    print(fields);

    List fieldsList = fields
        .map((e) => {
              "field": e,
              "sort": Sort.none,
              "widget": FieldSortWidget(
                field: e,
                sort: Sort.none,
              ),
            })
        .toList();

    List stock = [];
    stock = (await sl.get<FirestoreRestApi>().getDocuments(path: "stock_data", includeDocRef: true)).data;

    stock = stock
        .map((element) => element
            .map((field, value) => MapEntry(field, value.values.first))
            .cast<String, dynamic>())
        .toList();

    stock.sort((a, b) => a["date"].compareTo(b["date"]));

    provider.setFields(fields: fieldsList);
    provider.setStock(stock: stock);
    provider.setShowTable(showTable: true);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ExportStockProvider>(
      builder: (BuildContext context, provider, Widget? child) {
        return LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            return !provider.showTable
                ? Center(
                    child: Container(
                      decoration: BoxDecoration(
                        color: kSecondaryBackgroundColor,
                        borderRadius: kBorderRadius,
                        boxShadow: kBoxShadowList,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 15.0,
                          horizontal: 22.5,
                        ),
                        child: SizedBox(
                          width: 338,
                          child: CustomElevatedButton(
                            text: "Show Table",
                            onPressed: () async {
                              await fetchData(provider: provider);
                              print("${provider.fields.length} ${provider.fields}");
                              print("${provider.stock.length} ${provider.stock}");
                            },
                          ),
                        ),
                      ),
                    ),
                  )
                : Container(
                    decoration: BoxDecoration(
                      color: kTertiaryBackgroundColor,
                      borderRadius: kBorderRadius,
                      boxShadow: kBoxShadowList,
                      border: Border.all(width: 2),
                    ),
                    clipBehavior: Clip.hardEdge,
                    child: GestureDetector(
                      child: TableView(
                        delegate: TableCellBuilderDelegate(
                          columnCount: provider.fields.length,
                          rowCount: provider.stock.length + 1,
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
                              extent: FixedTableSpanExtent(25),
                            );
                          },
                          cellBuilder: (BuildContext context, TableVicinity vicinity) {
                            if (vicinity.row == 0) {
                              return TableViewCell(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text(
                                      provider.fields[vicinity.column]["field"]
                                          .toString()
                                          .toTitleCase(),
                                      style: GoogleFonts.lato(
                                        textStyle: const TextStyle(
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                    FieldSortWidget(
                                      field: provider.fields[vicinity.column]["field"],
                                      sort: provider.fields[vicinity.column]["sort"],
                                    ),
                                  ],
                                ),
                              );
                            } else {
                              String text = (provider.stock[vicinity.row - 1]
                                          [provider.fields[vicinity.column]["field"]] ??
                                      "")
                                  .toString()
                                  .toTitleCase();
                              if (vicinity.column == 0) {
                                text = DateFormat('dd-MM-yyyy HH:mm:ss')
                                    .format(DateTime.parse(text.toUpperCase()));
                              }
                              return TableViewCell(
                                child: Center(
                                  child: Text(
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
          },
        );
      },
    );
  }
}
