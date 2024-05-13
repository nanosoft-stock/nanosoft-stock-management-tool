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
  const SortFieldEvent(
      {required this.field, required this.sort, required this.visualizeStock});

  final String field;
  final Sort sort;
  final Map? visualizeStock;
}

class FilterFieldEvent extends VisualizeStockEvent {
  const FilterFieldEvent({required this.visualizeStock});

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
