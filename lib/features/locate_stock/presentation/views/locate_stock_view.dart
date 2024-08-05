import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stock_management_tool/core/components/custom_container.dart';
import 'package:stock_management_tool/core/components/custom_elevated_button.dart';
import 'package:stock_management_tool/core/constants/constants.dart';
import 'package:stock_management_tool/core/services/injection_container.dart';
import 'package:stock_management_tool/features/locate_stock/presentation/bloc/locate_stock_bloc.dart';
import 'package:stock_management_tool/features/locate_stock/presentation/widgets/custom_completed_moves_overlay.dart';
import 'package:stock_management_tool/features/locate_stock/presentation/widgets/custom_field_filter.dart';
import 'package:stock_management_tool/features/locate_stock/presentation/widgets/custom_filter_overlay_effect.dart';
import 'package:stock_management_tool/features/locate_stock/presentation/widgets/custom_multiple_search_selection_overlay.dart';
import 'package:stock_management_tool/features/locate_stock/presentation/widgets/custom_pending_moves_overlay.dart';
import 'package:stock_management_tool/features/locate_stock/presentation/widgets/custom_preview_move_overlay.dart';
import 'package:stock_management_tool/features/locate_stock/presentation/widgets/custom_table_filter.dart';
import 'package:stock_management_tool/features/locate_stock/presentation/widgets/locate_stock_add_new_input_row.dart';
import 'package:stock_management_tool/features/locate_stock/presentation/widgets/locate_stock_input_row.dart';

class LocateStockView extends StatelessWidget {
  LocateStockView({super.key});

  final LocateStockBloc _locateStockBloc = sl.get<LocateStockBloc>();

  @override
  Widget build(BuildContext context) {
    return _buildBody();
  }

