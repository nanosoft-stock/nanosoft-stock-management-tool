import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stock_management_tool/core/components/custom_container.dart';
import 'package:stock_management_tool/core/constants/constants.dart';
import 'package:stock_management_tool/core/constants/enums.dart';
import 'package:stock_management_tool/core/helper/string_casting_extension.dart';
import 'package:stock_management_tool/core/services/injection_container.dart';
import 'package:stock_management_tool/features/visualize_stock/presentation/bloc/visualize_stock_bloc.dart';
import 'package:stock_management_tool/features/visualize_stock/presentation/widgets/custom_column_filter.dart';
import 'package:stock_management_tool/features/visualize_stock/presentation/widgets/custom_filter_button.dart';
import 'package:stock_management_tool/features/visualize_stock/presentation/widgets/custom_overlay_effect.dart';
import 'package:stock_management_tool/features/visualize_stock/presentation/widgets/custom_sort_button.dart';
import 'package:stock_management_tool/features/visualize_stock/presentation/widgets/custom_table_filter.dart';
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
      listener: (BuildContext context, VisualizeStockState state) {
        _blocListener(context, state);
      },
      builder: (BuildContext context, VisualizeStockState state) {
        return _blocBuilder(context, state);
      },
    );
  }

  void _blocListener(BuildContext context, VisualizeStockState state) {}

  Widget _blocBuilder(BuildContext context, VisualizeStockState state) {
    switch (state.runtimeType) {
      case const (LoadingState):
        _visualizeStockBloc.add(CloudDataChangeEvent(
          onChange: (visualizeStock) {
            _visualizeStockBloc.add(LoadedEvent(
                visualizeStock: visualizeStock.cast<String, dynamic>()));
          },
        ));

        return _buildLoadingStateWidget();

      case const (ErrorState):
        return _buildErrorStateWidget();

      case const (LoadedState):
        Map<String, dynamic> visualizeStock = state.visualizeStock!;
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

  Widget _buildLoadedStateWidget(Map<String, dynamic> visualizeStock) {
    List fields = visualizeStock["show_fields"];
    List stocks = visualizeStock["stocks"];
    Map filters = visualizeStock["filters"];

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        double filterWidth = 475;

        return constraints.maxWidth > 550
            ? Stack(
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
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
                                            ShowTableFilterLayerEvent(
                                                visualizeStock:
                                                    visualizeStock));
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
                                                    visualizeStock:
                                                        visualizeStock));
                                          },
                                          child: Text(
                                            "Import Excel",
                                            style: kLabelTextStyle,
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 10.0,
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
                                  child: TableView(
                                    horizontalDetails:
                                        const ScrollableDetails.horizontal(
                                      physics: ClampingScrollPhysics(),
                                    ),
                                    verticalDetails:
                                        const ScrollableDetails.vertical(
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
                                              index != 0 ? 250 : 100),
                                        );
                                      },
                                      rowBuilder: (int index) {
                                        return const TableSpan(
                                          backgroundDecoration:
                                              TableSpanDecoration(
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
                                                style: kTableHeaderTextStyle,
                                              ),
                                            ),
                                          );
                                        } else if (vicinity.row == 0) {
                                          String field =
                                              fields[vicinity.column - 1]
                                                  .toString();

                                          Sort sort = filters[field]["sort"];

                                          return TableViewCell(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 10.0),
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    child: Center(
                                                      child: Text(
                                                        field.toTitleCase(),
                                                        style:
                                                            kTableHeaderTextStyle,
                                                      ),
                                                    ),
                                                  ),
                                                  Row(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      CustomSortButton(
                                                        field: field,
                                                        sort: sort,
                                                        onPressed:
                                                            (field, sort) {
                                                          _visualizeStockBloc.add(
                                                              SortColumnEvent(
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
                                          String text =
                                              (stocks[vicinity.row - 1][fields[
                                                          vicinity.column -
                                                              1]] ??
                                                      "")
                                                  .toString();

                                          return TableViewCell(
                                            child: text != ""
                                                ? Center(
                                                    child: SelectableText(
                                                      text,
                                                      style:
                                                          kTableValueTextStyle,
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
                          visualizeStock["layers"]
                              .contains("parent_field_filter")) &&
                      visualizeStock["filter_menu_field"] != null)
                    CustomOverlayEffect(
                      width: filterWidth,
                      hideOverlay: () {
                        if (visualizeStock["layers"].contains("field_filter")) {
                          _visualizeStockBloc.add(HideLayerEvent(
                              layer: "field_filter",
                              visualizeStock: visualizeStock));
                        } else if (visualizeStock["layers"]
                            .contains("parent_field_filter")) {
                          _visualizeStockBloc.add(HideLayerEvent(
                              layer: "parent_field_filter",
                              visualizeStock: visualizeStock));
                        }
                      },
                      child: CustomColumnFilter(
                        isClose:
                            visualizeStock["layers"].contains("field_filter"),
                        fieldFilter: visualizeStock["filters"]
                            [visualizeStock["filter_menu_field"]],
                        closeOnTap: () {
                          _visualizeStockBloc.add(HideLayerEvent(
                              layer: "field_filter",
                              visualizeStock: visualizeStock));
                        },
                        backOnTap: () {
                          _visualizeStockBloc.add(HideLayerEvent(
                              layer: "parent_field_filter",
                              visualizeStock: visualizeStock));
                          _visualizeStockBloc.add(ShowTableFilterLayerEvent(
                              visualizeStock: visualizeStock));
                        },
                        filterOnPressed: () {
                          _visualizeStockBloc.add(FilterColumnEvent(
                              field: visualizeStock["filter_menu_field"],
                              visualizeStock: visualizeStock));
                        },
                        clearOnPressed: () {
                          _visualizeStockBloc.add(ClearColumnFilterEvent(
                              field: visualizeStock["filter_menu_field"],
                              visualizeStock: visualizeStock));
                        },
                        changeVisibilityOnTap: (visibility) {
                          _visualizeStockBloc.add(ColumnVisibilityChangedEvent(
                              field: visualizeStock["filter_menu_field"],
                              visibility: visibility,
                              visualizeStock: visualizeStock));
                        },
                        sortOnPressed: (sort) {
                          _visualizeStockBloc.add(SortColumnEvent(
                            field: visualizeStock["filter_menu_field"],
                            sort: sort,
                            visualizeStock: visualizeStock,
                          ));
                        },
                        filterBySelected: (filterBy) {
                          _visualizeStockBloc.add(FilterBySelectedEvent(
                            field: visualizeStock["filter_menu_field"],
                            filterBy: filterBy,
                            visualizeStock: visualizeStock,
                          ));
                        },
                        filterValueChanged: (filterValue) {
                          _visualizeStockBloc.add(FilterValueChangedEvent(
                            field: visualizeStock["filter_menu_field"],
                            filterValue: filterValue,
                            visualizeStock: visualizeStock,
                          ));
                        },
                        searchValueChanged: (searchValue) {
                          _visualizeStockBloc.add(SearchValueChangedEvent(
                            field: visualizeStock["filter_menu_field"],
                            searchValue: searchValue,
                            visualizeStock: visualizeStock,
                          ));
                        },
                        checkboxToggled: (title, value) {
                          _visualizeStockBloc.add(CheckBoxToggledEvent(
                            field: visualizeStock["filter_menu_field"],
                            title: title,
                            value: value,
                            visualizeStock: visualizeStock,
                          ));
                        },
                      ),
                    ),
                  if (visualizeStock["layers"].contains("parent_filter"))
                    CustomOverlayEffect(
                      width: filterWidth,
                      hideOverlay: () {
                        _visualizeStockBloc.add(HideLayerEvent(
                            layer: "parent_filter",
                            visualizeStock: visualizeStock));
                      },
                      child: CustomTableFilter(
                        fields: visualizeStock["fields"],
                        closeOnTap: () {
                          _visualizeStockBloc.add(HideLayerEvent(
                              layer: "parent_filter",
                              visualizeStock: visualizeStock));
                        },
                        resetAllFiltersOnPressed: () {
                          _visualizeStockBloc.add(ResetAllFiltersEvent(
                              visualizeStock: visualizeStock));
                        },
                        fieldFilterOnPressed: (field) {
                          _visualizeStockBloc.add(HideLayerEvent(
                              layer: "parent_filter",
                              visualizeStock: visualizeStock));
                          _visualizeStockBloc.add(
                              ShowTableColumnFilterLayerEvent(
                                  field: field,
                                  visualizeStock: visualizeStock));
                        },
                        onReorder: (fieldFilters) {
                          _visualizeStockBloc.add(RearrangeColumnsEvent(
                              fields: fieldFilters,
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
              )
            : const SizedBox(
                width: double.infinity,
                height: double.infinity,
              );
      },
    );
  }
}
