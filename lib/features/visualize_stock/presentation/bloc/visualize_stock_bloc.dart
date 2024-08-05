import 'dart:async';
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:stock_management_tool/core/constants/enums.dart';
import 'package:stock_management_tool/features/visualize_stock/domain/usecases/add_visualize_stock_layer_usecase.dart';
import 'package:stock_management_tool/features/visualize_stock/domain/usecases/change_column_visibility_usecase.dart';
import 'package:stock_management_tool/features/visualize_stock/domain/usecases/checkbox_toggled_visualize_stock_usecase.dart';
import 'package:stock_management_tool/features/visualize_stock/domain/usecases/clear_column_filter_visualize_stock_usecase.dart';
import 'package:stock_management_tool/features/visualize_stock/domain/usecases/export_to_excel_usecase.dart';
import 'package:stock_management_tool/features/visualize_stock/domain/usecases/filter_by_selected_visualize_stock_usecase.dart';
import 'package:stock_management_tool/features/visualize_stock/domain/usecases/filter_column_visualize_stock_usecase.dart';
import 'package:stock_management_tool/features/visualize_stock/domain/usecases/filter_value_changed_visualize_stock_usecase.dart';
import 'package:stock_management_tool/features/visualize_stock/domain/usecases/hide_visualize_stock_layer_usecase.dart';
import 'package:stock_management_tool/features/visualize_stock/domain/usecases/import_from_excel_usecase.dart';
import 'package:stock_management_tool/features/visualize_stock/domain/usecases/initial_usecase.dart';
import 'package:stock_management_tool/features/visualize_stock/domain/usecases/listen_to_cloud_data_change_usecase.dart';
import 'package:stock_management_tool/features/visualize_stock/domain/usecases/rearrange_columns_usecase.dart';
import 'package:stock_management_tool/features/visualize_stock/domain/usecases/reset_all_filters_visualize_stock_usecase.dart';
import 'package:stock_management_tool/features/visualize_stock/domain/usecases/search_value_changed_visualize_stock_usecase.dart';
import 'package:stock_management_tool/features/visualize_stock/domain/usecases/sort_column_visualize_stock_usecase.dart';

part 'visualize_stock_event.dart';
part 'visualize_stock_state.dart';

