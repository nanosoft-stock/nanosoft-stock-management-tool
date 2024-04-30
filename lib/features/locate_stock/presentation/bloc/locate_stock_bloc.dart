import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:stock_management_tool/constants/enums.dart';
import 'package:stock_management_tool/features/locate_stock/domain/usecases/add_new_locate_stock_input_row_usecase.dart';
import 'package:stock_management_tool/features/locate_stock/domain/usecases/all_checkbox_toggled_usecase.dart';
import 'package:stock_management_tool/features/locate_stock/domain/usecases/checkbox_toggled_usecase.dart';
import 'package:stock_management_tool/features/locate_stock/domain/usecases/get_selected_items_usecase.dart';
import 'package:stock_management_tool/features/locate_stock/domain/usecases/id_selected_usecase.dart';
import 'package:stock_management_tool/features/locate_stock/domain/usecases/initial_locate_stock_usecase.dart';
import 'package:stock_management_tool/features/locate_stock/domain/usecases/remove_locate_stock_input_row_usecase.dart';
import 'package:stock_management_tool/features/locate_stock/domain/usecases/search_by_field_selected_usecase.dart';
import 'package:stock_management_tool/features/locate_stock/domain/usecases/show_details_toggled_usecase.dart';
import 'package:stock_management_tool/features/locate_stock/domain/usecases/show_table_toggled_usecase.dart';

part 'locate_stock_event.dart';
part 'locate_stock_state.dart';

class LocateStockBloc extends Bloc<LocateStockEvent, LocateStockState> {
  final InitialLocateStockUseCase? _initialLocateStockUseCase;
  final AddNewLocateStockInputRowUseCase? _addNewLocateStockInputRowUseCase;
  final RemoveLocateStockInputRowUseCase? _removeLocateStockInputRowUseCase;
  final SearchByFieldSelectedUseCase? _searchByFieldSelectedUseCase;
  final IdSelectedUseCase? _idSelectedUseCase;
  final ShowTableToggledUseCase? _showTableToggledUseCase;
  final ShowDetailsToggledUseCase? _showDetailsToggledUseCase;
  final CheckBoxToggledUseCase? _checkBoxToggledUseCase;
  final AllCheckBoxToggledUseCase? _allCheckBoxToggledUseCase;
  final GetSelectedItemsUseCase? _getSelectedItemsUseCase;

  LocateStockBloc(
      this._initialLocateStockUseCase,
      this._addNewLocateStockInputRowUseCase,
      this._removeLocateStockInputRowUseCase,
      this._searchByFieldSelectedUseCase,
      this._idSelectedUseCase,
      this._showTableToggledUseCase,
      this._showDetailsToggledUseCase,
      this._checkBoxToggledUseCase,
      this._allCheckBoxToggledUseCase,
      this._getSelectedItemsUseCase)
      : super(LoadingState()) {
    on<LoadedEvent>(loadedEvent);
    on<AddNewLocateStockInputRowEvent>(addNewLocateStockInputRowEvent);
    on<RemoveLocateStockInputRowEvent>(removeLocateStockInputRowEvent);
    on<SearchByFieldSelected>(searchByFieldSelected);
    on<IdSelected>(idSelected);
    on<ShowDetailsToggled>(showDetailsToggled);
    on<ShowTableToggled>(showTableToggled);
    on<CheckBoxToggled>(checkBoxToggled);
    on<AllCheckBoxToggled>(allCheckBoxToggled);
    on<PreviewMoveButtonPressed>(previewMoveButtonPressed);
  }

  FutureOr<void> loadedEvent(LoadedEvent event, Emitter<LocateStockState> emit) async {
    emit(LoadedState(locatedItems: await _initialLocateStockUseCase!(), selectedItems: const {}));
  }

