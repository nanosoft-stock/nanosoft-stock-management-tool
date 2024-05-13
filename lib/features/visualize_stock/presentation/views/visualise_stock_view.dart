import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:stock_management_tool/components/custom_container.dart';
import 'package:stock_management_tool/constants/constants.dart';
import 'package:stock_management_tool/features/visualize_stock/presentation/bloc/visualize_stock_bloc.dart';
import 'package:stock_management_tool/features/visualize_stock/presentation/widgets/custom_sort_button.dart';
import 'package:stock_management_tool/helper/string_casting_extension.dart';
import 'package:stock_management_tool/injection_container.dart';
import 'package:two_dimensional_scrollables/two_dimensional_scrollables.dart';

class VisualiseStockView extends StatelessWidget {
  VisualiseStockView({super.key});

  final VisualizeStockBloc _visualizeStockBloc = sl.get<VisualizeStockBloc>();

  @override
  Widget build(BuildContext context) {
    return _buildBody();
  }

  Widget _buildBody() {
    return BlocConsumer<VisualizeStockBloc, VisualizeStockState>(
      bloc: _visualizeStockBloc,
      listenWhen: (prev, next) => next is VisualizeStockActionState,
      buildWhen: (prev, next) => next is! VisualizeStockActionState,
      listener: (context, state) {
        _blocListener(context, state);
      },
      builder: (context, state) {
        return _blocBuilder(context, state);
      },
    );
  }

  void _blocListener(BuildContext context, VisualizeStockState state) {
    debugPrint("listen: ${state.runtimeType}");
  }

  Widget _blocBuilder(BuildContext context, VisualizeStockState state) {
    debugPrint("build: ${state.runtimeType}");
    switch (state.runtimeType) {
      case const (LoadingState):
        _visualizeStockBloc.add(CloudDataChangeEvent());
        return _buildLoadingStateWidget();

      case const (ErrorState):
        return _buildErrorStateWidget();

      case const (LoadedState):
        Map visualizeStock = state.visualizeStock!;
        return _buildLoadedStateWidget(visualizeStock);

      default:
        return Container();
    }
  }

  Widget _buildLoadingStateWidget() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildErrorStateWidget() {
    return const Center(
      child: Text('Error'),
    );
  }

