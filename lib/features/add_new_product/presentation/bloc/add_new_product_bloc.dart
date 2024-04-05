import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:stock_management_tool/features/add_new_product/domain/entities/product_input_field_entity.dart';
import 'package:stock_management_tool/features/add_new_product/domain/usecases/add_new_product_usecase.dart';
import 'package:stock_management_tool/features/add_new_product/domain/usecases/get_category_based_input_fields_usecase.dart';
import 'package:stock_management_tool/features/add_new_product/domain/usecases/get_initial_input_fields_usecase.dart';
import 'package:stock_management_tool/injection_container.dart';

part 'add_new_product_event.dart';
part 'add_new_product_state.dart';

class AddNewProductBloc extends Bloc<AddNewProductEvent, AddNewProductState> {
  final GetInitialInputFieldsUseCase? _initialInputFieldsUseCase;
  GetCategoryBasedInputFieldsUseCase? _categoryBasedInputFieldsUseCase;
  AddNewProductUseCase? _addNewProductUseCase;

  AddNewProductBloc(this._initialInputFieldsUseCase) : super(AddNewProductLoadingState()) {
    // on<AddNewProductInitialEvent>(addNewProductInitialEvent);
    on<AddNewProductLoadingEvent>(addNewProductLoadingEvent);
    on<AddNewProductLoadedEvent>(addNewProductLoadedEvent);
    on<AddNewProductCategorySelectedEvent>(addNewProductCategorySelectedEvent);
    on<AddNewProductButtonClickedEvent>(addNewProductButtonClickedEvent);
  }

  // FutureOr<void> addNewProductInitialEvent(
  //     AddNewProductInitialEvent event, Emitter<AddNewProductState> emit) async {
  //   emit(AddNewProductLoadingState());
  // }

  FutureOr<void> addNewProductLoadingEvent(
      AddNewProductLoadingEvent event, Emitter<AddNewProductState> emit) async {
    // await Future.delayed(const Duration(seconds: 3));
    // final inputFieldData = await _initialInputFieldsUseCase!();
    // emit(AddNewProductLoadedState(inputFieldData));
  }

  FutureOr<void> addNewProductLoadedEvent(
      AddNewProductLoadedEvent event, Emitter<AddNewProductState> emit) async {
    final initialInputFields = await _initialInputFieldsUseCase!();
    emit(AddNewProductLoadedState(initialInputFields));
  }

  FutureOr<void> addNewProductCategorySelectedEvent(
      AddNewProductCategorySelectedEvent event, Emitter<AddNewProductState> emit) async {
    _categoryBasedInputFieldsUseCase = sl.get<GetCategoryBasedInputFieldsUseCase>();
    final List initialInputFields = await _initialInputFieldsUseCase!();
    initialInputFields[0].textValue = event.category;
    final List categoryBasedInputFields =
        await _categoryBasedInputFieldsUseCase!(params: event.category);
    emit(AddNewProductLoadedState([...initialInputFields, ...categoryBasedInputFields]));
  }

  FutureOr<void> addNewProductButtonClickedEvent(
      AddNewProductButtonClickedEvent event, Emitter<AddNewProductState> emit) async {
    _addNewProductUseCase = sl.get<AddNewProductUseCase>();
    await _addNewProductUseCase!(params: event.fields!);
    final initialInputFields = await _initialInputFieldsUseCase!();
    emit(AddNewProductLoadedState(initialInputFields));
  }
}
