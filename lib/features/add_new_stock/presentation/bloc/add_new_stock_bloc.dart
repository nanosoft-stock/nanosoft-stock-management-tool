import 'dart:async';
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:stock_management_tool/core/resources/application_error.dart';
import 'package:stock_management_tool/features/add_new_stock/domain/usecases/add_new_stock_usecase.dart';
import 'package:stock_management_tool/features/add_new_stock/domain/usecases/checkbox_toggled_add_new_stock_usecase.dart';
import 'package:stock_management_tool/features/add_new_stock/domain/usecases/get_stock_initial_input_fields_usecase.dart';
import 'package:stock_management_tool/features/add_new_stock/domain/usecases/listen_to_cloud_data_change_add_new_stock_usecase.dart';
import 'package:stock_management_tool/features/add_new_stock/domain/usecases/value_changed_add_new_stock_usecase.dart';

part 'add_new_stock_event.dart';
part 'add_new_stock_state.dart';

class AddNewStockBloc extends Bloc<AddNewStockEvent, AddNewStockState> {
  final GetStockInitialInputFieldsUseCase? _stockInitialInputFieldsUseCase;
  final ListenToCloudDataChangeAddNewStockUseCase?
      _listenToCloudDataChangeAddNewStockUseCase;
  final ValueChangedAddNewStockUseCase? _valueChangedAddNewStockUseCase;
  final CheckboxToggledAddNewStockUseCase? _checkboxToggledAddNewStockUseCase;
  final AddNewStockUseCase? _addNewStockUseCase;

  late List<Map<String, dynamic>> fields;

  AddNewStockBloc(
    this._stockInitialInputFieldsUseCase,
    this._listenToCloudDataChangeAddNewStockUseCase,
    this._valueChangedAddNewStockUseCase,
    this._checkboxToggledAddNewStockUseCase,
    this._addNewStockUseCase,
  ) : super(LoadingState()) {
    on<CloudDataChangeEvent>(cloudDataChangeEvent);
    on<LoadedEvent>(loadedEvent);
    on<ValueTypedEvent>(valueTypedEvent);
    on<ValueSelectedEvent>(valueSelectedEvent);
    on<CheckBoxTapEvent>(checkBoxTapEvent);
    on<AddNewStockButtonClickedEvent>(addNewStockButtonClickedEvent);
  }

  FutureOr<void> cloudDataChangeEvent(
      CloudDataChangeEvent event, Emitter<AddNewStockState> emit) async {
    await _executeTryCatch(() async {
      fields = await _stockInitialInputFieldsUseCase!();

      await _listenToCloudDataChangeAddNewStockUseCase!(params: {
        "fields": fields,
        "on_change": event.onChange,
      });
    }, (message, stackTrace) {
      emit(ErrorActionState(message: message, stackTrace: stackTrace));
    });

    emit(LoadedState(fields: fields));
  }

  FutureOr<void> loadedEvent(
      LoadedEvent event, Emitter<AddNewStockState> emit) async {
    emit(LoadedState(fields: fields));
  }

  FutureOr<void> valueTypedEvent(
      ValueTypedEvent event, Emitter<AddNewStockState> emit) async {
    await _executeTryCatch(() async {
      await _valueChangedAddNewStockUseCase!(params: {
        "field": event.field,
        "value": event.value,
        "fields": fields,
      });
    }, (message, stackTrace) {
      emit(ErrorActionState(message: message, stackTrace: stackTrace));
    });
  }

  FutureOr<void> valueSelectedEvent(
      ValueSelectedEvent event, Emitter<AddNewStockState> emit) async {
    await _executeTryCatch(() async {
      await _valueChangedAddNewStockUseCase!(params: {
        "field": event.field,
        "value": event.value,
        "fields": fields,
      });
    }, (message, stackTrace) {
      emit(ErrorActionState(message: message, stackTrace: stackTrace));
    });

    emit(LoadedState(fields: fields));
  }

  FutureOr<void> checkBoxTapEvent(
      CheckBoxTapEvent event, Emitter<AddNewStockState> emit) async {
    await _executeTryCatch(() async {
      await _checkboxToggledAddNewStockUseCase!(params: {
        "field": event.field,
        "value": event.value,
        "fields": fields,
      });
    }, (message, stackTrace) {
      emit(ErrorActionState(message: message, stackTrace: stackTrace));
    });

    emit(LoadedState(fields: fields));
  }

  FutureOr<void> addNewStockButtonClickedEvent(
      AddNewStockButtonClickedEvent event,
      Emitter<AddNewStockState> emit) async {
    await _executeTryCatch(() async {
      await _addNewStockUseCase!(params: {"fields": fields});
      emit(const SuccessActionState(message: "Item added successfully"));
    }, (message, stackTrace) {
      emit(ErrorActionState(message: message, stackTrace: stackTrace));
    });

    emit(LoadedState(fields: fields));
  }

  FutureOr<void> _executeTryCatch(
      Function tryFunc, Function(String, StackTrace) catchFunc) async {
    try {
      await tryFunc();
    } on NetworkError catch (error, stackTrace) {
      catchFunc(error.message, stackTrace);
    } on InternalError catch (error, stackTrace) {
      catchFunc(error.message, stackTrace);
    } on ServerError catch (error, stackTrace) {
      catchFunc(error.message, stackTrace);
    } on ValidationError catch (error, stackTrace) {
      catchFunc(error.message, stackTrace);
    } on UnknownError catch (error, stackTrace) {
      catchFunc(error.message, stackTrace);
    } catch (error, stackTrace) {
      print(error);
      catchFunc("Something went wrong", stackTrace);
    }
  }
}
