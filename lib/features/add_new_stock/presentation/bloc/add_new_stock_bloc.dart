import 'dart:async';
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:stock_management_tool/features/add_new_stock/domain/usecases/add_new_stock_usecase.dart';
import 'package:stock_management_tool/features/add_new_stock/domain/usecases/autofill_fields_with_selected_sku_usecase.dart';
import 'package:stock_management_tool/features/add_new_stock/domain/usecases/get_stock_category_based_input_fields_usecase.dart';
import 'package:stock_management_tool/features/add_new_stock/domain/usecases/get_stock_initial_input_fields_usecase.dart';

part 'add_new_stock_event.dart';
part 'add_new_stock_state.dart';

class AddNewStockBloc extends Bloc<AddNewStockEvent, AddNewStockState> {
  final GetStockInitialInputFieldsUseCase? _stockInitialInputFieldsUseCase;
  final GetStockCategoryBasedInputFieldsUseCase? _stockCategoryBasedInputFieldsUseCase;
  final AutofillFieldsWithSelectedSkuUseCase? _autofillFieldsWithSelectedSkuUseCase;
  final AddNewStockUseCase? _addNewStockUseCase;

  AddNewStockBloc(
    this._stockInitialInputFieldsUseCase,
    this._stockCategoryBasedInputFieldsUseCase,
    this._autofillFieldsWithSelectedSkuUseCase,
    this._addNewStockUseCase,
  ) : super(AddNewStockLoadingState()) {
    on<AddNewStockActionEvent>(addNewStockActionEvent);
    on<AddNewStockLoadedEvent>(addNewStockLoadedEvent);
    on<AddNewStockCategorySelectedEvent>(addNewStockCategorySelectedEvent);
    on<AddNewStockSkuSelectedEvent>(addNewStockSKUSelectedEvent);
    on<AddNewStockCheckBoxTapEvent>(addNewStockCheckBoxTapEvent);
    on<AddNewStockButtonClickedEvent>(addNewStockButtonClickedEvent);
    on<AddNewStockErrorEvent>(addNewStockErrorEvent);
  }

  FutureOr<void> addNewStockActionEvent(
      AddNewStockActionEvent event, Emitter<AddNewStockState> emit) {}

  FutureOr<void> addNewStockLoadedEvent(
      AddNewStockLoadedEvent event, Emitter<AddNewStockState> emit) async {
    emit(AddNewStockLoadedState(await _stockInitialInputFieldsUseCase!()));
  }

  FutureOr<void> addNewStockCategorySelectedEvent(
      AddNewStockCategorySelectedEvent event, Emitter<AddNewStockState> emit) async {
    emit(AddNewStockLoadedState([
      ...[event.fields![0]],
      ...await _stockCategoryBasedInputFieldsUseCase!(params: event.fields![0].textValue)
    ]));
  }

  FutureOr<void> addNewStockSKUSelectedEvent(
      AddNewStockSkuSelectedEvent event, Emitter<AddNewStockState> emit) async {
    emit(AddNewStockActionState());
    emit(AddNewStockLoadedState(
        await _autofillFieldsWithSelectedSkuUseCase!(params: event.fields!)));
  }

  FutureOr<void> addNewStockCheckBoxTapEvent(
      AddNewStockCheckBoxTapEvent event, Emitter<AddNewStockState> emit) async {
    emit(AddNewStockActionState());
    emit(AddNewStockLoadedState(event.fields!));
  }

  FutureOr<void> addNewStockButtonClickedEvent(
      AddNewStockButtonClickedEvent event, Emitter<AddNewStockState> emit) async {
    await _addNewStockUseCase!(params: event.fields!);
    emit(AddNewStockLoadedState(await _stockInitialInputFieldsUseCase!()));
  }

  FutureOr<void> addNewStockErrorEvent(
      AddNewStockErrorEvent event, Emitter<AddNewStockState> emit) async {}
}
