import 'dart:async';
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:stock_management_tool/features/add_new_stock/domain/usecases/add_new_stock_usecase.dart';
import 'package:stock_management_tool/features/add_new_stock/domain/usecases/checkbox_toggled_add_new_stock_usecase.dart';
import 'package:stock_management_tool/features/add_new_stock/domain/usecases/get_stock_initial_input_fields_usecase.dart';
import 'package:stock_management_tool/features/add_new_stock/domain/usecases/value_changed_add_new_stock_usecase.dart';

part 'add_new_stock_event.dart';
part 'add_new_stock_state.dart';

class AddNewStockBloc extends Bloc<AddNewStockEvent, AddNewStockState> {
  final GetStockInitialInputFieldsUseCase? _stockInitialInputFieldsUseCase;
  final ValueChangedAddNewStockUseCase? _valueChangedAddNewStockUseCase;
  final CheckboxToggledAddNewStockUseCase? _checkboxToggledAddNewStockUseCase;
  final AddNewStockUseCase? _addNewStockUseCase;

  AddNewStockBloc(
    this._stockInitialInputFieldsUseCase,
    this._valueChangedAddNewStockUseCase,
    this._checkboxToggledAddNewStockUseCase,
    this._addNewStockUseCase,
  ) : super(LoadingState()) {
    on<LoadedEvent>(loadedEvent);
    on<ValueTypedEvent>(valueTypedEvent);
    on<ValueSelectedEvent>(valueSelectedEvent);
    on<CheckBoxTapEvent>(checkBoxTapEvent);
    on<AddNewStockButtonClickedEvent>(addNewStockButtonClickedEvent);
  }

  FutureOr<void> loadedEvent(
      LoadedEvent event, Emitter<AddNewStockState> emit) async {
    emit(LoadedState(await _stockInitialInputFieldsUseCase!()));
  }

  FutureOr<void> valueTypedEvent(
      ValueTypedEvent event, Emitter<AddNewStockState> emit) async {
    await _valueChangedAddNewStockUseCase!(params: {
      "field": event.field,
      "value": event.value,
      "fields": event.fields,
    });
  }

  FutureOr<void> valueSelectedEvent(
      ValueSelectedEvent event, Emitter<AddNewStockState> emit) async {
    emit(LoadedState(await _valueChangedAddNewStockUseCase!(params: {
      "field": event.field,
      "value": event.value,
      "fields": event.fields,
    })));
  }

  FutureOr<void> checkBoxTapEvent(
      CheckBoxTapEvent event, Emitter<AddNewStockState> emit) async {
    emit(LoadedState(await _checkboxToggledAddNewStockUseCase!(params: {
      "field": event.field,
      "value": event.value,
      "fields": event.fields,
    })));
  }

  FutureOr<void> addNewStockButtonClickedEvent(
      AddNewStockButtonClickedEvent event,
      Emitter<AddNewStockState> emit) async {
    emit(LoadedState(
        await _addNewStockUseCase!(params: {"fields": event.fields!})));
    emit(NewStockAddedActionState());
  }
}
