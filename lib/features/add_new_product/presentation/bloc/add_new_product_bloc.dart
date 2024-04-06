import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:stock_management_tool/features/add_new_product/domain/usecases/add_new_product_usecase.dart';
import 'package:stock_management_tool/features/add_new_product/domain/usecases/get_product_category_based_input_fields_usecase.dart';
import 'package:stock_management_tool/features/add_new_product/domain/usecases/get_product_initial_input_fields_usecase.dart';

part 'add_new_product_event.dart';
part 'add_new_product_state.dart';

class AddNewProductBloc extends Bloc<AddNewProductEvent, AddNewProductState> {
  final GetProductInitialInputFieldsUseCase? _productInitialInputFieldsUseCase;
  final GetProductCategoryBasedInputFieldsUseCase? _productCategoryBasedInputFieldsUseCase;
  final AddNewProductUseCase? _addNewProductUseCase;

  AddNewProductBloc(
    this._productInitialInputFieldsUseCase,
    this._productCategoryBasedInputFieldsUseCase,
    this._addNewProductUseCase,
  ) : super(AddNewProductLoadingState()) {
    // on<AddNewProductInitialEvent>(addNewProductInitialEvent);
    // on<AddNewProductLoadingEvent>(addNewProductLoadingEvent);
    on<AddNewProductLoadedEvent>(addNewProductLoadedEvent);
    on<AddNewProductCategorySelectedEvent>(addNewProductCategorySelectedEvent);
    on<AddNewProductButtonClickedEvent>(addNewProductButtonClickedEvent);
    on<AddNewProductErrorEvent>(addNewProductErrorEvent);
  }

  // FutureOr<void> addNewProductInitialEvent(
  //     AddNewProductInitialEvent event, Emitter<AddNewProductState> emit) async {
  //   emit(AddNewProductLoadingState());
  // }

  // FutureOr<void> addNewProductLoadingEvent(
  //     AddNewProductLoadingEvent event, Emitter<AddNewProductState> emit) async {
  //   await Future.delayed(const Duration(seconds: 3));
  //   final inputFieldData = await _initialInputFieldsUseCase!();
  //   emit(AddNewProductLoadedState(inputFieldData));
  // }

  FutureOr<void> addNewProductLoadedEvent(
      AddNewProductLoadedEvent event, Emitter<AddNewProductState> emit) async {
    emit(AddNewProductLoadedState(await _productInitialInputFieldsUseCase!()));
  }

  FutureOr<void> addNewProductCategorySelectedEvent(
      AddNewProductCategorySelectedEvent event, Emitter<AddNewProductState> emit) async {
    emit(AddNewProductLoadedState([
      ...[event.fields![0], event.fields![1]],
      ...await _productCategoryBasedInputFieldsUseCase!(params: event.fields![0].textValue)
    ]));
  }

  FutureOr<void> addNewProductButtonClickedEvent(
      AddNewProductButtonClickedEvent event, Emitter<AddNewProductState> emit) async {
    await _addNewProductUseCase!(params: event.fields!);
    emit(AddNewProductLoadedState(await _productInitialInputFieldsUseCase!()));
  }

  FutureOr<void> addNewProductErrorEvent(
      AddNewProductErrorEvent event, Emitter<AddNewProductState> emit) async {}
}
