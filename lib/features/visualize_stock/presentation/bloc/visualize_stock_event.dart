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

class ImportButtonClickedEvent extends VisualizeStockEvent {
  const ImportButtonClickedEvent({required this.visualizeStock});

  final Map? visualizeStock;
}

class ExportButtonClickedEvent extends VisualizeStockEvent {
  const ExportButtonClickedEvent({required this.visualizeStock});

  final Map? visualizeStock;
}

class ShowTableFilterLayerEvent extends VisualizeStockEvent {
  const ShowTableFilterLayerEvent({required this.visualizeStock});

  final Map? visualizeStock;
}

class ShowColumnFilterLayerEvent extends VisualizeStockEvent {
  const ShowColumnFilterLayerEvent(
      {required this.field, required this.visualizeStock});

  final String? field;
  final Map? visualizeStock;
}

class ShowTableColumnFilterLayerEvent extends VisualizeStockEvent {
  const ShowTableColumnFilterLayerEvent(
      {required this.field, required this.visualizeStock});

  final String? field;
  final Map? visualizeStock;
}

class HideLayerEvent extends VisualizeStockEvent {
  const HideLayerEvent({required this.layer, required this.visualizeStock});

  final String? layer;
  final Map? visualizeStock;
}

class RearrangeColumnsEvent extends VisualizeStockEvent {
  const RearrangeColumnsEvent(
      {required this.fields, required this.visualizeStock});

  final List? fields;
  final Map? visualizeStock;
}

class ResetAllFiltersEvent extends VisualizeStockEvent {
  const ResetAllFiltersEvent({required this.visualizeStock});

  final Map? visualizeStock;
}

class ColumnVisibilityChangedEvent extends VisualizeStockEvent {
  const ColumnVisibilityChangedEvent(
      {required this.field,
      required this.visibility,
      required this.visualizeStock});

  final String? field;
  final bool? visibility;
  final Map? visualizeStock;
}

class FilterColumnEvent extends VisualizeStockEvent {
  const FilterColumnEvent({
    required this.field,
    required this.visualizeStock,
  });

  final String? field;
  final Map? visualizeStock;
}

class ClearColumnFilterEvent extends VisualizeStockEvent {
  const ClearColumnFilterEvent({
    required this.field,
    required this.visualizeStock,
  });

  final String? field;
  final Map? visualizeStock;
}

class SortColumnEvent extends VisualizeStockEvent {
  const SortColumnEvent({
    required this.field,
    required this.sort,
    required this.visualizeStock,
  });

  final String field;
  final Sort sort;
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

class FilterValueChangedEvent extends VisualizeStockEvent {
  const FilterValueChangedEvent({
    required this.field,
    required this.filterValue,
    required this.visualizeStock,
  });

  final String? field;
  final String? filterValue;
  final Map? visualizeStock;
}

class SearchValueChangedEvent extends VisualizeStockEvent {
  const SearchValueChangedEvent({
    required this.field,
    required this.searchValue,
    required this.visualizeStock,
  });

  final String? field;
  final String? searchValue;
  final Map? visualizeStock;
}

class CheckBoxToggledEvent extends VisualizeStockEvent {
  const CheckBoxToggledEvent({
    required this.field,
    required this.title,
    required this.value,
    required this.visualizeStock,
  });

  final String? field;
  final String title;
  final bool? value;
  final Map? visualizeStock;
}
