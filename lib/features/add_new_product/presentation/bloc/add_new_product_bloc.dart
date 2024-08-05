import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:stock_management_tool/features/add_new_product/domain/usecases/add_new_product_usecase.dart';
import 'package:stock_management_tool/features/add_new_product/domain/usecases/get_product_initial_input_fields_usecase.dart';
import 'package:stock_management_tool/features/add_new_product/domain/usecases/listen_to_cloud_data_change_add_new_product_usecase.dart';
import 'package:stock_management_tool/features/add_new_product/domain/usecases/value_changed_add_new_product_usecase.dart';

part 'add_new_product_event.dart';
part 'add_new_product_state.dart';

class AddNewProductBloc extends Bloc<AddNewProductEvent, AddNewProductState> {
  final GetProductInitialInputFieldsUseCase? _productInitialInputFieldsUseCase;
  final ListenToCloudDataChangeAddNewProductUseCase?
      _listenToCloudDataChangeAddNewProductUseCase;
  final ValueChangedAddNewProductUseCase? _valueChangedAddNewProductUseCase;
  final AddNewProductUseCase? _addNewProductUseCase;

  late List<Map<String, dynamic>> fields;

  AddNewProductBloc(
    this._productInitialInputFieldsUseCase,
    this._listenToCloudDataChangeAddNewProductUseCase,
    this._valueChangedAddNewProductUseCase,
    this._addNewProductUseCase,
  ) : super(LoadingState()) {
    on<CloudDataChangeEvent>(cloudDataChangeEvent);
    on<LoadedEvent>(loadedEvent);
    on<ValueTypedEvent>(valueTypedEvent);
    on<ValueSelectedEvent>(valueSelectedEvent);
    on<AddNewProductButtonClickedEvent>(addNewProductButtonClickedEvent);
  }

  FutureOr<void> cloudDataChangeEvent(
      CloudDataChangeEvent event, Emitter<AddNewProductState> emit) async {
    fields = await _productInitialInputFieldsUseCase!();

    await _listenToCloudDataChangeAddNewProductUseCase!(params: {
      "fields": fields,
      "on_change": event.onChange,
    });

    emit(LoadedState(fields));
  }

  FutureOr<void> loadedEvent(
      LoadedEvent event, Emitter<AddNewProductState> emit) async {
    emit(LoadedState(fields));
  }

  FutureOr<void> valueTypedEvent(
      ValueTypedEvent event, Emitter<AddNewProductState> emit) async {
    await _valueChangedAddNewProductUseCase!(params: {
      "field": event.field,
      "value": event.value,
      "fields": fields,
    });
  }

  FutureOr<void> valueSelectedEvent(
      ValueSelectedEvent event, Emitter<AddNewProductState> emit) async {
    emit(LoadedState(await _valueChangedAddNewProductUseCase!(params: {
      "field": event.field,
      "value": event.value,
      "fields": fields,
    })));
  }

  FutureOr<void> addNewProductButtonClickedEvent(
      AddNewProductButtonClickedEvent event,
      Emitter<AddNewProductState> emit) async {
    emit(LoadedState(await _addNewProductUseCase!(params: {"fields": fields})));
    emit(NewProductAddedActionState());
  }
}
