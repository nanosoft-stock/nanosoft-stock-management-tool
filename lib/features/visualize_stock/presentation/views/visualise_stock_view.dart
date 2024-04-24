import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:stock_management_tool/components/custom_container.dart';
import 'package:stock_management_tool/components/custom_elevated_button.dart';
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
        _visualizeStockBloc.add(LoadedEvent());
        return _buildLoadingStateWidget();

      case const (ErrorState):
        return _buildErrorStateWidget();

      case const (LoadedState):
        List fields = state.fields!;
        List stocks = state.stocks!;
        return _buildLoadedStateWidget(fields, stocks);

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

  Widget _buildLoadedStateWidget(List fields, List stocks) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return Stack(
          alignment: Alignment.topRight,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(52, 0, 52, 40),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 10, 0, 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        CustomContainer(
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Row(
                              children: [
                                CustomElevatedButton(
                                  text: "Import Excel",
                                  onPressed: () async {
                                    _visualizeStockBloc.add(ImportButtonClickedEvent());
                                  },
                                ),
                                const SizedBox(
                                  width: 20.0,
                                ),
                                CustomElevatedButton(
                                  text: "Export Table",
                                  onPressed: () {
                                    _visualizeStockBloc.add(ExportButtonClickedEvent());
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
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
                                cellBuilder: (BuildContext context, TableVicinity vicinity) {
                                  if (vicinity.row == 0) {
                                    return TableViewCell(
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Text(
                                            fields[vicinity.column].field.toString().toTitleCase(),
                                            style: GoogleFonts.lato(
                                              textStyle: const TextStyle(
                                                fontSize: 15.0,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          ),
                                          CustomSortButton(
                                            field: fields[vicinity.column].field.toString(),
                                            sort: fields[vicinity.column].sort,
                                            onPressed: (field, sort) {
                                              _visualizeStockBloc
                                                  .add(SortFieldEvent(field: field, sort: sort));
                                            },
                                          ),
                                        ],
                                      ),
                                    );
                                  } else {
                                    String text = (stocks[vicinity.row - 1]
                                                [fields[vicinity.column].field] ??
                                            "")
                                        .toString();
                                    if (vicinity.column == 0) {
                                      text = DateFormat('dd-MM-yyyy')
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
                        ),
                      ),
                    ),
                  ),
                ],
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
