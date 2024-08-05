import 'dart:async';
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:stock_management_tool/features/modify_category/domain/usecases/add_new_field_modify_category_usecase.dart';
import 'package:stock_management_tool/features/modify_category/domain/usecases/category_selected_modify_category_usecase.dart';
import 'package:stock_management_tool/features/modify_category/domain/usecases/details_typed_modify_category_usecase.dart';
import 'package:stock_management_tool/features/modify_category/domain/usecases/field_name_typed_modify_category_usecase.dart';
import 'package:stock_management_tool/features/modify_category/domain/usecases/initial_modify_category_usecase.dart';
import 'package:stock_management_tool/features/modify_category/domain/usecases/listen_to_cloud_data_change_usecase.dart';
import 'package:stock_management_tool/features/modify_category/domain/usecases/modify_category_pressed_usecase.dart';
import 'package:stock_management_tool/features/modify_category/domain/usecases/rearrange_fields_modify_category_usecase.dart';
import 'package:stock_management_tool/features/modify_category/domain/usecases/remove_field_modify_category_usecase.dart';
import 'package:stock_management_tool/features/modify_category/domain/usecases/view_field_details_modify_category_usecase.dart';

part 'modify_category_event.dart';
part 'modify_category_state.dart';

class ModifyCategoryBloc
    extends Bloc<ModifyCategoryEvent, ModifyCategoryState> {
  final InitialModifyCategoryUseCase? _initialModifyCategoryUseCase;
  final ListenToCloudDataChangeModifyCategoryUseCase?
      _listenToCloudDataChangeModifyCategoryUseCase;
  final CategorySelectedModifyCategoryUseCase?
      _categorySelectedModifyCategoryUseCase;
  final ViewFieldDetailsModifyCategoryUseCase?
      _viewFieldDetailsModifyCategoryUseCase;
  final AddNewFieldModifyCategoryUseCase? _addNewFieldModifyCategoryUseCase;
  final RearrangeFieldsModifyCategoryUseCase?
      _rearrangeFieldsModifyCategoryUseCase;
  final ModifyCategoryPressedUseCase? _modifyCategoryPressedUseCase;
  final RemoveFieldModifyCategoryUseCase? _removeFieldModifyCategoryUseCase;
  final FieldNameTypedModifyCategoryUseCase?
      _fieldNameTypedModifyCategoryUseCase;
  final DetailsTypedModifyCategoryUseCase? _detailsTypedModifyCategoryUseCase;

  late Map<String, dynamic> modifyCategoryData;

  ModifyCategoryBloc(
    this._initialModifyCategoryUseCase,
    this._listenToCloudDataChangeModifyCategoryUseCase,
    this._categorySelectedModifyCategoryUseCase,
    this._viewFieldDetailsModifyCategoryUseCase,
    this._addNewFieldModifyCategoryUseCase,
    this._rearrangeFieldsModifyCategoryUseCase,
    this._modifyCategoryPressedUseCase,
    this._removeFieldModifyCategoryUseCase,
    this._fieldNameTypedModifyCategoryUseCase,
    this._detailsTypedModifyCategoryUseCase,
  ) : super(LoadingState()) {
    on<CloudDataChangeEvent>(cloudDataChangeEvent);
    on<LoadedEvent>(loadedEvent);
    on<CategorySelectedEvent>(categorySelectedEvent);
    on<ViewFieldDetailsEvent>(viewFieldDetailsEvent);
    on<AddNewFieldEvent>(addNewFieldEvent);
    on<RearrangeFieldsEvent>(rearrangeFieldsEvent);
    on<ModifyCategoryPressedEvent>(modifyCategoryPressedEvent);
    on<RemoveFieldEvent>(removeFieldEvent);
    on<FieldNameTypedEvent>(fieldNameTypedEvent);
    on<DetailsTypedEvent>(detailsTypedEvent);
  }

  FutureOr<void> cloudDataChangeEvent(
      CloudDataChangeEvent event, Emitter<ModifyCategoryState> emit) async {
    modifyCategoryData = await _initialModifyCategoryUseCase!();

    await _listenToCloudDataChangeModifyCategoryUseCase!(params: {
      "modify_category_data": modifyCategoryData,
      "on_change": event.onChange,
    });

    emit(LoadedState(modifyCategoryData: modifyCategoryData));
  }

  FutureOr<void> loadedEvent(
      LoadedEvent event, Emitter<ModifyCategoryState> emit) async {
    emit(LoadedState(modifyCategoryData: modifyCategoryData));
  }

  FutureOr<void> categorySelectedEvent(
      CategorySelectedEvent event, Emitter<ModifyCategoryState> emit) async {
    emit(LoadedState(
        modifyCategoryData:
            await _categorySelectedModifyCategoryUseCase!(params: {
      "category": event.category,
      "modify_category_data": modifyCategoryData,
    })));
  }

  FutureOr<void> viewFieldDetailsEvent(
      ViewFieldDetailsEvent event, Emitter<ModifyCategoryState> emit) async {
    emit(LoadedState(
        modifyCategoryData:
            await _viewFieldDetailsModifyCategoryUseCase!(params: {
      "field": event.field,
      "modify_category_data": modifyCategoryData,
    })));
  }

  FutureOr<void> addNewFieldEvent(
      AddNewFieldEvent event, Emitter<ModifyCategoryState> emit) async {
    emit(LoadedState(
        modifyCategoryData: await _addNewFieldModifyCategoryUseCase!(params: {
      "modify_category_data": modifyCategoryData,
    })));
  }

  FutureOr<void> rearrangeFieldsEvent(
      RearrangeFieldsEvent event, Emitter<ModifyCategoryState> emit) async {
    emit(LoadedState(
        modifyCategoryData:
            await _rearrangeFieldsModifyCategoryUseCase!(params: {
      "fields": event.fields,
      "modify_category_data": modifyCategoryData,
    })));
  }

  FutureOr<void> modifyCategoryPressedEvent(ModifyCategoryPressedEvent event,
      Emitter<ModifyCategoryState> emit) async {
    emit(LoadedState(
        modifyCategoryData: await _modifyCategoryPressedUseCase!(params: {
      "modify_category_data": modifyCategoryData,
    })));
  }

  FutureOr<void> removeFieldEvent(
      RemoveFieldEvent event, Emitter<ModifyCategoryState> emit) async {
    emit(LoadedState(
        modifyCategoryData: await _removeFieldModifyCategoryUseCase!(params: {
      "modify_category_data": modifyCategoryData,
    })));
  }

  FutureOr<void> fieldNameTypedEvent(
      FieldNameTypedEvent event, Emitter<ModifyCategoryState> emit) async {
    emit(LoadedState(
        modifyCategoryData:
            await _fieldNameTypedModifyCategoryUseCase!(params: {
      "title": event.title,
      "value": event.value,
      "modify_category_data": modifyCategoryData,
    })));
  }

  FutureOr<void> detailsTypedEvent(
      DetailsTypedEvent event, Emitter<ModifyCategoryState> emit) async {
    await _detailsTypedModifyCategoryUseCase!(params: {
      "title": event.title,
      "value": event.value,
      "modify_category_data": modifyCategoryData,
    });
  }
}
