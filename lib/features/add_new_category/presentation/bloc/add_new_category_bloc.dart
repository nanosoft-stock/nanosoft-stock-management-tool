import 'dart:async';
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:stock_management_tool/features/add_new_category/domain/usecases/add_new_field_add_new_category_usecase.dart';
import 'package:stock_management_tool/features/add_new_category/domain/usecases/details_typed_add_new_category_usecase.dart';
import 'package:stock_management_tool/features/add_new_category/domain/usecases/field_name_typed_add_new_category_usecase.dart';
import 'package:stock_management_tool/features/add_new_category/domain/usecases/initial_add_new_category_usecase.dart';
import 'package:stock_management_tool/features/add_new_category/domain/usecases/listen_to_cloud_data_change_usecase.dart';
import 'package:stock_management_tool/features/add_new_category/domain/usecases/view_field_details_add_new_category_usecase.dart';

part 'add_new_category_event.dart';
part 'add_new_category_state.dart';

class AddNewCategoryBloc
    extends Bloc<AddNewCategoryEvent, AddNewCategoryState> {
  final InitialAddNewCategoryUseCase? _initialAddNewCategoryUseCase;
  final ListenToCloudDataChangeAddNewCategoryUseCase?
      _listenToCloudDataChangeAddNewCategoryUseCase;
  final ViewFieldDetailsAddNewCategoryUseCase?
      _viewFieldDetailsAddNewCategoryUseCase;
  final AddNewFieldAddNewCategoryUseCase? _addNewFieldAddNewCategoryUseCase;
  final FieldNameTypedAddNewCategoryUseCase?
      _fieldNameTypedAddNewCategoryUseCase;
  final DetailsTypedAddNewCategoryUseCase? _detailsTypedAddNewCategoryUseCase;

  AddNewCategoryBloc(
    this._initialAddNewCategoryUseCase,
    this._listenToCloudDataChangeAddNewCategoryUseCase,
    this._viewFieldDetailsAddNewCategoryUseCase,
    this._addNewFieldAddNewCategoryUseCase,
    this._fieldNameTypedAddNewCategoryUseCase,
    this._detailsTypedAddNewCategoryUseCase,
  ) : super(LoadingState()) {
    on<CloudDataChangeEvent>(cloudDataChangeEvent);
    on<LoadedEvent>(loadedEvent);
    on<CategoryTypedEvent>(categoryTypedEvent);
    on<ViewFieldDetailsEvent>(viewFieldDetailsEvent);
    on<AddNewFieldEvent>(addNewFieldEvent);
    on<RearrangeFieldsEvent>(rearrangeFieldsEvent);
    on<AddNewCategoryPressedEvent>(addNewCategoryPressedEvent);
    on<RemoveFieldEvent>(removeFieldEvent);
    on<FieldNameTypedEvent>(fieldNameTypedEvent);
    on<DetailsTypedEvent>(detailsTypedEvent);
  }

  FutureOr<void> cloudDataChangeEvent(
      CloudDataChangeEvent event, Emitter<AddNewCategoryState> emit) async {
    Map<String, dynamic> addNewCategoryData =
        await _initialAddNewCategoryUseCase!();

    await _listenToCloudDataChangeAddNewCategoryUseCase!(params: {
      "add_new_category_data": addNewCategoryData,
      "on_change": event.onChange,
    });

    emit(LoadedState(addNewCategoryData: addNewCategoryData));
  }

  FutureOr<void> loadedEvent(
      LoadedEvent event, Emitter<AddNewCategoryState> emit) async {
    emit(LoadedState(addNewCategoryData: event.addNewCategoryData));
  }

  FutureOr<void> categoryTypedEvent(
      CategoryTypedEvent event, Emitter<AddNewCategoryState> emit) async {}

  FutureOr<void> viewFieldDetailsEvent(
      ViewFieldDetailsEvent event, Emitter<AddNewCategoryState> emit) async {
    emit(LoadedState(
        addNewCategoryData:
            await _viewFieldDetailsAddNewCategoryUseCase!(params: {
      "field": event.field,
      "add_new_category_data": event.addNewCategoryData,
    })));
  }

  FutureOr<void> addNewFieldEvent(
      AddNewFieldEvent event, Emitter<AddNewCategoryState> emit) async {
    emit(LoadedState(
        addNewCategoryData: await _addNewFieldAddNewCategoryUseCase!(params: {
      "add_new_category_data": event.addNewCategoryData,
    })));
  }

  FutureOr<void> rearrangeFieldsEvent(
      RearrangeFieldsEvent event, Emitter<AddNewCategoryState> emit) async {}

  FutureOr<void> addNewCategoryPressedEvent(AddNewCategoryPressedEvent event,
      Emitter<AddNewCategoryState> emit) async {}

  FutureOr<void> removeFieldEvent(
      RemoveFieldEvent event, Emitter<AddNewCategoryState> emit) async {}

  FutureOr<void> fieldNameTypedEvent(
      FieldNameTypedEvent event, Emitter<AddNewCategoryState> emit) async {
    emit(LoadedState(
        addNewCategoryData:
            await _fieldNameTypedAddNewCategoryUseCase!(params: {
      "title": event.title,
      "value": event.value,
      "add_new_category_data": event.addNewCategoryData,
    })));
  }

  FutureOr<void> detailsTypedEvent(
      DetailsTypedEvent event, Emitter<AddNewCategoryState> emit) async {
    await _detailsTypedAddNewCategoryUseCase!(params: {
      "title": event.title,
      "value": event.value,
      "add_new_category_data": event.addNewCategoryData,
    });
  }
}
