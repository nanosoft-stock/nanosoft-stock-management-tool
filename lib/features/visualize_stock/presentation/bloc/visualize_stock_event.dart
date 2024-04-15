part of 'visualize_stock_bloc.dart';

abstract class VisualizeStockEvent extends Equatable {
  const VisualizeStockEvent();

  @override
  List<Object> get props => [];
}

class LoadingEvent extends VisualizeStockEvent {}

class LoadedEvent extends VisualizeStockEvent {}

class SortFieldEvent extends VisualizeStockEvent {
  const SortFieldEvent({required this.field, required this.sort});

  final String field;
  final Sort sort;
}

class FilterFieldEvent extends VisualizeStockEvent {}

class ImportButtonClickedEvent extends VisualizeStockEvent {}

class ExportButtonClickedEvent extends VisualizeStockEvent {}
