import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stock_management_tool/features/locate_stock/presentation/bloc/locate_stock_bloc.dart';
import 'package:stock_management_tool/features/locate_stock/presentation/widgets/locate_stock_add_new_input_row.dart';
import 'package:stock_management_tool/features/locate_stock/presentation/widgets/locate_stock_input_row.dart';
import 'package:stock_management_tool/injection_container.dart';

class LocateStockView extends StatelessWidget {
  LocateStockView({super.key});

  final LocateStockBloc _locateStockBloc = sl.get<LocateStockBloc>();
  final OverlayPortalController previewMoveOverlayPortalController =
      OverlayPortalController();

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
    // switch (state.runtimeType) {
    //   case const (PreviewMoveActionState):
    //     print("${state.selectedItems}");
    //     previewMoveOverlayPortalController.show();
    //     return;
    // }
  }

  Widget _blocBuilder(BuildContext context, LocateStockState state) {
    debugPrint("build : LocateStock ${state.runtimeType}");
    switch (state.runtimeType) {
      case const (LoadingState):
        _locateStockBloc.add(const CloudDataChangeEvent());
        // _locateStockBloc.add(LoadedEvent());
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

  Widget _buildLoadedStateWidget(
      int rowCount, Map<String, dynamic> locatedStock) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return Stack(
          children: [
            GestureDetector(
              onTap: () {
                if (previewMoveOverlayPortalController.isShowing) {
                  previewMoveOverlayPortalController.hide();
                }
              },
              child: Padding(
                padding: const EdgeInsets.fromLTRB(52, 80, 52, 0),
                child: SizedBox(
                  height: constraints.maxHeight,
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
                                allIds: locatedStock["all_ids"],
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
                                onIdsChosen: (value) {
                                  _locateStockBloc.add(IdsChosen(
                                      index: index,
                                      chosenIds: value,
                                      locatedStock: locatedStock));
                                },
                                overlayPortalController:
                                    OverlayPortalController(),
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
                                  _locateStockBloc.add(SelectAllCheckBoxToggled(
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
              ),
            ),

            // if (selectedItems["items"] != null &&
            //     selectedItems["items"].isNotEmpty)
            //   Align(
            //     alignment: Alignment.bottomCenter,
            //     child: Padding(
            //       padding: const EdgeInsets.all(25.0),
            //       child: CustomContainer(
            //         child: Padding(
            //           padding: const EdgeInsets.all(15.0),
            //           child: CustomElevatedButton(
            //             onPressed: () {
            //               previewMoveOverlayPortalController.show();
            //               // _locateStockBloc
            //               //     .add(PreviewMoveButtonPressed(locatedItems: locatedItems));
            //             },
            //             child: OverlayPortal(
            //               controller: previewMoveOverlayPortalController,
            //               overlayChildBuilder: (BuildContext context) {
            //                 return Center(
            //                   child: Padding(
            //                     padding: const EdgeInsets.fromLTRB(
            //                         250.0 + 52.0, 90.0, 52.0, 40.0),
            //                     child: SizedBox(
            //                       width: 675,
            //                       height: 360,
            //                       child: Container(
            //                         decoration: BoxDecoration(
            //                           color: const Color(0xFFE0DCDF),
            //                           borderRadius: kBorderRadius,
            //                           boxShadow: kBoxShadowList,
            //                           // backgroundBlendMode: BlendMode.overlay,
            //                         ),
            //                         child: Padding(
            //                           padding: const EdgeInsets.all(20.0),
            //                           child: Container(
            //                             decoration: BoxDecoration(
            //                               color: kSecondaryBackgroundColor,
            //                               borderRadius: kBorderRadius,
            //                               boxShadow: kBoxShadowList,
            //                               // backgroundBlendMode: BlendMode.overlay,
            //                             ),
            //                             child: Padding(
            //                               padding: const EdgeInsets.all(10.0),
            //                               child: SizedBox(
            //                                 width: 400,
            //                                 child: Row(
            //                                   mainAxisSize: MainAxisSize.min,
            //                                   mainAxisAlignment:
            //                                       MainAxisAlignment.center,
            //                                   children: [
            //                                     Padding(
            //                                       padding: const EdgeInsets.all(
            //                                           10.0),
            //                                       child: SizedBox(
            //                                         width: 200,
            //                                         height: 300,
            //                                         child: Column(
            //                                           // mainAxisSize: MainAxisSize.min,
            //                                           children: [
            //                                             Padding(
            //                                               padding:
            //                                                   const EdgeInsets
            //                                                       .all(4.0),
            //                                               child: Container(
            //                                                 decoration:
            //                                                     BoxDecoration(
            //                                                   color:
            //                                                       kButtonBackgroundColor,
            //                                                   borderRadius:
            //                                                       kBorderRadius,
            //                                                   boxShadow:
            //                                                       kBoxShadowList,
            //                                                 ),
            //                                                 child: Padding(
            //                                                   padding:
            //                                                       const EdgeInsets
            //                                                           .all(8.0),
            //                                                   child: Center(
            //                                                     child: Text(
            //                                                       "Item Total:  ${selectedItems["items"].length}",
            //                                                       style:
            //                                                           kLabelTextStyle,
            //                                                     ),
            //                                                   ),
            //                                                 ),
            //                                               ),
            //                                             ),
            //                                             Expanded(
            //                                               child:
            //                                                   ListView.builder(
            //                                                 itemCount:
            //                                                     selectedItems[
            //                                                             "items"]
            //                                                         .length,
            //                                                 scrollDirection:
            //                                                     Axis.vertical,
            //                                                 controller:
            //                                                     ScrollController(),
            //                                                 physics:
            //                                                     const BouncingScrollPhysics(),
            //                                                 shrinkWrap: true,
            //                                                 itemBuilder:
            //                                                     (BuildContext
            //                                                             context,
            //                                                         int index) {
            //                                                   return Padding(
            //                                                     padding:
            //                                                         const EdgeInsets
            //                                                             .all(
            //                                                             4.0),
            //                                                     child:
            //                                                         Container(
            //                                                       decoration:
            //                                                           BoxDecoration(
            //                                                         color:
            //                                                             kTertiaryBackgroundColor,
            //                                                         borderRadius:
            //                                                             kBorderRadius,
            //                                                         boxShadow:
            //                                                             kBoxShadowList,
            //                                                       ),
            //                                                       child:
            //                                                           Padding(
            //                                                         padding:
            //                                                             const EdgeInsets
            //                                                                 .all(
            //                                                                 8.0),
            //                                                         child:
            //                                                             Center(
            //                                                           child:
            //                                                               Text(
            //                                                             "Item Id:   ${selectedItems["items"][index]["id"]}",
            //                                                             style:
            //                                                                 kLabelTextStyle,
            //                                                           ),
            //                                                         ),
            //                                                       ),
            //                                                     ),
            //                                                   );
            //                                                 },
            //                                               ),
            //                                             ),
            //                                           ],
            //                                         ),
            //                                       ),
            //                                     ),
            //                                     const SizedBox(
            //                                       width: 20,
            //                                     ),
            //                                     Padding(
            //                                       padding: const EdgeInsets.all(
            //                                           10.0),
            //                                       child: Column(
            //                                         mainAxisAlignment:
            //                                             MainAxisAlignment.start,
            //                                         mainAxisSize:
            //                                             MainAxisSize.min,
            //                                         children: [
            //                                           Padding(
            //                                             padding:
            //                                                 const EdgeInsets
            //                                                     .all(10.0),
            //                                             child: SizedBox(
            //                                               width: 330.0,
            //                                               child:
            //                                                   CustomDropdownInputField(
            //                                                 text:
            //                                                     "Container Id",
            //                                                 controller: TextEditingController(
            //                                                     text: selectedItems[
            //                                                         "container_text"]),
            //                                                 items: selectedItems[
            //                                                     "container_ids"],
            //                                                 onSelected:
            //                                                     (value) {
            //                                                   selectedItems[
            //                                                           "container_text"] =
            //                                                       value;
            //                                                   _locateStockBloc.add(ContainerIdEntered(
            //                                                       locatedItems:
            //                                                           locatedItems,
            //                                                       selectedItems:
            //                                                           selectedItems));
            //                                                 },
            //                                               ),
            //                                             ),
            //                                           ),
            //                                           Padding(
            //                                             padding:
            //                                                 const EdgeInsets
            //                                                     .all(10.0),
            //                                             child: SizedBox(
            //                                               width: 330.0,
            //                                               child:
            //                                                   CustomDropdownInputField(
            //                                                 text:
            //                                                     "Warehouse Location Id",
            //                                                 controller: TextEditingController(
            //                                                     text: selectedItems[
            //                                                         "warehouse_location_text"]),
            //                                                 items: selectedItems[
            //                                                     "warehouse_location_ids"],
            //                                                 onSelected:
            //                                                     (value) {
            //                                                   selectedItems[
            //                                                           "warehouse_location_text"] =
            //                                                       value;
            //                                                   _locateStockBloc.add(WarehouseLocationIdEntered(
            //                                                       locatedItems:
            //                                                           locatedItems,
            //                                                       selectedItems:
            //                                                           selectedItems));
            //                                                 },
            //                                               ),
            //                                             ),
            //                                           ),
            //                                           const SizedBox(
            //                                               height: 15),
            //                                           Padding(
            //                                             padding:
            //                                                 const EdgeInsets
            //                                                     .all(10.0),
            //                                             child: SizedBox(
            //                                               width: 330.0,
            //                                               child:
            //                                                   CustomElevatedButton(
            //                                                 onPressed: () {
            //                                                   _locateStockBloc.add(MoveItemsButtonPressed(
            //                                                       locatedItems:
            //                                                           locatedItems,
            //                                                       selectedItems:
            //                                                           selectedItems));
            //                                                   previewMoveOverlayPortalController
            //                                                       .hide();
            //                                                 },
            //                                                 text: "Move Items",
            //                                               ),
            //                                             ),
            //                                           ),
            //                                         ],
            //                                       ),
            //                                     ),
            //                                   ],
            //                                 ),
            //                               ),
            //                             ),
            //                           ),
            //                         ),
            //                       ),
            //                     ),
            //                   ),
            //                 );
            //               },
            //               child: Text(
            //                 "Preview Move",
            //                 textAlign: TextAlign.center,
            //                 softWrap: false,
            //                 style: kButtonTextStyle,
            //               ),
            //             ),
            //           ),
            //         ),
            //       ),
            //     ),
            //   ),
          ],
        );
      },
    );
  }
}
