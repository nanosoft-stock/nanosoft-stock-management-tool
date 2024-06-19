import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:stock_management_tool/features/add_new_product/domain/usecases/add_new_product_usecase.dart';
import 'package:stock_management_tool/features/add_new_product/domain/usecases/get_product_initial_input_fields_usecase.dart';
import 'package:stock_management_tool/features/add_new_product/domain/usecases/value_changed_add_new_product_usecase.dart';

part 'add_new_product_event.dart';
part 'add_new_product_state.dart';

class AddNewProductBloc extends Bloc<AddNewProductEvent, AddNewProductState> {
  final GetProductInitialInputFieldsUseCase? _productInitialInputFieldsUseCase;
  final ValueChangedAddNewProductUseCase? _valueChangedAddNewProductUseCase;
  final AddNewProductUseCase? _addNewProductUseCase;

  AddNewProductBloc(
    this._productInitialInputFieldsUseCase,
    this._valueChangedAddNewProductUseCase,
    this._addNewProductUseCase,
  ) : super(LoadingState()) {
    on<LoadedEvent>(loadedEvent);
    on<ValueTypedEvent>(valueTypedEvent);
    on<ValueSelectedEvent>(valueSelectedEvent);
    on<AddNewProductButtonClickedEvent>(addNewProductButtonClickedEvent);
  }

  FutureOr<void> loadedEvent(
      LoadedEvent event, Emitter<AddNewProductState> emit) async {
    emit(LoadedState(await _productInitialInputFieldsUseCase!()));
  }

  FutureOr<void> valueTypedEvent(
      ValueTypedEvent event, Emitter<AddNewProductState> emit) async {
    await _valueChangedAddNewProductUseCase!(params: {
      "field": event.field,
      "value": event.value,
      "fields": event.fields,
    });
  }

  FutureOr<void> valueSelectedEvent(
      ValueSelectedEvent event, Emitter<AddNewProductState> emit) async {
    emit(LoadedState(await _valueChangedAddNewProductUseCase!(params: {
      "field": event.field,
      "value": event.value,
      "fields": event.fields,
    })));
  }

  FutureOr<void> addNewProductButtonClickedEvent(
      AddNewProductButtonClickedEvent event,
      Emitter<AddNewProductState> emit) async {
    emit(LoadedState(
        await _addNewProductUseCase!(params: {"fields": event.fields!})));
    emit(NewProductAddedActionState());
  }
}
