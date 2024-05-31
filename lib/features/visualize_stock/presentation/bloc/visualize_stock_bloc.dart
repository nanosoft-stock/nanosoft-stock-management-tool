import 'dart:async';
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:stock_management_tool/constants/enums.dart';
import 'package:stock_management_tool/features/visualize_stock/domain/usecases/add_visualize_stock_layer_usecase.dart';
import 'package:stock_management_tool/features/visualize_stock/domain/usecases/change_column_visibility_usecase.dart';
import 'package:stock_management_tool/features/visualize_stock/domain/usecases/export_to_excel_usecase.dart';
import 'package:stock_management_tool/features/visualize_stock/domain/usecases/filter_by_selected_visualize_stock_usecase.dart';
import 'package:stock_management_tool/features/visualize_stock/domain/usecases/filter_value_entered_visualize_stock_usecase.dart';
import 'package:stock_management_tool/features/visualize_stock/domain/usecases/hide_visualize_stock_layer_usecase.dart';
import 'package:stock_management_tool/features/visualize_stock/domain/usecases/import_from_excel_usecase.dart';
import 'package:stock_management_tool/features/visualize_stock/domain/usecases/initial_usecase.dart';
import 'package:stock_management_tool/features/visualize_stock/domain/usecases/listen_to_cloud_data_change_usecase.dart';
import 'package:stock_management_tool/features/visualize_stock/domain/usecases/rearrange_columns_usecase.dart';
import 'package:stock_management_tool/features/visualize_stock/domain/usecases/sort_visualize_stock_usecase.dart';

part 'visualize_stock_event.dart';
part 'visualize_stock_state.dart';