class VisualizeStockBloc
    extends Bloc<VisualizeStockEvent, VisualizeStockState> {
  final InitialVisualizeStockUseCase? _initialVisualizeStockUseCase;
  final ListenToCloudDataChangeVisualizeStockUseCase?
      _listenToCloudDataChangeVisualizeStockUseCase;
  final ImportFromExcelUseCase? _importFromExcelUseCase;
  final ExportToExcelUseCase? _exportToExcelUseCase;
  final AddVisualizeStockLayerUseCase? _addVisualizeStockLayerUseCase;
  final HideVisualizeStockLayerUseCase? _hideVisualizeStockLayerUseCase;
  final ResetAllFiltersVisualizeStockUseCase?
      _resetAllFiltersVisualizeStockUseCase;
  final RearrangeColumnsUseCase? _rearrangeColumnsUseCase;
  final ChangeColumnVisibilityUseCase? _changeColumnVisibilityUseCase;
  final FilterColumnVisualizeStockUseCase? _filterColumnVisualizeStockUseCase;
  final ClearColumnFilterVisualizeStockUseCase?
      _clearColumnFilterVisualizeStockUseCase;
  final SortColumnVisualizeStockUseCase? _sortColumnVisualizeStockUseCase;
  final FilterBySelectedVisualizeStockUseCase?
      _filterBySelectedVisualizeStockUseCase;
  final FilterValueChangedVisualizeStockUseCase?
      _filterValueChangedVisualizeStockUseCase;
  final SearchValueChangedVisualizeStockUseCase?
      _searchValueChangedVisualizeStockUseCase;
  final CheckboxToggledVisualizeStockUseCase?
      _checkboxToggledVisualizeStockUseCase;

  late Map<String, dynamic> visualizeStock;

  VisualizeStockBloc(
    this._initialVisualizeStockUseCase,
    this._listenToCloudDataChangeVisualizeStockUseCase,
    this._importFromExcelUseCase,
    this._exportToExcelUseCase,
    this._addVisualizeStockLayerUseCase,
    this._hideVisualizeStockLayerUseCase,
    this._resetAllFiltersVisualizeStockUseCase,
    this._rearrangeColumnsUseCase,
    this._changeColumnVisibilityUseCase,
    this._filterColumnVisualizeStockUseCase,
    this._clearColumnFilterVisualizeStockUseCase,
    this._sortColumnVisualizeStockUseCase,
    this._filterBySelectedVisualizeStockUseCase,
    this._filterValueChangedVisualizeStockUseCase,
    this._searchValueChangedVisualizeStockUseCase,
    this._checkboxToggledVisualizeStockUseCase,
  ) : super(LoadingState()) {
    on<CloudDataChangeEvent>(cloudDataChangeEvent);
    on<LoadedEvent>(loadedEvent);
    on<ImportButtonClickedEvent>(importButtonClickedEvent);
    on<ExportButtonClickedEvent>(exportButtonClickedEvent);
    on<ShowTableFilterLayerEvent>(showTableFilterLayerEvent);
    on<ShowColumnFilterLayerEvent>(showColumnFilterLayerEvent);
    on<ShowTableColumnFilterLayerEvent>(showTableColumnFilterLayerEvent);
    on<HideLayerEvent>(hideLayerEvent);
    on<ResetAllFiltersEvent>(resetAllFiltersEvent);
    on<RearrangeColumnsEvent>(rearrangeColumnsEvent);
    on<ColumnVisibilityChangedEvent>(columnVisibilityChangedEvent);
    on<FilterColumnEvent>(filterColumnEvent);
    on<ClearColumnFilterEvent>(clearColumnFilterEvent);
    on<SortColumnEvent>(sortColumnEvent);
    on<FilterBySelectedEvent>(filterBySelectedEvent);
    on<FilterValueChangedEvent>(filterValueChangedEvent);
    on<SearchValueChangedEvent>(searchValueChangedEvent);
    on<CheckBoxToggledEvent>(checkBoxToggledEvent);
  }

  FutureOr<void> cloudDataChangeEvent(
      CloudDataChangeEvent event, Emitter<VisualizeStockState> emit) async {
    await Future.delayed(const Duration(seconds: 2));

    visualizeStock = await _initialVisualizeStockUseCase!();

    await _listenToCloudDataChangeVisualizeStockUseCase!(params: {
      "visualize_stock": visualizeStock,
      "on_change": event.onChange,
    });

    emit(LoadedState(visualizeStock: visualizeStock));
  }

  FutureOr<void> loadedEvent(
      LoadedEvent event, Emitter<VisualizeStockState> emit) async {
    emit(LoadedState(visualizeStock: visualizeStock));
  }

  FutureOr<void> importButtonClickedEvent(
      ImportButtonClickedEvent event, Emitter<VisualizeStockState> emit) async {
    await _importFromExcelUseCase!();
  }

  FutureOr<void> exportButtonClickedEvent(
      ExportButtonClickedEvent event, Emitter<VisualizeStockState> emit) async {
    await _exportToExcelUseCase!(params: {
      "visualize_stock": visualizeStock,
    });
  }

  FutureOr<void> showTableFilterLayerEvent(ShowTableFilterLayerEvent event,
      Emitter<VisualizeStockState> emit) async {
    emit(LoadedState(
        visualizeStock: await _addVisualizeStockLayerUseCase!(params: {
      "layer": "parent_filter",
      "visualize_stock": visualizeStock,
    })));
  }

  FutureOr<void> showColumnFilterLayerEvent(ShowColumnFilterLayerEvent event,
      Emitter<VisualizeStockState> emit) async {
    emit(LoadedState(
        visualizeStock: await _addVisualizeStockLayerUseCase!(params: {
      "field": event.field,
      "layer": "field_filter",
      "visualize_stock": visualizeStock,
    })));
  }

  FutureOr<void> showTableColumnFilterLayerEvent(
      ShowTableColumnFilterLayerEvent event,
      Emitter<VisualizeStockState> emit) async {
    emit(LoadedState(
        visualizeStock: await _addVisualizeStockLayerUseCase!(params: {
      "field": event.field,
      "layer": "parent_field_filter",
      "visualize_stock": visualizeStock,
    })));
  }

  FutureOr<void> hideLayerEvent(
      HideLayerEvent event, Emitter<VisualizeStockState> emit) async {
    emit(LoadedState(
        visualizeStock: await _hideVisualizeStockLayerUseCase!(params: {
      "layer": event.layer,
      "visualize_stock": visualizeStock,
    })));
  }

  FutureOr<void> resetAllFiltersEvent(
      ResetAllFiltersEvent event, Emitter<VisualizeStockState> emit) async {
    emit(LoadedState(
        visualizeStock: await _resetAllFiltersVisualizeStockUseCase!(params: {
      "visualize_stock": visualizeStock,
    })));
  }

  FutureOr<void> rearrangeColumnsEvent(
      RearrangeColumnsEvent event, Emitter<VisualizeStockState> emit) async {
    emit(LoadedState(
        visualizeStock: await _rearrangeColumnsUseCase!(params: {
      "fields": event.fields,
      "visualize_stock": visualizeStock,
    })));
  }

  FutureOr<void> columnVisibilityChangedEvent(
      ColumnVisibilityChangedEvent event,
      Emitter<VisualizeStockState> emit) async {
    emit(LoadedState(
        visualizeStock: await _changeColumnVisibilityUseCase!(params: {
      "field": event.field,
      "visibility": event.visibility,
      "visualize_stock": visualizeStock,
    })));
  }

  FutureOr<void> filterColumnEvent(
      FilterColumnEvent event, Emitter<VisualizeStockState> emit) async {
    emit(LoadedState(
        visualizeStock: await _filterColumnVisualizeStockUseCase!(params: {
      "field": event.field,
      "visualize_stock": visualizeStock,
    })));
  }

  FutureOr<void> clearColumnFilterEvent(
      ClearColumnFilterEvent event, Emitter<VisualizeStockState> emit) async {
    emit(LoadedState(
        visualizeStock: await _clearColumnFilterVisualizeStockUseCase!(params: {
      "field": event.field,
      "visualize_stock": visualizeStock,
    })));
  }

  FutureOr<void> sortColumnEvent(
      SortColumnEvent event, Emitter<VisualizeStockState> emit) async {
    emit(LoadedState(
        visualizeStock: await _sortColumnVisualizeStockUseCase!(params: {
      "field": event.field,
      "sort": event.sort,
      "visualize_stock": visualizeStock
    })));
  }

  FutureOr<void> filterBySelectedEvent(
      FilterBySelectedEvent event, Emitter<VisualizeStockState> emit) async {
    emit(LoadedState(
        visualizeStock: await _filterBySelectedVisualizeStockUseCase!(params: {
      "field": event.field,
      "filter_by": event.filterBy,
      "visualize_stock": visualizeStock,
    })));
  }

  FutureOr<void> filterValueChangedEvent(
      FilterValueChangedEvent event, Emitter<VisualizeStockState> emit) async {
    await _filterValueChangedVisualizeStockUseCase!(params: {
      "field": event.field,
      "filter_value": event.filterValue,
      "visualize_stock": visualizeStock,
    });
  }

  FutureOr<void> searchValueChangedEvent(
      SearchValueChangedEvent event, Emitter<VisualizeStockState> emit) async {
    emit(LoadedState(
        visualizeStock:
            await _searchValueChangedVisualizeStockUseCase!(params: {
      "field": event.field,
      "search_value": event.searchValue,
      "visualize_stock": visualizeStock,
    })));
  }

  FutureOr<void> checkBoxToggledEvent(
      CheckBoxToggledEvent event, Emitter<VisualizeStockState> emit) async {
    emit(LoadedState(
        visualizeStock: await _checkboxToggledVisualizeStockUseCase!(params: {
      "field": event.field,
      "title": event.title,
      "value": event.value,
      "visualize_stock": visualizeStock,
    })));
  }
}
