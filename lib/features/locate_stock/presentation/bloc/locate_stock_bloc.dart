import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:stock_management_tool/features/locate_stock/domain/usecases/add_new_locate_stock_input_row_usecase.dart';
import 'package:stock_management_tool/features/locate_stock/domain/usecases/id_selected_usecase.dart';
import 'package:stock_management_tool/features/locate_stock/domain/usecases/initial_locate_stock_usecase.dart';
import 'package:stock_management_tool/features/locate_stock/domain/usecases/remove_locate_stock_input_row_usecase.dart';
import 'package:stock_management_tool/features/locate_stock/domain/usecases/search_by_field_selected_usecase.dart';

part 'locate_stock_event.dart';
part 'locate_stock_state.dart';

class LocateStockBloc extends Bloc<LocateStockEvent, LocateStockState> {
  final InitialLocateStockUseCase? _initialLocateStockUseCase;
  final AddNewLocateStockInputRowUseCase? _addNewLocateStockInputRowUseCase;
  final RemoveLocateStockInputRowUseCase? _removeLocateStockInputRowUseCase;
  final SearchByFieldSelectedUseCase? _searchByFieldSelectedUseCase;
  final IdSelectedUseCase? _idSelectedUseCase;

  LocateStockBloc(
      this._initialLocateStockUseCase,
      this._addNewLocateStockInputRowUseCase,
      this._removeLocateStockInputRowUseCase,
      this._searchByFieldSelectedUseCase,
      this._idSelectedUseCase)
      : super(LoadingState()) {
    on<LoadedEvent>(loadedEvent);
    on<AddNewLocateStockInputRowEvent>(addNewLocateStockInputRowEvent);
    on<RemoveLocateStockInputRowEvent>(removeLocateStockInputRowEvent);
    on<SearchByFieldSelected>(searchByFieldSelected);
    on<IdSelected>(idSelected);
  }

  FutureOr<void> loadedEvent(LoadedEvent event, Emitter<LocateStockState> emit) async {
    emit(LoadedState(await _initialLocateStockUseCase!()));
  }

  FutureOr<void> addNewLocateStockInputRowEvent(
      AddNewLocateStockInputRowEvent event, Emitter<LocateStockState> emit) async {
    emit(ReduceDuplicationActionState());
    emit(LoadedState(
        await _addNewLocateStockInputRowUseCase!(params: {"located items": event.locatedItems})));
  }

  FutureOr<void> removeLocateStockInputRowEvent(
      RemoveLocateStockInputRowEvent event, Emitter<LocateStockState> emit) async {
    emit(ReduceDuplicationActionState());
    emit(LoadedState(await _removeLocateStockInputRowUseCase!(
        params: {"index": event.index, "located items": event.locatedItems})));
  }

  FutureOr<void> searchByFieldSelected(
      SearchByFieldSelected event, Emitter<LocateStockState> emit) async {
    emit(ReduceDuplicationActionState());
    emit(LoadedState(await _searchByFieldSelectedUseCase!(params: {
      "index": event.index,
      "search by": event.searchBy,
      "located items": event.locatedItems
    })));
  }

  FutureOr<void> idSelected(IdSelected event, Emitter<LocateStockState> emit) async {
    emit(ReduceDuplicationActionState());
    emit(LoadedState(await _idSelectedUseCase!(
        params: {"index": event.index, "ids": event.ids, "located items": event.locatedItems})));
  }
}
