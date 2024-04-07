import 'dart:async';

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
  ) : super(LoadingState()) {
    on<LoadedEvent>(loadedEvent);
    on<CategorySelectedEvent>(categorySelectedEvent);
    on<SkuSelectedEvent>(skuSelectedEvent);
    on<CheckBoxTapEvent>(checkBoxTapEvent);
    on<AddNewStockButtonClickedEvent>(addNewStockButtonClickedEvent);
  }

  FutureOr<void> loadedEvent(LoadedEvent event, Emitter<AddNewStockState> emit) async {
    emit(LoadedState(await _stockInitialInputFieldsUseCase!()));
  }

  FutureOr<void> categorySelectedEvent(
      CategorySelectedEvent event, Emitter<AddNewStockState> emit) async {
    emit(LoadedState([
      event.fields![0],
      ...await _stockCategoryBasedInputFieldsUseCase!(params: event.fields![0].textValue)
    ]));
  }

  FutureOr<void> skuSelectedEvent(SkuSelectedEvent event, Emitter<AddNewStockState> emit) async {
    emit(ReduceDuplicationActionState());
    emit(LoadedState(await _autofillFieldsWithSelectedSkuUseCase!(params: event.fields!)));
  }

  FutureOr<void> checkBoxTapEvent(CheckBoxTapEvent event, Emitter<AddNewStockState> emit) async {
    emit(ReduceDuplicationActionState());
    emit(LoadedState(event.fields!));
  }

  FutureOr<void> addNewStockButtonClickedEvent(
      AddNewStockButtonClickedEvent event, Emitter<AddNewStockState> emit) async {
    await _addNewStockUseCase!(params: event.fields!);
    emit(NewStockAddedActionState());
    emit(LoadedState(await _stockInitialInputFieldsUseCase!()));
  }
}
