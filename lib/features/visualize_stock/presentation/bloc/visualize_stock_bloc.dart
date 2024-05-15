import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:stock_management_tool/constants/enums.dart';
import 'package:stock_management_tool/features/visualize_stock/domain/usecases/add_visualize_stock_layer_usecase.dart';
import 'package:stock_management_tool/features/visualize_stock/domain/usecases/export_to_excel_usecase.dart';
import 'package:stock_management_tool/features/visualize_stock/domain/usecases/hide_visualize_stock_layer_usecase.dart';
import 'package:stock_management_tool/features/visualize_stock/domain/usecases/import_from_excel_usecase.dart';
import 'package:stock_management_tool/features/visualize_stock/domain/usecases/initial_usecase.dart';
import 'package:stock_management_tool/features/visualize_stock/domain/usecases/listen_to_cloud_data_change_usecase.dart';
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

  VisualizeStockBloc(
    this._listenToCloudDataChangeUseCase,
    this._initialVisualizeStockUseCase,
    this._sortVisualizeStockUseCase,
    this._importFromExcelUseCase,
    this._exportToExcelUseCase,
    this._addVisualizeStockLayerUseCase,
    this._hideVisualizeStockLayerUseCase,
  ) : super(LoadingState()) {
    on<CloudDataChangeEvent>(cloudDataChangeEvent);
    on<LoadedEvent>(loadedEvent);
    on<SortFieldEvent>(sortFieldEvent);
    on<ParentFilterEvent>(parentFilterEvent);
    on<ImportButtonClickedEvent>(importButtonClickedEvent);
    on<ExportButtonClickedEvent>(exportButtonClickedEvent);
    on<FieldFilterEvent>(fieldFilterEvent);
    on<HideLayerEvent>(hideLayerEvent);
  }

  FutureOr<void> cloudDataChangeEvent(
      CloudDataChangeEvent event, Emitter<VisualizeStockState> emit) async {
    await Future.delayed(const Duration(seconds: 2));
    Map<String, dynamic> visualizeStock =
        await _initialVisualizeStockUseCase!();
    // await _listenToCloudDataChangeUseCase!(params: {
    //   "onChange": () {
    //     add(LoadedEvent());
    //   }
    // });
    emit(ReduceDuplicationActionState());
    emit(LoadedState(visualizeStock: visualizeStock));
  }

  FutureOr<void> loadedEvent(
      LoadedEvent event, Emitter<VisualizeStockState> emit) async {
    emit(ReduceDuplicationActionState());
    emit(LoadedState(visualizeStock: event.visualizeStock));
    // emit(LoadedState(await _allFieldsUseCase!(), await _allStockUseCase!()));
  }

  FutureOr<void> sortFieldEvent(
      SortFieldEvent event, Emitter<VisualizeStockState> emit) async {
    emit(ReduceDuplicationActionState());
    emit(LoadedState(
        visualizeStock: await _sortVisualizeStockUseCase!(params: {
      "field": event.field,
      "sort": event.sort,
      "visualize_stock": event.visualizeStock
    })));
    // emit(LoadedState(
    //     await _sortFieldUseCase!(
    //         params: {"field": event.field, "sort": event.sort}),
    //     await _sortStockUseCase!(
    //         params: {"field": event.field, "sort": event.sort})));
  }

  FutureOr<void> parentFilterEvent(
      ParentFilterEvent event, Emitter<VisualizeStockState> emit) {}

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
    emit(ReduceDuplicationActionState());
    emit(LoadedState(
        visualizeStock: await _addVisualizeStockLayerUseCase!(params: {
      "field": event.field,
      "visualize_stock": event.visualizeStock,
    })));
  }

  FutureOr<void> hideLayerEvent(
      HideLayerEvent event, Emitter<VisualizeStockState> emit) async {
    emit(ReduceDuplicationActionState());
    emit(LoadedState(
        visualizeStock: await _hideVisualizeStockLayerUseCase!(params: {
      "layer": event.layer,
      "visualize_stock": event.visualizeStock,
    })));
  }
}
