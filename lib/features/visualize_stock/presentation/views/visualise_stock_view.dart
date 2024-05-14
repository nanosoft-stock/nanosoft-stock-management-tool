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
              padding: const EdgeInsets.fromLTRB(52, 52, 52, 40),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: CustomContainer(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: kInputFieldFillColor,
                            borderRadius: kBorderRadius,
                            boxShadow: kBoxShadowList,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(7.0),
                                    ),
                                  ),
                                  onPressed: () {},
                                  child: Text(
                                    "Filter",
                                    style: kLabelTextStyle,
                                  ),
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(7.0),
                                        ),
                                      ),
                                      onPressed: () {
                                        _visualizeStockBloc.add(
                                            ImportButtonClickedEvent(
                                                visualizeStock:
                                                    visualizeStock));
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
                                          borderRadius: BorderRadius.circular(7.0),
                                        ),
                                      ),
                                      onPressed: () {
                                        _visualizeStockBloc.add(
                                            ExportButtonClickedEvent(
                                                visualizeStock:
                                                    visualizeStock));
                                      },
                                      child: Text(
                                        "Export Table",
                                        style: kLabelTextStyle,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 10.0),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: kTertiaryBackgroundColor,
                              borderRadius: kBorderRadius,
                              boxShadow: kBoxShadowList,
                              border: Border.all(width: 1),
                            ),
                            child: ClipRRect(
                              borderRadius: kBorderRadius,
                              clipBehavior: Clip.hardEdge,
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
                      ],
                    ),
                  ),
                ),
              ),
            ),
            // Align(
            //   alignment: Alignment.centerRight,
            //   child: Padding(
            //     padding: const EdgeInsets.fromLTRB(0, 62, 0, 50),
            //     child: SizedBox(
            //       width: constraints.maxWidth / 3,
            //       height: double.infinity,
            //       child: Container(
            //         decoration: BoxDecoration(
            //           color: kSecondaryBackgroundColor,
            //           borderRadius: const BorderRadius.only(
            //             topLeft: Radius.circular(10.0),
            //             bottomLeft: Radius.circular(10.0),
            //           ),
            //           boxShadow: kBoxShadowList,
            //         ),
            //         child: Padding(
            //           padding: const EdgeInsets.all(20.0),
            //           child: CustomContainer(
            //             child: Container(
            //               decoration: BoxDecoration(
            //                 color: kPrimaryBackgroundColor,
            //                 borderRadius: kBorderRadius,
            //               ),
            //               child: Padding(
            //                 padding: const EdgeInsets.all(15.0),
            //                 child: Column(
            //                   children: [
            //                     Padding(
            //                       padding: const EdgeInsets.all(5.0),
            //                       child: Row(
            //                         mainAxisAlignment:
            //                             MainAxisAlignment.spaceBetween,
            //                         children: [
            //                           Text(
            //                             "Field",
            //                             style: kLabelTextStyle,
            //                           ),
            //                           Row(
            //                             mainAxisSize: MainAxisSize.min,
            //                             children: [
            //                               ElevatedButton(
            //                                 style: ElevatedButton.styleFrom(
            //                                   shape: RoundedRectangleBorder(
            //                                     borderRadius: kBorderRadius,
            //                                   ),
            //                                 ),
            //                                 onPressed: () {},
            //                                 child: Text(
            //                                   "Filter",
            //                                   style: kLabelTextStyle,
            //                                 ),
            //                               ),
            //                               SizedBox(
            //                                 width: 10,
            //                               ),
            //                               ElevatedButton(
            //                                 style: ElevatedButton.styleFrom(
            //                                   shape: RoundedRectangleBorder(
            //                                     borderRadius: kBorderRadius,
            //                                   ),
            //                                 ),
            //                                 onPressed: () {},
            //                                 child: Text(
            //                                   "Clear",
            //                                   style: kLabelTextStyle,
            //                                 ),
            //                               ),
            //                             ],
            //                           ),
            //                         ],
            //                       ),
            //                     ),
            //                     Divider(),
            //                     Expanded(
            //                       child: Padding(
            //                         padding: const EdgeInsets.symmetric(
            //                             horizontal: 5.0),
            //                         child: ClipRRect(
            //                           borderRadius: kBorderRadius,
            //                           clipBehavior: Clip.antiAliasWithSaveLayer,
            //                           child: SingleChildScrollView(
            //                             physics: BouncingScrollPhysics(),
            //                             child: Column(
            //                               children: [
            //                                 Padding(
            //                                   padding:
            //                                       const EdgeInsets.symmetric(
            //                                     vertical: 5.0,
            //                                   ),
            //                                   child: Row(
            //                                     children: [
            //                                       // Icon(Icons.table_chart_outlined),
            //                                       Icon(Icons
            //                                           .table_rows_outlined),
            //                                       SizedBox(
            //                                         width: 5,
            //                                       ),
            //                                       Text(
            //                                         "Show/Hide Column",
            //                                         style: kLabelTextStyle,
            //                                       ),
            //                                     ],
            //                                   ),
            //                                 ),
            //                                 Padding(
            //                                   padding:
            //                                       const EdgeInsets.symmetric(
            //                                           vertical: 5.0),
            //                                   child: SegmentedButton(
            //                                     segments: [
            //                                       ButtonSegment(
            //                                         value: true,
            //                                         icon: Icon(Icons
            //                                             .table_rows_rounded),
            //                                         label: Text(
            //                                           "Show",
            //                                           style: kLabelTextStyle,
            //                                         ),
            //                                       ),
            //                                       ButtonSegment(
            //                                         value: false,
            //                                         icon: Icon(Icons
            //                                             .playlist_remove_rounded),
            //                                         label: Text(
            //                                           "Hide",
            //                                           style: kLabelTextStyle,
            //                                         ),
            //                                       ),
            //                                     ],
            //                                     showSelectedIcon: false,
            //                                     selected: {true},
            //                                     selectedIcon:
            //                                         const SizedBox.shrink(),
            //                                     style: ButtonStyle(
            //                                       shape: MaterialStateProperty
            //                                           .all<OutlinedBorder>(
            //                                         RoundedRectangleBorder(
            //                                           borderRadius:
            //                                               kBorderRadius,
            //                                         ),
            //                                       ),
            //                                     ),
            //                                     onSelectionChanged: (value) {},
            //                                   ),
            //                                 ),
            //                                 Divider(),
            //                                 Padding(
            //                                   padding:
            //                                       const EdgeInsets.symmetric(
            //                                           vertical: 5.0),
            //                                   child: Row(
            //                                     children: [
            //                                       Icon(
            //                                           Icons.swap_vert_outlined),
            //                                       SizedBox(
            //                                         width: 5,
            //                                       ),
            //                                       Text(
            //                                         "Sort",
            //                                         style: kLabelTextStyle,
            //                                       ),
            //                                     ],
            //                                   ),
            //                                 ),
            //                                 Padding(
            //                                   padding:
            //                                       const EdgeInsets.all(5.0),
            //                                   child: SegmentedButton(
            //                                     segments: [
            //                                       ButtonSegment(
            //                                         value: Sort.asc,
            //                                         icon: Icon(Icons
            //                                             .arrow_downward_rounded),
            //                                         label: Text(
            //                                           "Ascending",
            //                                           style: kLabelTextStyle,
            //                                         ),
            //                                       ),
            //                                       ButtonSegment(
            //                                         value: Sort.desc,
            //                                         icon: Icon(Icons
            //                                             .arrow_upward_rounded),
            //                                         label: Text(
            //                                           "Descending",
            //                                           style: kLabelTextStyle,
            //                                         ),
            //                                       ),
            //                                     ],
            //                                     showSelectedIcon: false,
            //                                     emptySelectionAllowed: true,
            //                                     selected: {},
            //                                     selectedIcon:
            //                                         const SizedBox.shrink(),
            //                                     style: ButtonStyle(
            //                                       shape: MaterialStateProperty
            //                                           .all<OutlinedBorder>(
            //                                         RoundedRectangleBorder(
            //                                           borderRadius:
            //                                               kBorderRadius,
            //                                         ),
            //                                       ),
            //                                     ),
            //                                     onSelectionChanged: (value) {},
            //                                   ),
            //                                 ),
            //                                 Divider(),
            //                                 Padding(
            //                                   padding:
            //                                       const EdgeInsets.symmetric(
            //                                           vertical: 5.0),
            //                                   child: Row(
            //                                     children: [
            //                                       Icon(Icons
            //                                           .filter_alt_outlined),
            //                                       SizedBox(
            //                                         width: 5,
            //                                       ),
            //                                       Text(
            //                                         "Filter",
            //                                         style: kLabelTextStyle,
            //                                       ),
            //                                     ],
            //                                   ),
            //                                 ),
            //                                 Padding(
            //                                   padding:
            //                                       const EdgeInsets.symmetric(
            //                                           vertical: 5.0),
            //                                   child: Row(
            //                                     mainAxisAlignment:
            //                                         MainAxisAlignment.center,
            //                                     children: [
            //                                       Container(
            //                                         decoration: BoxDecoration(
            //                                           border: Border.all(),
            //                                           borderRadius:
            //                                               kBorderRadius,
            //                                           // BorderRadius
            //                                           //     .circular(
            //                                           //         5.0),
            //                                         ),
            //                                         child: Padding(
            //                                           padding: const EdgeInsets
            //                                               .symmetric(
            //                                             horizontal: 7.0,
            //                                             vertical: 2.0,
            //                                           ),
            //                                           // padding: EdgeInsets.zero,
            //                                           child: SizedBox(
            //                                             // width: 200,
            //                                             child: DropdownButton(
            //                                               autofocus: false,
            //                                               borderRadius:
            //                                                   kBorderRadius,
            //                                               hint: SizedBox(
            //                                                 width: 150,
            //                                                 child: Text(
            //                                                   "Select Filter",
            //                                                   style:
            //                                                       kLabelTextStyle,
            //                                                 ),
            //                                               ),
            //                                               menuMaxHeight: 250,
            //                                               // isDense: true,
            //                                               icon: Icon(Icons
            //                                                   .arrow_drop_down_outlined),
            //                                               underline:
            //                                                   Container(),
            //                                               items: [
            //                                                 "Equals",
            //                                                 "Not Equals",
            //                                                 "Begins With",
            //                                                 "Not Begins With",
            //                                                 "Contains",
            //                                                 "Not Contains",
            //                                                 "Ends With",
            //                                                 "Not Ends With",
            //                                               ]
            //                                                   .map(
            //                                                     (e) =>
            //                                                         DropdownMenuItem(
            //                                                       value: e,
            //                                                       child: Text(
            //                                                         e,
            //                                                         style:
            //                                                             kLabelTextStyle,
            //                                                       ),
            //                                                     ),
            //                                                   )
            //                                                   .toList(),
            //                                               onChanged: (value) {},
            //                                             ),
            //                                           ),
            //                                         ),
            //                                       ),
            //                                       SizedBox(
            //                                         width: 20.0,
            //                                       ),
            //                                       SizedBox(
            //                                         width: 200,
            //                                         child: TextFormField(
            //                                           controller:
            //                                               TextEditingController(),
            //                                           enabled: false,
            //                                           decoration:
            //                                               InputDecoration(
            //                                             filled: true,
            //                                             fillColor:
            //                                                 kTertiaryBackgroundColor,
            //                                             border: OutlineInputBorder(
            //                                                 borderRadius:
            //                                                     kBorderRadius),
            //                                             labelText:
            //                                                 "Select Filter",
            //                                             labelStyle:
            //                                                 kLabelTextStyle,
            //                                           ),
            //                                           style: kLabelTextStyle,
            //                                         ),
            //                                       ),
            //                                     ],
            //                                   ),
            //                                 ),
            //                                 if (false) SizedBox(height: 10.0),
            //                                 if (false)
            //                                   Padding(
            //                                     padding:
            //                                         const EdgeInsets.symmetric(
            //                                             vertical: 5.0),
            //                                     child: Row(
            //                                       mainAxisAlignment:
            //                                           MainAxisAlignment.center,
            //                                       children: [
            //                                         Container(
            //                                           decoration: BoxDecoration(
            //                                             border: Border.all(),
            //                                             borderRadius:
            //                                                 kBorderRadius,
            //                                             // BorderRadius
            //                                             //     .circular(
            //                                             //         5.0),
            //                                           ),
            //                                           child: Padding(
            //                                             padding:
            //                                                 const EdgeInsets
            //                                                     .symmetric(
            //                                               horizontal: 7.0,
            //                                               vertical: 2.0,
            //                                             ),
            //                                             // padding: EdgeInsets.zero,
            //                                             child: SizedBox(
            //                                               // width: 200,
            //                                               child: DropdownButton(
            //                                                 autofocus: false,
            //                                                 borderRadius:
            //                                                     kBorderRadius,
            //                                                 hint: SizedBox(
            //                                                   width: 150,
            //                                                   child: Text(
            //                                                     "Select Filter",
            //                                                     style:
            //                                                         kLabelTextStyle,
            //                                                   ),
            //                                                 ),
            //                                                 menuMaxHeight: 250,
            //                                                 // isDense: true,
            //                                                 icon: Icon(Icons
            //                                                     .arrow_drop_down_outlined),
            //                                                 underline:
            //                                                     Container(),
            //                                                 items: [
            //                                                   "Equals",
            //                                                   "Not Equals",
            //                                                   "Begins With",
            //                                                   "Not Begins With",
            //                                                   "Contains",
            //                                                   "Not Contains",
            //                                                   "Ends With",
            //                                                   "Not Ends With",
            //                                                 ]
            //                                                     .map(
            //                                                       (e) =>
            //                                                           DropdownMenuItem(
            //                                                         value: e,
            //                                                         child: Text(
            //                                                           e,
            //                                                           style:
            //                                                               kLabelTextStyle,
            //                                                         ),
            //                                                       ),
            //                                                     )
            //                                                     .toList(),
            //                                                 onChanged:
            //                                                     (value) {},
            //                                               ),
            //                                             ),
            //                                           ),
            //                                         ),
            //                                         SizedBox(
            //                                           width: 20.0,
            //                                         ),
            //                                         SizedBox(
            //                                           width: 200,
            //                                           child: TextFormField(
            //                                             controller:
            //                                                 TextEditingController(),
            //                                             enabled: false,
            //                                             decoration:
            //                                                 InputDecoration(
            //                                               filled: true,
            //                                               fillColor:
            //                                                   kTertiaryBackgroundColor,
            //                                               border: OutlineInputBorder(
            //                                                   borderRadius:
            //                                                       kBorderRadius),
            //                                               labelText:
            //                                                   "Select Filter",
            //                                               labelStyle:
            //                                                   kLabelTextStyle,
            //                                             ),
            //                                             style: kLabelTextStyle,
            //                                           ),
            //                                         ),
            //                                       ],
            //                                     ),
            //                                   ),
            //                                 Divider(),
            //                                 Padding(
            //                                   padding:
            //                                       const EdgeInsets.symmetric(
            //                                           vertical: 5.0),
            //                                   child: Row(
            //                                     children: [
            //                                       Icon(Icons.search_outlined),
            //                                       SizedBox(
            //                                         width: 5,
            //                                       ),
            //                                       Text(
            //                                         "Search",
            //                                         style: kLabelTextStyle,
            //                                       ),
            //                                     ],
            //                                   ),
            //                                 ),
            //                                 Padding(
            //                                   padding:
            //                                       const EdgeInsets.fromLTRB(
            //                                           3.0, 5.0, 3.0, 3.0),
            //                                   child: Container(
            //                                     height: 500,
            //                                     decoration: BoxDecoration(
            //                                       color:
            //                                           kTertiaryBackgroundColor,
            //                                       borderRadius: kBorderRadius,
            //                                       boxShadow: kBoxShadowList,
            //                                     ),
            //                                   ),
            //                                 ),
            //                               ],
            //                             ),
            //                           ),
            //                         ),
            //                       ),
            //                     ),
            //                   ],
            //                 ),
            //               ),
            //             ),
            //           ),
            //         ),
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

