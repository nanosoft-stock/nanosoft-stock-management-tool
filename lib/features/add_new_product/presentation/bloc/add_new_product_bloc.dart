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
  ) : super(LoadingState()) {
    on<LoadedEvent>(loadedEvent);
    on<CategorySelectedEvent>(categorySelectedEvent);
    on<AddNewProductButtonClickedEvent>(addNewProductButtonClickedEvent);
    on<ErrorEvent>(errorEvent);
  }

  FutureOr<void> loadedEvent(LoadedEvent event, Emitter<AddNewProductState> emit) async {
    emit(LoadedState(await _productInitialInputFieldsUseCase!()));
  }

  FutureOr<void> categorySelectedEvent(
      CategorySelectedEvent event, Emitter<AddNewProductState> emit) async {
    emit(LoadedState([
      event.fields![0],
      event.fields![1],
      ...await _productCategoryBasedInputFieldsUseCase!(params: event.fields![0].textValue)
    ]));
  }

  FutureOr<void> addNewProductButtonClickedEvent(
      AddNewProductButtonClickedEvent event, Emitter<AddNewProductState> emit) async {
    await _addNewProductUseCase!(params: event.fields!);
    emit(NewProductAddedActionState());
    emit(LoadedState(await _productInitialInputFieldsUseCase!()));
  }

  FutureOr<void> errorEvent(ErrorEvent event, Emitter<AddNewProductState> emit) async {}
}
