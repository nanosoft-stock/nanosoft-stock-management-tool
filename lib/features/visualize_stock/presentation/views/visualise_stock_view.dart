import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stock_management_tool/core/components/custom_container.dart';
import 'package:stock_management_tool/core/constants/constants.dart';
import 'package:stock_management_tool/core/services/injection_container.dart';
import 'package:stock_management_tool/features/visualize_stock/presentation/bloc/visualize_stock_bloc.dart';
import 'package:stock_management_tool/features/visualize_stock/presentation/widgets/custom_column_filter.dart';
import 'package:stock_management_tool/features/visualize_stock/presentation/widgets/custom_table_view.dart';
import 'package:stock_management_tool/features/visualize_stock/presentation/widgets/custom_overlay_effect.dart';
import 'package:stock_management_tool/features/visualize_stock/presentation/widgets/custom_table_filter.dart';

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
            _visualizeStockBloc.add(const LoadedEvent());
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
    List fields = visualizeStock["fields"];
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
                                            const ShowTableFilterLayerEvent());
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
                                                const ImportButtonClickedEvent());
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
                                                const ExportButtonClickedEvent());
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
                                child: CustomTableView(
                              fields: fields,
                              stocks: stocks,
                              filters: filters,
                              sortOnPressed: (field, sort) {
                                _visualizeStockBloc.add(SortColumnEvent(
                                  field: field,
                                  sort: sort,
                                ));
                              },
                              filterOnPressed: (field) {
                                _visualizeStockBloc
                                    .add(ShowColumnFilterLayerEvent(
                                  field: field,
                                ));
                              },
                            )),
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
                          _visualizeStockBloc.add(const HideLayerEvent(
                            layer: "field_filter",
                          ));
                        } else if (visualizeStock["layers"]
                            .contains("parent_field_filter")) {
                          _visualizeStockBloc.add(const HideLayerEvent(
                            layer: "parent_field_filter",
                          ));
                        }
                      },
                      child: CustomColumnFilter(
                        isClose:
                            visualizeStock["layers"].contains("field_filter"),
                        fieldFilter: visualizeStock["filters"]
                            [visualizeStock["filter_menu_field"]],
                        closeOnTap: () {
                          _visualizeStockBloc.add(const HideLayerEvent(
                            layer: "field_filter",
                          ));
                        },
                        backOnTap: () {
                          _visualizeStockBloc.add(const HideLayerEvent(
                            layer: "parent_field_filter",
                          ));
                          _visualizeStockBloc
                              .add(const ShowTableFilterLayerEvent());
                        },
                        filterOnPressed: () {
                          _visualizeStockBloc.add(FilterColumnEvent(
                            field: visualizeStock["filter_menu_field"],
                          ));
                        },
                        clearOnPressed: () {
                          _visualizeStockBloc.add(ClearColumnFilterEvent(
                            field: visualizeStock["filter_menu_field"],
                          ));
                        },
                        changeVisibilityOnTap: (visibility) {
                          _visualizeStockBloc.add(ColumnVisibilityChangedEvent(
                            field: visualizeStock["filter_menu_field"],
                            visibility: visibility,
                          ));
                        },
                        sortOnPressed: (sort) {
                          _visualizeStockBloc.add(SortColumnEvent(
                            field: visualizeStock["filter_menu_field"],
                            sort: sort,
                          ));
                        },
                        filterBySelected: (filterBy) {
                          _visualizeStockBloc.add(FilterBySelectedEvent(
                            field: visualizeStock["filter_menu_field"],
                            filterBy: filterBy,
                          ));
                        },
                        filterValueChanged: (filterValue) {
                          _visualizeStockBloc.add(FilterValueChangedEvent(
                            field: visualizeStock["filter_menu_field"],
                            filterValue: filterValue,
                          ));
                        },
                        searchValueChanged: (searchValue) {
                          _visualizeStockBloc.add(SearchValueChangedEvent(
                            field: visualizeStock["filter_menu_field"],
                            searchValue: searchValue,
                          ));
                        },
                        checkboxToggled: (title, value) {
                          _visualizeStockBloc.add(CheckBoxToggledEvent(
                            field: visualizeStock["filter_menu_field"],
                            title: title,
                            value: value,
                          ));
                        },
                      ),
                    ),
                  if (visualizeStock["layers"].contains("parent_filter"))
                    CustomOverlayEffect(
                      width: filterWidth,
                      hideOverlay: () {
                        _visualizeStockBloc.add(const HideLayerEvent(
                          layer: "parent_filter",
                        ));
                      },
                      child: CustomTableFilter(
                        fields: visualizeStock["fields"],
                        closeOnTap: () {
                          _visualizeStockBloc.add(const HideLayerEvent(
                            layer: "parent_filter",
                          ));
                        },
                        resetAllFiltersOnPressed: () {
                          _visualizeStockBloc.add(const ResetAllFiltersEvent());
                        },
                        fieldFilterOnPressed: (field) {
                          _visualizeStockBloc.add(const HideLayerEvent(
                            layer: "parent_filter",
                          ));
                          _visualizeStockBloc
                              .add(ShowTableColumnFilterLayerEvent(
                            field: field,
                          ));
                        },
                        onReorder: (fieldFilters) {
                          _visualizeStockBloc.add(RearrangeColumnsEvent(
                            fields: fieldFilters,
                          ));
                        },
                        changeVisibilityOnTap: (field, visibility) {
                          _visualizeStockBloc.add(ColumnVisibilityChangedEvent(
                            visibility: visibility,
                            field: field,
                          ));
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