// Align(
//   alignment: Alignment.topRight,
//   child: Padding(
//     padding: const EdgeInsets.all(10.0),
//     child: CustomContainer(
//       child: Padding(
//         padding: const EdgeInsets.all(10.0),
//         child: Row(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             ElevatedButton(
//               style: ElevatedButton.styleFrom(
//                 shape: RoundedRectangleBorder(
//                   borderRadius: kBorderRadius,
//                 ),
//               ),
//               onPressed: () {
//                 _visualizeStockBloc.add(
//                     ImportButtonClickedEvent(
//                         visualizeStock: visualizeStock));
//               },
//               child: Text(
//                 "Import Excel",
//                 style: kLabelTextStyle,
//               ),
//             ),
//             const SizedBox(
//               width: 10,
//             ),
//             ElevatedButton(
//               style: ElevatedButton.styleFrom(
//                 shape: RoundedRectangleBorder(
//                   borderRadius: kBorderRadius,
//                 ),
//               ),
//               onPressed: () {
//                 _visualizeStockBloc.add(
//                     ExportButtonClickedEvent(
//                         visualizeStock: visualizeStock));
//               },
//               child: Text(
//                 "Export Table",
//                 style: kLabelTextStyle,
//               ),
//             ),
//           ],
//         ),
//       ),
//     ),
//   ),
// ),
