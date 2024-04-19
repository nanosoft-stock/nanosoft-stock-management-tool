import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:stock_management_tool/features/visualize_stock/domain/entities/stock_field_entity.dart';
import 'package:stock_management_tool/features/visualize_stock/domain/usecases/export_to_excel_usecase.dart';
import 'package:stock_management_tool/features/visualize_stock/domain/usecases/get_all_fields_usecase.dart';
import 'package:stock_management_tool/features/visualize_stock/domain/usecases/get_all_stock_usecase.dart';
import 'package:stock_management_tool/features/visualize_stock/domain/usecases/sort_field_usecase.dart';
import 'package:stock_management_tool/features/visualize_stock/domain/usecases/sort_stock_usecase.dart';

part 'visualize_stock_event.dart';
part 'visualize_stock_state.dart';

class VisualizeStockBloc extends Bloc<VisualizeStockEvent, VisualizeStockState> {
  final GetAllFieldsUseCase? _allFieldsUseCase;
  final GetAllStockUseCase? _allStockUseCase;
  final SortFieldUseCase? _sortFieldUseCase;
  final SortStockUseCase? _sortStockUseCase;
  final ExportToExcelUsecase? _exportToExcelUsecase;

  VisualizeStockBloc(this._allFieldsUseCase, this._allStockUseCase, this._sortFieldUseCase,
      this._sortStockUseCase, this._exportToExcelUsecase)
      : super(LoadingState()) {
    on<LoadedEvent>(loadedEvent);
    on<SortFieldEvent>(sortFieldEvent);
    on<FilterFieldEvent>(filterFieldEvent);
    on<ImportButtonClickedEvent>(importButtonClickedEvent);
    on<ExportButtonClickedEvent>(exportButtonClickedEvent);
  }

  FutureOr<void> loadedEvent(LoadedEvent event, Emitter<VisualizeStockState> emit) async {
    emit(LoadedState(await _allFieldsUseCase!(), await _allStockUseCase!()));
  }

  FutureOr<void> sortFieldEvent(SortFieldEvent event, Emitter<VisualizeStockState> emit) async {
    emit(LoadedState(await _sortFieldUseCase!(params: {"field": event.field, "sort": event.sort}),
        await _sortStockUseCase!(params: {"field": event.field, "sort": event.sort})));
  }

  FutureOr<void> filterFieldEvent(FilterFieldEvent event, Emitter<VisualizeStockState> emit) {}

  FutureOr<void> importButtonClickedEvent(
      ImportButtonClickedEvent event, Emitter<VisualizeStockState> emit) {
    emit(ImportTableActionState());
  }

  FutureOr<void> exportButtonClickedEvent(
      ExportButtonClickedEvent event, Emitter<VisualizeStockState> emit) async {
    await _exportToExcelUsecase!();
    emit(ExportTableActionState());
    emit(LoadedState(await _allFieldsUseCase!(), await _allStockUseCase!()));
  }
}