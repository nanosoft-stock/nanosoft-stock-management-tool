import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stock_management_tool/features/locate_stock/presentation/bloc/locate_stock_bloc.dart';
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
        return Padding(
          padding: const EdgeInsets.fromLTRB(52, 80, 52, 40),
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
                          index: index,
                          locatedItems: locatedItems,
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
                                index: index, id: value, locatedItems: locatedItems));
                          },
                        )
                      : LocateStockAddNewInputRow(
                          onTap: () {
                            _locateStockBloc
                                .add(AddNewLocateStockInputRowEvent(locatedItems: locatedItems));
                          },
                        ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