  Widget _buildBody() {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return BlocConsumer<LocateStockBloc, LocateStockState>(
          bloc: _locateStockBloc,
          listenWhen: (prev, next) => next is LocateStockActionState,
          buildWhen: (prev, next) => next is! LocateStockActionState,
          listener: (context, state) {
            _blocListener(context, state);
          },
          builder: (context, state) {
            return _blocBuilder(context, state);
          },
        );
      },
    );
  }

  void _blocListener(BuildContext context, LocateStockState state) {
    switch (state.runtimeType) {
      default:
        return;
    }
  }

  Widget _blocBuilder(BuildContext context, LocateStockState state) {
    switch (state.runtimeType) {
      case const (LoadingState):
        _locateStockBloc.add(CloudDataChangeEvent(
          onChange: (locatedStock) {
            _locateStockBloc.add(const LoadedEvent());
          },
        ));

        return _buildLoadingStateWidget();

      case const (ErrorState):
        return _buildErrorStateWidget();

      case const (LoadedState):
        int? rowIndex = state.index;
        Map<String, dynamic> locatedStock = state.locatedStock!;
        int rowCount = locatedStock["rows"].length;

        return _buildLoadedStateWidget(rowCount, rowIndex, locatedStock);

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

  Widget _buildLoadedStateWidget(
      int rowCount, int? rowIndex, Map<String, dynamic> locatedStock) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        double filterWidth = 475;

        return constraints.maxWidth > 560
            ? Stack(
                children: [
                  if (locatedStock["layers"].contains("base"))
                    Padding(
                      padding: const EdgeInsets.fromLTRB(52, 57, 52, 40),
                      child: SizedBox(
                        height: constraints.maxHeight,
                        child: Column(
                          children: [
                            CustomContainer(
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: kInputFieldFillColor,
                                    borderRadius: kBorderRadius,
                                    boxShadow: kBoxShadowList,
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(7.0),
                                            ),
                                          ),
                                          onPressed: () {
                                            _locateStockBloc.add(
                                                const PendingMovesButtonPressedEvent());
                                          },
                                          child: Text(
                                            "Pending Moves",
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
                                            _locateStockBloc.add(
                                                const CompletedMovesButtonPressedEvent());
                                          },
                                          child: Text(
                                            "Completed Moves",
                                            style: kLabelTextStyle,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Expanded(
                              child: ListView.builder(
                                itemCount: rowCount + 1,
                                shrinkWrap: true,
                                controller: ScrollController(),
                                physics: const BouncingScrollPhysics(),
                                itemBuilder: (BuildContext context, int index) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10.0),
                                    child: index < rowCount
                                        ? LocateStockInputRow(
                                            rowData: locatedStock["rows"]
                                                [index],
                                            showRemoveButton: rowCount != 1,
                                            removeOnTap: () {
                                              _locateStockBloc
                                                  .add(RemoveInputRowEvent(
                                                index: index,
                                              ));
                                            },
                                            onSearchBySelected: (value) {
                                              _locateStockBloc
                                                  .add(SearchByFieldFilledEvent(
                                                index: index,
                                                searchBy: value,
                                              ));
                                            },
                                            onChooseIds: () {
                                              _locateStockBloc.add(
                                                  ChooseIdsButtonPressedEvent(
                                                index: index,
                                              ));
                                            },
                                            onShowTableToggled: (value) {
                                              _locateStockBloc
                                                  .add(SwitchTableViewEvent(
                                                index: index,
                                                showTable: value,
                                              ));
                                            },
                                            onShowDetailsToggled: (value) {
                                              _locateStockBloc
                                                  .add(SwitchStockViewModeEvent(
                                                index: index,
                                                mode: value,
                                              ));
                                            },
                                            onCheckBoxToggled: (id, state) {
                                              _locateStockBloc
                                                  .add(IdCheckBoxToggledEvent(
                                                index: index,
                                                id: id,
                                                state: state,
                                              ));
                                            },
                                            onAllCheckBoxToggled: (state) {
                                              _locateStockBloc.add(
                                                  SelectAllCheckBoxToggledEvent(
                                                index: index,
                                                state: state,
                                              ));
                                            },
                                          )
                                        : LocateStockAddNewInputRow(
                                            onTap: () {
                                              _locateStockBloc.add(
                                                  const AddNewInputRowEvent());
                                            },
                                          ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  if (locatedStock["layers"].contains("pending_moves_overlay"))
                    CustomPendingMovesOverlay(
                      pendingStateItems: locatedStock["pending_state_items"],
                      hideOverlay: () {
                        _locateStockBloc.add(const HideOverlayLayerEvent(
                          layer: "pending_moves_overlay",
                        ));
                      },
                      onExpand: (index, i, value) {
                        _locateStockBloc.add(ExpandPendingMovesItemEvent(
                          index: index,
                          i: i,
                          isExpanded: value,
                        ));
                      },
                      onCompleted: (value) {
                        _locateStockBloc.add(CompleteMoveButtonPressedEvent(
                          index: value,
                        ));
                      },
                      onRemove: (value) {
                        _locateStockBloc.add(CancelMoveButtonPressedEvent(
                          index: value,
                        ));
                      },
                    ),
                  if (locatedStock["layers"]
                      .contains("completed_moves_overlay"))
                    CustomCompletedMovesOverlay(
                      completedStateItems:
                          locatedStock["completed_state_items"],
                      hideOverlay: () {
                        _locateStockBloc.add(const HideOverlayLayerEvent(
                          layer: "completed_moves_overlay",
                        ));
                      },
                      onExpand: (index, i, value) {
                        _locateStockBloc.add(ExpandCompletedMovesItemEvent(
                          index: index,
                          i: i,
                          isExpanded: value,
                        ));
                      },
                    ),
                  if (locatedStock["layers"]
                          .contains("multiple_search_selection_overlay") &&
                      rowIndex != null)
                    CustomMultipleSearchSelectionOverlay(
                      allIds: locatedStock["all_ids"],
                      rowData: locatedStock["rows"][rowIndex],
                      hideOverlay: () {
                        _locateStockBloc.add(const HideOverlayLayerEvent(
                          layer: "multiple_search_selection_overlay",
                        ));
                      },
                      onIdEntered: (text) {
                        _locateStockBloc.add(IdEnteredEvent(
                          index: rowIndex,
                          chosenId: text,
                        ));
                      },
                      onDone: (value) {
                        _locateStockBloc.add(IdsChosenEvent(
                          index: rowIndex,
                          chosenIds: value,
                        ));
                      },
                    ),
                  if (locatedStock["layers"]
                          .contains("parent_filter_overlay") &&
                      rowIndex != null)
                    CustomFilterOverlayEffect(
                      width: filterWidth,
                      hideOverlay: () {
                        _locateStockBloc.add(const HideOverlayLayerEvent(
                          layer: "parent_filter_overlay",
                        ));
                      },
                      child: CustomTableFilter(
                        fieldFilters: locatedStock["rows"][rowIndex]["filters"]
                            .keys
                            .toList(),
                        closeOnTap: () {
                          _locateStockBloc.add(const HideOverlayLayerEvent(
                            layer: "parent_filter_overlay",
                          ));
                        },
                        resetAllFiltersOnPressed: () {
                          _locateStockBloc.add(ResetAllFiltersEvent(
                            index: rowIndex,
                          ));
                        },
                        fieldFilterOnPressed: (field) {
                          _locateStockBloc.add(FieldFilterSelectedEvent(
                            index: rowIndex,
                            field: field,
                          ));
                        },
                      ),
                    ),
                  if (locatedStock["layers"].contains("field_filter_overlay") &&
                      rowIndex != null &&
                      locatedStock["rows"][rowIndex]["filter_field"] != null)
                    CustomFilterOverlayEffect(
                      width: filterWidth,
                      hideOverlay: () {
                        _locateStockBloc.add(const HideOverlayLayerEvent(
                          layer: "parent_filter_overlay",
                        ));
                      },
                      child: CustomFieldFilter(
                        fieldFilter: locatedStock["rows"][rowIndex]["filters"]
                            [locatedStock["rows"][rowIndex]["filter_field"]],
                        backOnTap: () {
                          _locateStockBloc.add(const HideOverlayLayerEvent(
                            layer: "field_filter_overlay",
                          ));
                          _locateStockBloc.add(AddOverlayLayerEvent(
                            layer: "parent_filter_overlay",
                            index: rowIndex,
                          ));
                        },
                        filterOnPressed: () {
                          _locateStockBloc.add(FilterFieldEvent(
                            index: rowIndex,
                          ));
                        },
                        clearOnPressed: () {
                          _locateStockBloc.add(ClearFieldFilterEvent(
                            index: rowIndex,
                            field: locatedStock["rows"][rowIndex]
                                ["filter_field"],
                          ));
                        },
                        filterBySelected: (filterBy) {
                          _locateStockBloc.add(FilterBySelectedEvent(
                            index: rowIndex,
                            field: locatedStock["rows"][rowIndex]
                                ["filter_field"],
                            filterBy: filterBy,
                          ));
                        },
                        filterValueChanged: (value) {
                          _locateStockBloc.add(FilterByValueChangedEvent(
                            index: rowIndex,
                            field: locatedStock["rows"][rowIndex]
                                ["filter_field"],
                            value: value,
                          ));
                        },
                        searchValueChanged: (value) {
                          _locateStockBloc.add(SearchValueChangedEvent(
                            index: rowIndex,
                            field: locatedStock["rows"][rowIndex]
                                ["filter_field"],
                            value: value,
                          ));
                        },
                        checkboxToggled: (title, value) {
                          _locateStockBloc.add(FilterCheckBoxToggledEvent(
                            index: rowIndex,
                            field: locatedStock["rows"][rowIndex]
                                ["filter_field"],
                            title: title,
                            value: value,
                          ));
                        },
                      ),
                    ),
                  if (locatedStock["layers"].contains("base") &&
                      locatedStock["selected_item_ids"] != null &&
                      locatedStock["selected_item_ids"].isNotEmpty)
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.all(25.0),
                        child: CustomContainer(
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: CustomElevatedButton(
                              onPressed: () {
                                _locateStockBloc
                                    .add(const PreviewMoveButtonPressedEvent());
                              },
                              child: Text(
                                "Preview Move",
                                textAlign: TextAlign.center,
                                softWrap: false,
                                style: kButtonTextStyle,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  if (locatedStock["layers"].contains("preview_move_overlay"))
                    CustomPreviewMoveOverlay(
                      selectedItems: locatedStock["selected_items"],
                      hideOverlay: () {
                        _locateStockBloc.add(const HideOverlayLayerEvent(
                          layer: "preview_move_overlay",
                        ));
                      },
                      onContainerIdEntered: (text) {
                        _locateStockBloc.add(ContainerIdEnteredEvent(
                          text: text,
                        ));
                      },
                      onWarehouseLocationIdEntered: (text) {
                        _locateStockBloc.add(WarehouseLocationIdEnteredEvent(
                          text: text,
                        ));
                      },
                      onMoveItemsTap: () {
                        _locateStockBloc
                            .add(const MoveItemsButtonPressedEvent());
                      },
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