class VisualizeStockBloc
    extends Bloc<VisualizeStockEvent, VisualizeStockState> {
  final ListenToCloudDataChangeVisualizeStockUseCase?
      _listenToCloudDataChangeUseCase;
  final InitialVisualizeStockUseCase? _initialVisualizeStockUseCase;
  final SortVisualizeStockUseCase? _sortVisualizeStockUseCase;
  final ImportFromExcelUseCase? _importFromExcelUseCase;
  final ExportToExcelUseCase? _exportToExcelUseCase;
  final AddVisualizeStockLayerUseCase? _addVisualizeStockLayerUseCase;
  final HideVisualizeStockLayerUseCase? _hideVisualizeStockLayerUseCase;
  final RearrangeColumnsUseCase? _rearrangeColumnsUseCase;

  final ChangeColumnVisibilityUseCase? _changeColumnVisibilityUseCase;
  final FilterBySelectedVisualizeStockUseCase?
      _filterBySelectedVisualizeStockUseCase;
  final FilterValueEnteredVisualizeStockUseCase?
      _filterValueEnteredVisualizeStockUseCase;

  VisualizeStockBloc(
    this._listenToCloudDataChangeUseCase,
    this._initialVisualizeStockUseCase,
    this._sortVisualizeStockUseCase,
    this._importFromExcelUseCase,
    this._exportToExcelUseCase,
    this._addVisualizeStockLayerUseCase,
    this._hideVisualizeStockLayerUseCase,
    this._rearrangeColumnsUseCase,
    this._changeColumnVisibilityUseCase,
    this._filterBySelectedVisualizeStockUseCase,
    this._filterValueEnteredVisualizeStockUseCase,
  ) : super(LoadingState()) {
    on<CloudDataChangeEvent>(cloudDataChangeEvent);
    on<LoadedEvent>(loadedEvent);
    on<SortFieldEvent>(sortFieldEvent);
    on<ParentFilterEvent>(parentFilterEvent);
    on<ImportButtonClickedEvent>(importButtonClickedEvent);
    on<ExportButtonClickedEvent>(exportButtonClickedEvent);
    on<FieldFilterEvent>(fieldFilterEvent);
    on<HideLayerEvent>(hideLayerEvent);
    on<RearrangeColumnsEvent>(rearrangeColumnsEvent);
    on<ColumnVisibilityChangedEvent>(columnVisibilityChangedEvent);
    on<FilterBySelectedEvent>(filterBySelectedEvent);
    on<FilterValueEnteredEvent>(filterValueEnteredEvent);
  }

  FutureOr<void> cloudDataChangeEvent(
      CloudDataChangeEvent event, Emitter<VisualizeStockState> emit) async {
    await Future.delayed(const Duration(seconds: 2));
    Map<String, dynamic> visualizeStock =
        await _initialVisualizeStockUseCase!();
    await _listenToCloudDataChangeUseCase!(params: {
      "visualize_stock": visualizeStock,
      "on_change": (Map visualizeStock) {
        add(LoadedEvent(visualizeStock: visualizeStock));
      }
    });
    emit(LoadedState(visualizeStock: visualizeStock));
  }

  FutureOr<void> loadedEvent(
      LoadedEvent event, Emitter<VisualizeStockState> emit) async {
    emit(LoadedState(visualizeStock: event.visualizeStock));
  }

  FutureOr<void> sortFieldEvent(
      SortFieldEvent event, Emitter<VisualizeStockState> emit) async {
    emit(LoadedState(
        visualizeStock: await _sortVisualizeStockUseCase!(params: {
      "field": event.field,
      "sort": event.sort,
      "visualize_stock": event.visualizeStock
    })));
  }

  FutureOr<void> parentFilterEvent(
      ParentFilterEvent event, Emitter<VisualizeStockState> emit) async {
    emit(LoadedState(
        visualizeStock: await _addVisualizeStockLayerUseCase!(params: {
      "layer": "parent_filter",
      "visualize_stock": event.visualizeStock,
    })));
  }

  FutureOr<void> importButtonClickedEvent(
      ImportButtonClickedEvent event, Emitter<VisualizeStockState> emit) async {
    await _importFromExcelUseCase!();
    emit(ImportTableActionState());
    emit(LoadedState(visualizeStock: event.visualizeStock!));
  }

  FutureOr<void> exportButtonClickedEvent(
      ExportButtonClickedEvent event, Emitter<VisualizeStockState> emit) async {
    await _exportToExcelUseCase!();
    emit(ExportTableActionState());
    emit(LoadedState(visualizeStock: event.visualizeStock!));
  }

  FutureOr<void> fieldFilterEvent(
      FieldFilterEvent event, Emitter<VisualizeStockState> emit) async {
    emit(LoadedState(
        visualizeStock: await _addVisualizeStockLayerUseCase!(params: {
      "field": event.field,
      "visualize_stock": event.visualizeStock,
    })));
  }

  FutureOr<void> hideLayerEvent(
      HideLayerEvent event, Emitter<VisualizeStockState> emit) async {
    emit(LoadedState(
        visualizeStock: await _hideVisualizeStockLayerUseCase!(params: {
      "layer": event.layer,
      "visualize_stock": event.visualizeStock,
    })));
  }

  FutureOr<void> rearrangeColumnsEvent(
      RearrangeColumnsEvent event, Emitter<VisualizeStockState> emit) async {
    emit(LoadedState(
        visualizeStock: await _rearrangeColumnsUseCase!(params: {
      "field_filters": event.fieldFilters,
      "visualize_stock": event.visualizeStock,
    })));
  }

  FutureOr<void> columnVisibilityChangedEvent(
      ColumnVisibilityChangedEvent event,
      Emitter<VisualizeStockState> emit) async {
    emit(LoadedState(
        visualizeStock: await _changeColumnVisibilityUseCase!(params: {
      "field": event.field,
      "visibility": event.visibility,
      "visualize_stock": event.visualizeStock,
    })));
  }

  FutureOr<void> filterBySelectedEvent(
      FilterBySelectedEvent event, Emitter<VisualizeStockState> emit) async {
    emit(LoadedState(
        visualizeStock: await _filterBySelectedVisualizeStockUseCase!(params: {
      "field": event.field,
      "filter_by": event.filterBy,
      "visualize_stock": event.visualizeStock,
    })));
  }

  FutureOr<void> filterValueEnteredEvent(
      FilterValueEnteredEvent event, Emitter<VisualizeStockState> emit) async {
    emit(LoadedState(
        visualizeStock:
            await _filterValueEnteredVisualizeStockUseCase!(params: {
      "field": event.field,
      "filter_value": event.filterValue,
      "visualize_stock": event.visualizeStock,
    })));
  }
}
