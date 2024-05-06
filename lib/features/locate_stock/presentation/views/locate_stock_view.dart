import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:multiple_search_selection/multiple_search_selection.dart';
import 'package:stock_management_tool/components/custom_container.dart';
import 'package:stock_management_tool/components/custom_elevated_button.dart';
import 'package:stock_management_tool/constants/constants.dart';
import 'package:stock_management_tool/features/locate_stock/presentation/bloc/locate_stock_bloc.dart';
import 'package:stock_management_tool/features/locate_stock/presentation/widgets/custom_completed_moves_overlay_entry.dart';
import 'package:stock_management_tool/features/locate_stock/presentation/widgets/custom_multiple_search_selection_overlay_entry.dart';
import 'package:stock_management_tool/features/locate_stock/presentation/widgets/custom_pending_moves_overlay_entry.dart';
import 'package:stock_management_tool/features/locate_stock/presentation/widgets/custom_preview_move_overlay_entry.dart';
import 'package:stock_management_tool/features/locate_stock/presentation/widgets/locate_stock_add_new_input_row.dart';
import 'package:stock_management_tool/features/locate_stock/presentation/widgets/locate_stock_input_row.dart';
import 'package:stock_management_tool/injection_container.dart';

class LocateStockView extends StatelessWidget {
  LocateStockView({super.key});

  final LocateStockBloc _locateStockBloc = sl.get<LocateStockBloc>();
  final OverlayPortalController previewMoveOverlayPortalController =
      OverlayPortalController();
  final MultipleSearchController multipleSearchController =
      MultipleSearchController();

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
      case const (MultipleSelectionOverlayActionState):
        int index = state.index!;
        Map<String, dynamic> locatedStock = state.locatedStock!;

        return _buildMultipleSelectionOverlay(context, index, locatedStock);

      case const (PreviewMoveActionState):
        Map<String, dynamic> locatedStock = state.locatedStock!;
        Map<String, dynamic> selectedItems = state.selectedItems!;

        return _buildPreviewMoveOverlay(context, locatedStock, selectedItems);

      case const (PendingMoveActionState):
        Map<String, dynamic> locatedStock = state.locatedStock!;
        List<Map<String, dynamic>> pendingStateItems = state.pendingStateItems!;

        return _buildPendingStateItemsOverlay(
            context, locatedStock, pendingStateItems);

      case const (CompletedMovesActionState):
        Map<String, dynamic> locatedStock = state.locatedStock!;
        List<Map<String, dynamic>> completedStateItems =
            state.completedStateItems!;

        return _buildCompletedStateItemsOverlay(
            context, locatedStock, completedStateItems);

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
        Map<String, dynamic> locatedStock = state.locatedStock!;
        int rowCount = locatedStock["rows"].length;

        return _buildLoadedStateWidget(rowCount, locatedStock);

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

  void _buildMultipleSelectionOverlay(
      BuildContext context, int index, Map locatedStock) {
    OverlayEntry? overlayEntry;
    overlayEntry = OverlayEntry(
      builder: (BuildContext context) {
        return CustomMultipleSearchSelectionOverlayEntry(
          allIds: locatedStock["all_ids"],
          rowData: locatedStock["rows"][index],
          controller: multipleSearchController,
          hideOverlay: () {
            overlayEntry!.remove();
            _locateStockBloc.add(LoadedEvent(
                locatedStock: locatedStock as Map<String, dynamic>));
          },
          onDone: () {
            _locateStockBloc.add(IdsChosen(
                index: index,
                chosenIds: multipleSearchController.getPickedItems(),
                locatedStock: locatedStock as Map<String, dynamic>,
                removeOverlayEntry: () {
                  overlayEntry!.remove();
                }));
          },
        );
      },
    );
    Overlay.of(context).insert(overlayEntry);
  }

