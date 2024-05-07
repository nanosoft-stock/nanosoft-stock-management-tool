import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stock_management_tool/components/custom_container.dart';
import 'package:stock_management_tool/components/custom_elevated_button.dart';
import 'package:stock_management_tool/constants/constants.dart';
import 'package:stock_management_tool/features/locate_stock/presentation/bloc/locate_stock_bloc.dart';
import 'package:stock_management_tool/features/locate_stock/presentation/widgets/custom_completed_moves_overlay.dart';
import 'package:stock_management_tool/features/locate_stock/presentation/widgets/custom_multiple_search_selection_overlay.dart';
import 'package:stock_management_tool/features/locate_stock/presentation/widgets/custom_pending_moves_overlay.dart';
import 'package:stock_management_tool/features/locate_stock/presentation/widgets/custom_preview_move_overlay.dart';
import 'package:stock_management_tool/features/locate_stock/presentation/widgets/locate_stock_add_new_input_row.dart';
import 'package:stock_management_tool/features/locate_stock/presentation/widgets/locate_stock_input_row.dart';
import 'package:stock_management_tool/injection_container.dart';

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
    debugPrint("listen: LocateStock ${state.runtimeType}");
    switch (state.runtimeType) {
      default:
        return;
    }
  }

  Widget _blocBuilder(BuildContext context, LocateStockState state) {
    debugPrint("build : LocateStock ${state.runtimeType}");
    switch (state.runtimeType) {
      case const (LoadingState):
        _locateStockBloc.add(const CloudDataChangeEvent());
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
      child: CircularProgressIndicator(),
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
        return Stack(
          children: [
            if (locatedStock["layers"].contains("base"))
              Padding(
                padding: const EdgeInsets.fromLTRB(52, 5, 52, 0),
                child: SizedBox(
                  height: constraints.maxHeight,
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
                                      _locateStockBloc.add(
                                          PendingMovesButtonPressed(
                                              locatedStock: locatedStock));
                                    },
                                    child: const Text("Pending Moves"),
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
                                      _locateStockBloc.add(
                                          CompletedMovesButtonPressed(
                                              locatedStock: locatedStock));
                                    },
                                    child: const Text("Completed Moves"),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: rowCount + 1,
                          shrinkWrap: true,
                          controller: ScrollController(),
                          physics: const BouncingScrollPhysics(),
                          itemBuilder: (BuildContext context, int index) {
                            return Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: index < rowCount
                                  ? LocateStockInputRow(
                                      rowData: locatedStock["rows"][index],
                                      showRemoveButton: rowCount != 1,
                                      removeOnTap: () {
                                        _locateStockBloc.add(
                                            RemoveInputRowEvent(
                                                index: index,
                                                locatedStock: locatedStock));
                                      },
                                      onSearchBySelected: (value) {
                                        _locateStockBloc.add(
                                            SearchByFieldFilled(
                                                index: index,
                                                searchBy: value,
                                                locatedStock: locatedStock));
                                      },
                                      onChooseIds: () {
                                        _locateStockBloc.add(
                                            ChooseIdsButtonPressed(
                                                index: index,
                                                locatedStock: locatedStock));
                                      },
                                      onShowTableToggled: (value) {
                                        _locateStockBloc.add(SwitchTableView(
                                            index: index,
                                            showTable: value,
                                            locatedStock: locatedStock));
                                      },
                                      onShowDetailsToggled: (value) {
                                        _locateStockBloc.add(
                                            SwitchStockViewMode(
                                                index: index,
                                                mode: value,
                                                locatedStock: locatedStock));
                                      },
                                      onCheckBoxToggled: (id, state) {
                                        _locateStockBloc.add(IdCheckBoxToggled(
                                            index: index,
                                            id: id,
                                            state: state,
                                            locatedStock: locatedStock));
                                      },
                                      onAllCheckBoxToggled: (state) {
                                        _locateStockBloc.add(
                                            SelectAllCheckBoxToggled(
                                                index: index,
                                                state: state,
                                                locatedStock: locatedStock));
                                      },
                                    )
                                  : LocateStockAddNewInputRow(
                                      onTap: () {
                                        _locateStockBloc.add(
                                            AddNewInputRowEvent(
                                                locatedStock: locatedStock));
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
                          _locateStockBloc.add(PreviewMoveButtonPressed(
                              locatedStock: locatedStock));
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
            if (locatedStock["layers"]
                    .contains("multiple_search_selection_overlay") &&
                rowIndex != null)
              CustomMultipleSearchSelectionOverlay(
                key: UniqueKey(),
                allIds: locatedStock["all_ids"],
                rowData: locatedStock["rows"][rowIndex],
                hideOverlay: () {
                  _locateStockBloc.add(HideOverlayLayerEvent(
                      layer: "multiple_search_selection_overlay",
                      locatedStock: locatedStock));
                },
                onIdEntered: (text) {
                  _locateStockBloc.add(IdEntered(
                      index: rowIndex,
                      chosenId: text,
                      locatedStock: locatedStock));
                },
                onDone: (value) {
                  _locateStockBloc.add(IdsChosen(
                      index: rowIndex,
                      chosenIds: value,
                      locatedStock: locatedStock));
                },
              ),
            if (locatedStock["layers"].contains("preview_move_overlay"))
              CustomPreviewMoveOverlay(
                key: UniqueKey(),
                selectedItems: locatedStock["selected_items"],
                hideOverlay: () {
                  _locateStockBloc.add(HideOverlayLayerEvent(
                      layer: "preview_move_overlay",
                      locatedStock: locatedStock));
                },
                onContainerIdEntered: (text) {
                  _locateStockBloc.add(ContainerIdEntered(
                    text: text,
                    locatedStock: locatedStock,
                  ));
                },
                onWarehouseLocationIdEntered: (text) {
                  _locateStockBloc.add(WarehouseLocationIdEntered(
                    text: text,
                    locatedStock: locatedStock,
                  ));
                },
                onMoveItemsTap: () {
                  _locateStockBloc.add(MoveItemsButtonPressed(
                    locatedStock: locatedStock,
                  ));
                },
              ),
            if (locatedStock["layers"].contains("pending_moves_overlay"))
              CustomPendingMovesOverlay(
                key: UniqueKey(),
                pendingStateItems: locatedStock["pending_state_items"],
                hideOverlay: () {
                  _locateStockBloc.add(HideOverlayLayerEvent(
                      layer: "pending_moves_overlay",
                      locatedStock: locatedStock));
                },
                onExpand: (index, value) {
                  _locateStockBloc.add(ExpandPendingMovesItem(
                    index: index,
                    isExpanded: value,
                    locatedStock: locatedStock,
                  ));
                },
                onCompleted: (value) {
                  _locateStockBloc.add(CompleteMoveButtonPressed(
                    index: value,
                    locatedStock: locatedStock,
                  ));
                },
                onRemove: (value) {
                  _locateStockBloc.add(CancelMoveButtonPressed(
                    index: value,
                    locatedStock: locatedStock,
                  ));
                },
              ),
            if (locatedStock["layers"].contains("completed_moves_overlay"))
              CustomCompletedMovesOverlay(
                key: UniqueKey(),
                completedStateItems: locatedStock["completed_state_items"],
                hideOverlay: () {
                  _locateStockBloc.add(HideOverlayLayerEvent(
                      layer: "completed_moves_overlay",
                      locatedStock: locatedStock));
                },
                onExpand: (index, value) {
                  _locateStockBloc.add(ExpandCompletedMovesItem(
                    index: index,
                    isExpanded: value,
                    locatedStock: locatedStock,
                  ));
                },
              ),
          ],
        );
      },
    );
  }
}