  FutureOr<void> addNewLocateStockInputRowEvent(
      AddNewLocateStockInputRowEvent event, Emitter<LocateStockState> emit) async {
    emit(ReduceDuplicationActionState());
    emit(LoadedState(
        locatedItems:
            await _addNewLocateStockInputRowUseCase!(params: {"located_items": event.locatedItems}),
        selectedItems: const {}));
  }

  FutureOr<void> removeLocateStockInputRowEvent(
      RemoveLocateStockInputRowEvent event, Emitter<LocateStockState> emit) async {
    emit(ReduceDuplicationActionState());
    emit(LoadedState(
        locatedItems: await _removeLocateStockInputRowUseCase!(
            params: {"index": event.index, "located_items": event.locatedItems}),
        selectedItems: const {}));
  }

  FutureOr<void> searchByFieldSelected(
      SearchByFieldSelected event, Emitter<LocateStockState> emit) async {
    emit(ReduceDuplicationActionState());
    emit(LoadedState(
        locatedItems: await _searchByFieldSelectedUseCase!(params: {
          "index": event.index,
          "search_by": event.searchBy,
          "located_items": event.locatedItems
        }),
        selectedItems: const {}));
  }

  FutureOr<void> idSelected(IdSelected event, Emitter<LocateStockState> emit) async {
    emit(ReduceDuplicationActionState());
    emit(LoadedState(
        locatedItems: await _idSelectedUseCase!(
            params: {"index": event.index, "ids": event.ids, "located_items": event.locatedItems}),
        selectedItems: await _getSelectedItemsUseCase!(params: {
          "located_items": event.locatedItems,
        })));
  }

  FutureOr<void> showTableToggled(ShowTableToggled event, Emitter<LocateStockState> emit) async {
    emit(ReduceDuplicationActionState());
    emit(LoadedState(
        locatedItems: await _showTableToggledUseCase!(params: {
          "index": event.index,
          "show_table": event.showTable,
          "located_items": event.locatedItems
        }),
        selectedItems: await _getSelectedItemsUseCase!(params: {
          "located_items": event.locatedItems,
        })));
  }

  FutureOr<void> showDetailsToggled(
      ShowDetailsToggled event, Emitter<LocateStockState> emit) async {
    emit(ReduceDuplicationActionState());
    emit(LoadedState(
        locatedItems: await _showDetailsToggledUseCase!(params: {
          "index": event.index,
          "show_details": event.showDetails,
          "located_items": event.locatedItems
        }),
        selectedItems: await _getSelectedItemsUseCase!(params: {
          "located_items": event.locatedItems,
        })));
  }

  FutureOr<void> checkBoxToggled(CheckBoxToggled event, Emitter<LocateStockState> emit) async {
    emit(ReduceDuplicationActionState());
    emit(LoadedState(
        locatedItems: await _checkBoxToggledUseCase!(params: {
          "index": event.index,
          "id": event.id,
          "state": event.state,
          "located_items": event.locatedItems,
        }),
        selectedItems: await _getSelectedItemsUseCase!(params: {
          "located_items": event.locatedItems,
        })));
  }

  FutureOr<void> allCheckBoxToggled(
      AllCheckBoxToggled event, Emitter<LocateStockState> emit) async {
    emit(ReduceDuplicationActionState());
    emit(LoadedState(
        locatedItems: await _allCheckBoxToggledUseCase!(params: {
          "index": event.index,
          "state": event.state,
          "located_items": event.locatedItems,
        }),
        selectedItems: await _getSelectedItemsUseCase!(params: {
          "located_items": event.locatedItems,
        })));
  }

  FutureOr<void> previewMoveButtonPressed(
      PreviewMoveButtonPressed event, Emitter<LocateStockState> emit) async {
    emit(ReduceDuplicationActionState());
    emit(LoadedState(
        locatedItems: event.locatedItems as List<Map<String, dynamic>>?,
        selectedItems: await _getSelectedItemsUseCase!(params: {
          "located_items": event.locatedItems,
        })));
  }
}
