import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:stock_management_tool/components/custom_container.dart';
import 'package:stock_management_tool/constants/constants.dart';
import 'package:stock_management_tool/constants/enums.dart';
import 'package:stock_management_tool/features/visualize_stock/presentation/bloc/visualize_stock_bloc.dart';
import 'package:stock_management_tool/features/visualize_stock/presentation/widgets/custom_column_filter.dart';
import 'package:stock_management_tool/features/visualize_stock/presentation/widgets/custom_filter_button.dart';
import 'package:stock_management_tool/features/visualize_stock/presentation/widgets/custom_overlay_effect.dart';
import 'package:stock_management_tool/features/visualize_stock/presentation/widgets/custom_sort_button.dart';
import 'package:stock_management_tool/features/visualize_stock/presentation/widgets/custom_table_filter.dart';
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
      child: SizedBox(
        width: 100,
        child: LinearProgressIndicator(),
      ),
    );
  }

  Widget _buildErrorStateWidget() {
    return const Center(
      child: Text('Error'),
    );
  }

  Widget _buildLoadedStateWidget(Map visualizeStock) {
    List fields = visualizeStock["show_fields"];
    List stocks = visualizeStock["stocks"];
    List filters = visualizeStock["filters"];

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return Stack(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(52, 57, 52, 40),
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
                                onPressed: () {
                                  _visualizeStockBloc.add(
                                      ShowTableFilterLayerEvent(
                                          visualizeStock: visualizeStock));
                                },
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
                                        borderRadius:
                                            BorderRadius.circular(7.0),
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
                                        borderRadius:
                                            BorderRadius.circular(7.0),
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
                            child: TableView(
                              horizontalDetails:
                                  const ScrollableDetails.horizontal(
                                physics: ClampingScrollPhysics(),
                              ),
                              verticalDetails: const ScrollableDetails.vertical(
                                physics: BouncingScrollPhysics(),
                              ),
                              // cacheExtent: 2000,
                              delegate: TableCellBuilderDelegate(
                                columnCount: fields.length + 1,
                                rowCount: stocks.length + 1,
                                pinnedRowCount: 1,
                                pinnedColumnCount: 1,
                                columnBuilder: (int index) {
                                  return TableSpan(
                                    backgroundDecoration:
                                        const TableSpanDecoration(
                                      border: TableSpanBorder(
                                        leading: BorderSide(
                                          color: Colors.black54,
                                        ),
                                        trailing: BorderSide(
                                          color: Colors.black54,
                                        ),
                                      ),
                                    ),
                                    extent: FixedTableSpanExtent(
                                        index != 0 ? 225 : 100),
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
                                cellBuilder: (BuildContext context,
                                    TableVicinity vicinity) {
                                  if (vicinity.row == 0 &&
                                      vicinity.column == 0) {
                                    return TableViewCell(
                                      child: Container(),
                                    );
                                  } else if (vicinity.column == 0) {
                                    return TableViewCell(
                                      child: Center(
                                        child: Text(
                                          vicinity.row.toString(),
                                          style: GoogleFonts.lato(
                                            textStyle: const TextStyle(
                                              fontSize: 15.0,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  } else if (vicinity.row == 0) {
                                    String field =
                                        fields[vicinity.column - 1].toString();

                                    Sort sort = filters.firstWhere(
                                        (e) => e["field"] == field)["sort"];

                                    return TableViewCell(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10.0),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: Center(
                                                child: Text(
                                                  field.toTitleCase(),
                                                  style: GoogleFonts.lato(
                                                    textStyle: const TextStyle(
                                                      fontSize: 15.0,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                CustomSortButton(
                                                  field: field,
                                                  sort: sort,
                                                  onPressed: (field, sort) {
                                                    _visualizeStockBloc
                                                        .add(SortColumnEvent(
                                                      field: field,
                                                      sort: sort,
                                                      visualizeStock:
                                                          visualizeStock,
                                                    ));
                                                  },
                                                ),
                                                CustomFilterButton(
                                                  field: field,
                                                  onPressed: () {
                                                    _visualizeStockBloc.add(
                                                        ShowColumnFilterLayerEvent(
                                                            field: field,
                                                            visualizeStock:
                                                                visualizeStock));
                                                  },
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  } else {
                                    String text = (stocks[vicinity.row - 1]
                                                [fields[vicinity.column - 1]] ??
                                            "")
                                        .toString();

                                    if (fields[vicinity.column - 1] == "date") {
                                      text = DateFormat('dd-MM-yyyy').format(
                                          DateTime.parse(text.toUpperCase()));
                                    }

                                    return TableViewCell(
                                      child: text != ""
                                          ? Center(
                                              child: SelectableText(
                                                text,
                                                style: GoogleFonts.lato(),
                                              ),
                                            )
                                          : const SizedBox.shrink(),
                                    );
                                  }
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 10.0,
                        ),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            "${stocks.length} x ${fields.length}",
                            style: kLabelTextStyle,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            if ((visualizeStock["layers"].contains("field_filter") ||
                    visualizeStock["layers"].contains("parent_field_filter")) &&
                visualizeStock["filter_menu_field"] != null)
              CustomOverlayEffect(
                width: constraints.maxWidth / 3,
                hideOverlay: () {
                  if (visualizeStock["layers"].contains("field_filter")) {
                    _visualizeStockBloc.add(HideLayerEvent(
                        layer: "field_filter", visualizeStock: visualizeStock));
                  } else if (visualizeStock["layers"]
                      .contains("parent_field_filter")) {
                    _visualizeStockBloc.add(HideLayerEvent(
                        layer: "parent_field_filter",
                        visualizeStock: visualizeStock));
                  }
                },
                child: CustomColumnFilter(
                  isClose: visualizeStock["layers"].contains("field_filter"),
                  fieldFilter: visualizeStock["filters"].firstWhere(
                      (e) => e["field"] == visualizeStock["filter_menu_field"]),
                  closeOnTap: () {
                    _visualizeStockBloc.add(HideLayerEvent(
                        layer: "field_filter", visualizeStock: visualizeStock));
                  },
                  backOnTap: () {
                    _visualizeStockBloc.add(HideLayerEvent(
                        layer: "parent_field_filter",
                        visualizeStock: visualizeStock));
                    _visualizeStockBloc.add(ShowTableFilterLayerEvent(
                        visualizeStock: visualizeStock));
                  },
                  filterOnPressed: (field) {
                    _visualizeStockBloc.add(FilterColumnEvent(
                        field: field, visualizeStock: visualizeStock));
                  },
                  clearOnPressed: (field) {
                    _visualizeStockBloc.add(ClearColumnFilterEvent(
                        field: field, visualizeStock: visualizeStock));
                  },
                  changeVisibilityOnTap: (field, visibility) {
                    _visualizeStockBloc.add(ColumnVisibilityChangedEvent(
                        visibility: visibility,
                        field: field,
                        visualizeStock: visualizeStock));
                  },
                  sortOnPressed: (field, sort) {
                    _visualizeStockBloc.add(SortColumnEvent(
                      field: field,
                      sort: sort,
                      visualizeStock: visualizeStock,
                    ));
                  },
                  filterBySelected: (field, filterBy) {
                    _visualizeStockBloc.add(FilterBySelectedEvent(
                      field: field,
                      filterBy: filterBy,
                      visualizeStock: visualizeStock,
                    ));
                  },
                  filterValueChanged: (field, filterValue) {
                    _visualizeStockBloc.add(FilterValueChangedEvent(
                      field: field,
                      filterValue: filterValue,
                      visualizeStock: visualizeStock,
                    ));
                  },
                  searchValueChanged: (field, searchValue) {
                    _visualizeStockBloc.add(SearchValueChangedEvent(
                      field: field,
                      searchValue: searchValue,
                      visualizeStock: visualizeStock,
                    ));
                  },
                  checkboxToggled: (field, title, value) {
                    _visualizeStockBloc.add(CheckBoxToggledEvent(
                      field: field,
                      title: title,
                      value: value,
                      visualizeStock: visualizeStock,
                    ));
                  },
                ),
              ),
            if (visualizeStock["layers"].contains("parent_filter"))
              CustomOverlayEffect(
                width: constraints.maxWidth / 3,
                hideOverlay: () {
                  _visualizeStockBloc.add(HideLayerEvent(
                      layer: "parent_filter", visualizeStock: visualizeStock));
                },
                child: CustomTableFilter(
                  fieldFilters: visualizeStock["filters"],
                  closeOnTap: () {
                    _visualizeStockBloc.add(HideLayerEvent(
                        layer: "parent_filter",
                        visualizeStock: visualizeStock));
                  },
                  resetAllFiltersOnPressed: () {
                    _visualizeStockBloc.add(
                        ResetAllFiltersEvent(visualizeStock: visualizeStock));
                  },
                  fieldFilterOnPressed: (field) {
                    _visualizeStockBloc.add(HideLayerEvent(
                        layer: "parent_filter",
                        visualizeStock: visualizeStock));
                    _visualizeStockBloc.add(ShowTableColumnFilterLayerEvent(
                        field: field, visualizeStock: visualizeStock));
                  },
                  onReorder: (fieldFilters) {
                    _visualizeStockBloc.add(RearrangeColumnsEvent(
                        fieldFilters: fieldFilters,
                        visualizeStock: visualizeStock));
                  },
                  changeVisibilityOnTap: (field, visibility) {
                    _visualizeStockBloc.add(ColumnVisibilityChangedEvent(
                        visibility: visibility,
                        field: field,
                        visualizeStock: visualizeStock));
                  },
                ),
              ),
          ],
        );
      },
    );
  }
}
