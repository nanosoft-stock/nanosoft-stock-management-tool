import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:stock_management_tool/features/visualize_stock/domain/usecases/get_all_fields_usecase.dart';
import 'package:stock_management_tool/features/visualize_stock/domain/usecases/get_all_stock_usecase.dart';

part 'visualize_stock_event.dart';
part 'visualize_stock_state.dart';

class VisualizeStockBloc extends Bloc<VisualizeStockEvent, VisualizeStockState> {
  final GetAllFieldsUseCase? _allFieldsUseCase;
  final GetAllStockUseCase? _allStockUseCase;

  VisualizeStockBloc(this._allFieldsUseCase, this._allStockUseCase) : super(LoadingState()) {
    on<LoadedEvent>(loadedEvent);
    on<SortFieldEvent>(sortFieldEvent);
    on<FilterFieldEvent>(filterFieldEvent);
  }

  FutureOr<void> loadedEvent(LoadedEvent event, Emitter<VisualizeStockState> emit) async {
    emit(LoadedState(await _allFieldsUseCase!(), await _allStockUseCase!()));
  }

  FutureOr<void> sortFieldEvent(SortFieldEvent event, Emitter<VisualizeStockState> emit) {}

  FutureOr<void> filterFieldEvent(FilterFieldEvent event, Emitter<VisualizeStockState> emit) {}
}