  void _buildPreviewMoveOverlay(
      BuildContext context, Map locatedStock, Map selectedItems) {
    OverlayEntry? overlayEntry;
    overlayEntry = OverlayEntry(
      builder: (BuildContext context) {
        return CustomPreviewMoveOverlayEntry(
          selectedItems: selectedItems,
          hideOverlay: () {
            overlayEntry!.remove();
            _locateStockBloc.add(LoadedEvent(
                locatedStock: locatedStock as Map<String, dynamic>));
          },
          onContainerIdEntered: (text) {
            _locateStockBloc.add(ContainerIdEntered(
                text: text,
                locatedStock: locatedStock as Map<String, dynamic>,
                selectedItems: selectedItems as Map<String, dynamic>,
                removeOverlayEntry: () {
                  overlayEntry!.remove();
                }));
          },
          onWarehouseLocationIdEntered: (text) {
            _locateStockBloc.add(WarehouseLocationIdEntered(
                text: text,
                locatedStock: locatedStock as Map<String, dynamic>,
                selectedItems: selectedItems as Map<String, dynamic>,
                removeOverlayEntry: () {
                  overlayEntry!.remove();
                }));
          },
          onMoveItemsTap: () {
            _locateStockBloc.add(MoveItemsButtonPressed(
                locatedStock: locatedStock as Map<String, dynamic>,
                selectedItems: selectedItems as Map<String, dynamic>,
                removeOverlayEntry: () {
                  overlayEntry!.remove();
                }));
          },
        );
      },
    );
    Overlay.of(context).insert(overlayEntry);
  }

  void _buildPendingStateItemsOverlay(
      BuildContext context, Map locatedStock, List pendingStateItems) {
    OverlayEntry? overlayEntry;
    overlayEntry = OverlayEntry(
      builder: (BuildContext context) {
        return CustomPendingMovesOverlayEntry(
          pendingStateItems: pendingStateItems,
          hideOverlay: () {
            overlayEntry!.remove();
            _locateStockBloc.add(LoadedEvent(
                locatedStock: locatedStock as Map<String, dynamic>));
          },
          onCompleted: (value) {
            _locateStockBloc.add(CompleteMoveButtonPressed(
                index: value,
                locatedStock: locatedStock as Map<String, dynamic>,
                pendingStateItems:
                    pendingStateItems as List<Map<String, dynamic>>,
                removeOverlayEntry: () {
                  overlayEntry!.remove();
                }));
          },
          onRemove: (value) {
            _locateStockBloc.add(CancelMoveButtonPressed(
                index: value,
                locatedStock: locatedStock as Map<String, dynamic>,
                pendingStateItems:
                    pendingStateItems as List<Map<String, dynamic>>,
                removeOverlayEntry: () {
                  overlayEntry!.remove();
                }));
          },
        );
      },
    );
    Overlay.of(context).insert(overlayEntry);
  }

  void _buildCompletedStateItemsOverlay(
      BuildContext context, Map locatedStock, List completedStateItems) {
    OverlayEntry? overlayEntry;
    overlayEntry = OverlayEntry(
      builder: (BuildContext context) {
        return CustomCompletedMovesOverlayEntry(
          completedStateItems: completedStateItems,
          hideOverlay: () {
            overlayEntry!.remove();
            _locateStockBloc.add(LoadedEvent(
                locatedStock: locatedStock as Map<String, dynamic>));
          },
        );
      },
    );
    Overlay.of(context).insert(overlayEntry);
  }

  Widget _buildLoadedStateWidget(
      int rowCount, Map<String, dynamic> locatedStock) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return Stack(
          children: [
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
                                      _locateStockBloc.add(RemoveInputRowEvent(
                                          index: index,
                                          locatedStock: locatedStock));
                                    },
                                    onSearchBySelected: (value) {
                                      _locateStockBloc.add(SearchByFieldFilled(
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
                                      _locateStockBloc.add(SwitchStockViewMode(
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
                                      _locateStockBloc.add(AddNewInputRowEvent(
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
            if (locatedStock["selected_item_ids"] != null &&
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
                        // ),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