  Widget _buildLoadedStateWidget(Map visualizeStock) {
    List fields = visualizeStock["fields"];
    List stocks = visualizeStock["stocks"];
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return Stack(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(52, 5, 52, 40),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: CustomContainer(
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: kBorderRadius,
                                  ),
                                ),
                                onPressed: () {
                                  _visualizeStockBloc.add(
                                      ImportButtonClickedEvent(
                                          visualizeStock: visualizeStock));
                                },
                                child: Text(
                                  "Import Excel",
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
                                onPressed: () {
                                  _visualizeStockBloc.add(
                                      ExportButtonClickedEvent(
                                          visualizeStock: visualizeStock));
                                },
                                child: Text(
                                  "Export Table",
                                  style: kLabelTextStyle,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: CustomContainer(
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Container(
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
                                  columnCount: fields.length,
                                  rowCount: stocks.length + 1,
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
                                  cellBuilder: (BuildContext context,
                                      TableVicinity vicinity) {
                                    if (vicinity.row == 0) {
                                      return TableViewCell(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Text(
                                              fields[vicinity.column]
                                                  .field
                                                  .toString()
                                                  .toTitleCase(),
                                              style: GoogleFonts.lato(
                                                textStyle: const TextStyle(
                                                  fontSize: 15.0,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                            ),
                                            CustomSortButton(
                                              field: fields[vicinity.column]
                                                  .field
                                                  .toString(),
                                              sort:
                                                  fields[vicinity.column].sort,
                                              onPressed: (field, sort) {
                                                _visualizeStockBloc
                                                    .add(SortFieldEvent(
                                                  field: field,
                                                  sort: sort,
                                                  visualizeStock:
                                                      visualizeStock,
                                                ));
                                              },
                                            ),
                                          ],
                                        ),
                                      );
                                    } else {
                                      String text = (stocks[vicinity.row - 1][
                                                  fields[vicinity.column]
                                                      .field] ??
                                              "")
                                          .toString();
                                      if (vicinity.column == 0) {
                                        text = DateFormat('dd-MM-yyyy').format(
                                            DateTime.parse(text.toUpperCase()));
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
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 87, 0, 50),
                child: SizedBox(
                  width: constraints.maxWidth / 3,
                  height: double.infinity,
                  child: Container(
                    decoration: BoxDecoration(
                      color: kSecondaryBackgroundColor,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(10.0),
                        bottomLeft: Radius.circular(10.0),
                      ),
                      boxShadow: kBoxShadowList,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: CustomContainer(
                        child: Container(
                          decoration: BoxDecoration(
                            color: kPrimaryBackgroundColor,
                            borderRadius: kBorderRadius,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Column(
                              children: [
                                Text(
                                  "Field",
                                  style: kLabelTextStyle,
                                ),
                                Divider(),
                                Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Row(
                                    children: [
                                      Icon(Icons.swap_vert_outlined),
                                      Text(
                                        "Sort",
                                        style: kLabelTextStyle,
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: kBorderRadius,
                                          ),
                                        ),
                                        onPressed: () {},
                                        child: Text(
                                          "Ascending",
                                          style: kLabelTextStyle,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 15,
                                      ),
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: kBorderRadius,
                                          ),
                                        ),
                                        onPressed: () {},
                                        child: Text(
                                          "Descending",
                                          style: kLabelTextStyle,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Divider(),
                                Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Row(
                                    children: [
                                      Icon(Icons.filter_alt_outlined),
                                      Text(
                                        "Filter",
                                        style: kLabelTextStyle,
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Row(
                                    children: [
                                      // Container(
                                      //   decoration: BoxDecoration(
                                      //     borderRadius: kBorderRadius,
                                      //     boxShadow: kBoxShadowList,
                                      //   ),
                                      //   child: CustomDropdownMenu(
                                      //     controller: TextEditingController(),
                                      //     items: const [
                                      //       "Equals",
                                      //       "Not Equals",
                                      //       "Begins With",
                                      //       "Not Begins With",
                                      //       "Contains",
                                      //       "Not Contains",
                                      //       "Ends With",
                                      //       "Not Ends With",
                                      //     ],
                                      //     requestFocusOnTap: false,
                                      //     onSelected: (value) {},
                                      //   ),
                                      // ),
                                      // Container(
                                      //   decoration: BoxDecoration(
                                      //     color: kTertiaryBackgroundColor,
                                      //     borderRadius:
                                      //         BorderRadius.circular(7.0),
                                      //     boxShadow: kBoxShadowList,
                                      //   ),
                                      //   child: DropdownMenu(
                                      //     controller: TextEditingController(),
                                      //     requestFocusOnTap: false,
                                      //     menuHeight: 250,
                                      //     dropdownMenuEntries: [
                                      //       "Equals",
                                      //       "Not Equals",
                                      //       "Begins With",
                                      //       "Not Begins With",
                                      //       "Contains",
                                      //       "Not Contains",
                                      //       "Ends With",
                                      //       "Not Ends With",
                                      //     ]
                                      //         .map((e) => DropdownMenuEntry(
                                      //             value: e.toLowerCase(),
                                      //             label: e))
                                      //         .toList(),
                                      //     onSelected: (value) {},
                                      //   ),
                                      // ),
                                      Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(),
                                          borderRadius:
                                              BorderRadius.circular(5.0),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 7.0,
                                            vertical: 10.0,
                                          ),
                                          child: DropdownButton(
                                            autofocus: false,
                                            borderRadius: kBorderRadius,
                                            hint: Text(
                                              "Select Filter",
                                              style: kLabelTextStyle,
                                            ),
                                            menuMaxHeight: 250,
                                            isDense: true,
                                            icon: Icon(
                                                Icons.arrow_drop_down_outlined),
                                            underline: Container(),
                                            items: [
                                              "Equals",
                                              "Not Equals",
                                              "Begins With",
                                              "Not Begins With",
                                              "Contains",
                                              "Not Contains",
                                              "Ends With",
                                              "Not Ends With",
                                            ]
                                                .map(
                                                  (e) => DropdownMenuItem(
                                                    value: e,
                                                    child: Text(
                                                      e,
                                                      style: kLabelTextStyle,
                                                    ),
                                                  ),
                                                )
                                                .toList(),
                                            onChanged: (value) {},
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                // Row(
                                //   children: [
                                //     Text(
                                //       "Equals",
                                //       style: kLabelTextStyle,
                                //     ),
                                //   ],
                                // ),
                                // Row(
                                //   children: [
                                //     Text(
                                //       "Not Equals",
                                //       style: kLabelTextStyle,
                                //     ),
                                //   ],
                                // ),
                                // Row(
                                //   children: [
                                //     Text(
                                //       "Begins With",
                                //       style: kLabelTextStyle,
                                //     ),
                                //   ],
                                // ),
                                // Row(
                                //   children: [
                                //     Text(
                                //       "Not Begins With",
                                //       style: kLabelTextStyle,
                                //     ),
                                //   ],
                                // ),
                                // Row(
                                //   children: [
                                //     Text(
                                //       "Contains",
                                //       style: kLabelTextStyle,
                                //     ),
                                //   ],
                                // ),
                                // Row(
                                //   children: [
                                //     Text(
                                //       "Not Contains",
                                //       style: kLabelTextStyle,
                                //     ),
                                //   ],
                                // ),
                                // Row(
                                //   children: [
                                //     Text(
                                //       "Ends With",
                                //       style: kLabelTextStyle,
                                //     ),
                                //   ],
                                // ),
                                // Row(
                                //   children: [
                                //     Text(
                                //       "Not Ends With",
                                //       style: kLabelTextStyle,
                                //     ),
                                //   ],
                                // ),
                                Divider(),
                                Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Row(
                                    children: [
                                      Icon(Icons.search_outlined),
                                      Text(
                                        "Search",
                                        style: kLabelTextStyle,
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: kTertiaryBackgroundColor,
                                        borderRadius: kBorderRadius,
                                        boxShadow: kBoxShadowList,
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
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
                                      SizedBox(
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
                                          "Clear",
                                          style: kLabelTextStyle,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            // // Filter Menu
            // Padding(
            //   padding: const EdgeInsets.fromLTRB(52, 103, 0, 40),
            //   child: CustomContainer(
            //     child: SizedBox(
            //       width: constraints.maxWidth / 3,
            //       child: Column(
            //         children: [
            //           Text("Sort And Filter"),
            //           Text("Sort A to Z"),
            //           Text("Sort Z to A"),
            //           ExpansionTile(
            //             initiallyExpanded: true,
            //             title: Text("Show Column by Category"),
            //           ),
            //           ExpansionTile(
            //             title: Text("Contains"),
            //           ),
            //         ],
            //       ),
            //     ),
            //   ),
            // ),
          ],
        );
      },
    );
  }
}
