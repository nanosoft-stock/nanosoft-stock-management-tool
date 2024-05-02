import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:stock_management_tool/constants/enums.dart';
import 'package:stock_management_tool/features/visualize_stock/domain/usecases/export_to_excel_usecase.dart';
import 'package:stock_management_tool/features/visualize_stock/domain/usecases/get_all_fields_usecase.dart';
import 'package:stock_management_tool/features/visualize_stock/domain/usecases/get_all_stock_usecase.dart';
import 'package:stock_management_tool/features/visualize_stock/domain/usecases/import_from_excel_usecase.dart';
import 'package:stock_management_tool/features/visualize_stock/domain/usecases/listen_to_cloud_data_change_usecase.dart';
import 'package:stock_management_tool/features/visualize_stock/domain/usecases/sort_field_usecase.dart';
import 'package:stock_management_tool/features/visualize_stock/domain/usecases/sort_stock_usecase.dart';

part 'visualize_stock_event.dart';

part 'visualize_stock_state.dart';

class VisualizeStockBloc
    extends Bloc<VisualizeStockEvent, VisualizeStockState> {
  final GetAllFieldsUseCase? _allFieldsUseCase;
  final GetAllStockUseCase? _allStockUseCase;
  final SortFieldUseCase? _sortFieldUseCase;
  final SortStockUseCase? _sortStockUseCase;
  final ImportFromExcelUseCase? _importFromExcelUseCase;
  final ExportToExcelUseCase? _exportToExcelUseCase;
  final ListenToCloudDataChangeVisualizeStockUseCase?
      _listenToCloudDataChangeUseCase;

  VisualizeStockBloc(
      this._allFieldsUseCase,
      this._allStockUseCase,
      this._sortFieldUseCase,
      this._sortStockUseCase,
      this._importFromExcelUseCase,
      this._exportToExcelUseCase,
      this._listenToCloudDataChangeUseCase)
      : super(LoadingState()) {
    on<LoadedEvent>(loadedEvent);
    on<SortFieldEvent>(sortFieldEvent);
    on<FilterFieldEvent>(filterFieldEvent);
    on<ImportButtonClickedEvent>(importButtonClickedEvent);
    on<ExportButtonClickedEvent>(exportButtonClickedEvent);
    on<CloudDataChangeEvent>(cloudDataChangeEvent);
  }

  FutureOr<void> loadedEvent(
      LoadedEvent event, Emitter<VisualizeStockState> emit) async {
    emit(LoadedState(await _allFieldsUseCase!(), await _allStockUseCase!()));
  }

  FutureOr<void> sortFieldEvent(
      SortFieldEvent event, Emitter<VisualizeStockState> emit) async {
    emit(LoadedState(
        await _sortFieldUseCase!(
            params: {"field": event.field, "sort": event.sort}),
        await _sortStockUseCase!(
            params: {"field": event.field, "sort": event.sort})));
  }

  FutureOr<void> filterFieldEvent(
      FilterFieldEvent event, Emitter<VisualizeStockState> emit) {}

  FutureOr<void> importButtonClickedEvent(
      ImportButtonClickedEvent event, Emitter<VisualizeStockState> emit) async {
    await _importFromExcelUseCase!();
    emit(ImportTableActionState());
    emit(LoadedState(await _allFieldsUseCase!(), await _allStockUseCase!()));
  }

  FutureOr<void> exportButtonClickedEvent(
      ExportButtonClickedEvent event, Emitter<VisualizeStockState> emit) async {
    await _exportToExcelUseCase!();
    emit(ExportTableActionState());
    emit(LoadedState(await _allFieldsUseCase!(), await _allStockUseCase!()));
  }

  FutureOr<void> cloudDataChangeEvent(
      CloudDataChangeEvent event, Emitter<VisualizeStockState> emit) async {
    await _listenToCloudDataChangeUseCase!(params: {
      "onChange": () {
        add(LoadedEvent());
      }
    });
  }
}
