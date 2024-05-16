part of 'visualize_stock_bloc.dart';

abstract class VisualizeStockEvent extends Equatable {
  const VisualizeStockEvent();

  @override
  List<Object> get props => [];
}

class CloudDataChangeEvent extends VisualizeStockEvent {}

class LoadingEvent extends VisualizeStockEvent {}

class LoadedEvent extends VisualizeStockEvent {
  const LoadedEvent({required this.visualizeStock});

  final Map? visualizeStock;
}

class SortFieldEvent extends VisualizeStockEvent {
  const SortFieldEvent({
    required this.field,
    required this.sort,
    required this.visualizeStock,
  });

  final String field;
  final Sort sort;
  final Map? visualizeStock;
}

class ParentFilterEvent extends VisualizeStockEvent {
  const ParentFilterEvent({required this.visualizeStock});

  final Map? visualizeStock;
}

class ImportButtonClickedEvent extends VisualizeStockEvent {
  const ImportButtonClickedEvent({required this.visualizeStock});

  final Map? visualizeStock;
}

class ExportButtonClickedEvent extends VisualizeStockEvent {
  const ExportButtonClickedEvent({required this.visualizeStock});

  final Map? visualizeStock;
}

class FieldFilterEvent extends VisualizeStockEvent {
  const FieldFilterEvent({required this.field, required this.visualizeStock});

  final String? field;
  final Map? visualizeStock;
}

class HideLayerEvent extends VisualizeStockEvent {
  const HideLayerEvent({required this.layer, required this.visualizeStock});

  final String? layer;
  final Map? visualizeStock;
}

class FilterBySelectedEvent extends VisualizeStockEvent {
  const FilterBySelectedEvent({
    required this.field,
    required this.filterBy,
    required this.visualizeStock,
  });

  final String? field;
  final String? filterBy;
  final Map? visualizeStock;
}

class FilterValueEnteredEvent extends VisualizeStockEvent {
  const FilterValueEnteredEvent({
    required this.field,
    required this.filterValue,
    required this.visualizeStock,
  });

  final String? field;
  final String? filterValue;
  final Map? visualizeStock;
}
