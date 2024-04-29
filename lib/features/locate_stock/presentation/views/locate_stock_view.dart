import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stock_management_tool/components/custom_container.dart';
import 'package:stock_management_tool/components/custom_elevated_button.dart';
import 'package:stock_management_tool/features/locate_stock/presentation/bloc/locate_stock_bloc.dart';
import 'package:stock_management_tool/features/locate_stock/presentation/widgets/locate_stock_add_new_input_row.dart';
import 'package:stock_management_tool/features/locate_stock/presentation/widgets/locate_stock_input_row.dart';
import 'package:stock_management_tool/injection_container.dart';

class LocateStockView extends StatelessWidget {
  LocateStockView({super.key});

  final LocateStockBloc _locateStockBloc = sl.get<LocateStockBloc>();
  final OverlayPortalController overlayPortalController = OverlayPortalController();

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
    debugPrint("listen: ${state.runtimeType}");
  }

  Widget _blocBuilder(BuildContext context, LocateStockState state) {
    debugPrint("build: ${state.runtimeType}");
    switch (state.runtimeType) {
      case const (LoadingState):
        _locateStockBloc.add(LoadedEvent());
        return _buildLoadingStateWidget();

      case const (ErrorState):
        return _buildErrorStateWidget();

      case const (LoadedState):
        List locatedItems = state.locatedItems!;
        int itemCount = locatedItems.length;
        return _buildLoadedStateWidget(itemCount, locatedItems);

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

  Widget _buildLoadedStateWidget(int itemCount, List locatedItems) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return Stack(
          children: [
            GestureDetector(
              onTap: () {
                if (overlayPortalController.isShowing) {
                  overlayPortalController.hide();
                }
              },
              child: Padding(
                padding: const EdgeInsets.fromLTRB(52, 80, 52, 0),
                child: SizedBox(
                  height: constraints.maxHeight,
                  child: ListView.builder(
                    itemCount: itemCount + 1,
                    shrinkWrap: true,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: index < itemCount
                            ? LocateStockInputRow(
                                query: locatedItems[index],
                                showRemoveButton: itemCount != 1,
                                removeOnTap: () {
                                  _locateStockBloc.add(RemoveLocateStockInputRowEvent(
                                      index: index, locatedItems: locatedItems));
                                },
                                onSearchBySelected: (value) {
                                  _locateStockBloc.add(SearchByFieldSelected(
                                      index: index, searchBy: value, locatedItems: locatedItems));
                                },
                                onIdSelected: (value) {
                                  _locateStockBloc.add(IdSelected(
                                      index: index, ids: value, locatedItems: locatedItems));
                                },
                                // overlayPortalController: overlayPortalController,
                                overlayPortalController: OverlayPortalController(),
                                onShowTableToggled: (value) {
                                  _locateStockBloc.add(ShowTableToggled(
                                      index: index, showTable: value, locatedItems: locatedItems));
                                },
                                onShowDetailsToggled: (value) {
                                  _locateStockBloc.add(ShowDetailsToggled(
                                      index: index,
                                      showDetails: value,
                                      locatedItems: locatedItems));
                                },
                                onCheckBoxToggled: (id, state) {
                                  _locateStockBloc.add(CheckBoxToggled(
                                      index: index,
                                      id: id,
                                      state: state,
                                      locatedItems: locatedItems));
                                },
                                onAllCheckBoxToggled: (state) {
                                  _locateStockBloc.add(AllCheckBoxToggled(
                                      index: index, state: state, locatedItems: locatedItems));
                                },
                              )
                            : LocateStockAddNewInputRow(
                                onTap: () {
                                  _locateStockBloc.add(
                                      AddNewLocateStockInputRowEvent(locatedItems: locatedItems));
                                },
                              ),
                      );
                    },
                  ),
                ),
              ),
            ),
            if (locatedItems.any((element) =>
                (element["selected_ids_details"] != null) &&
                (element["selected_ids_details"].any((ele) => ele["is_selected"] == true))))
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: CustomContainer(
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: CustomElevatedButton(
                        onPressed: () {},
                        text: "Move Selected Items",
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
