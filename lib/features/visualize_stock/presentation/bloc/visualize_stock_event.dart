part of 'visualize_stock_bloc.dart';

abstract class VisualizeStockEvent extends Equatable {
  const VisualizeStockEvent();

  @override
  List<Object> get props => [];
}

class CloudDataChangeEvent extends VisualizeStockEvent {
  const CloudDataChangeEvent({required this.onChange});

  final Function(Map)? onChange;
}

class LoadingEvent extends VisualizeStockEvent {}

class LoadedEvent extends VisualizeStockEvent {
  const LoadedEvent({required this.visualizeStock});

  final Map<String, dynamic>? visualizeStock;
}

class ImportButtonClickedEvent extends VisualizeStockEvent {
  const ImportButtonClickedEvent({required this.visualizeStock});

  final Map<String, dynamic>? visualizeStock;
}

class ExportButtonClickedEvent extends VisualizeStockEvent {
  const ExportButtonClickedEvent({required this.visualizeStock});

  final Map<String, dynamic>? visualizeStock;
}

class ShowTableFilterLayerEvent extends VisualizeStockEvent {
  const ShowTableFilterLayerEvent({required this.visualizeStock});

  final Map<String, dynamic>? visualizeStock;
}

class ShowColumnFilterLayerEvent extends VisualizeStockEvent {
  const ShowColumnFilterLayerEvent(
      {required this.field, required this.visualizeStock});

  final String? field;
  final Map<String, dynamic>? visualizeStock;
}

class ShowTableColumnFilterLayerEvent extends VisualizeStockEvent {
  const ShowTableColumnFilterLayerEvent(
      {required this.field, required this.visualizeStock});

  final String? field;
  final Map<String, dynamic>? visualizeStock;
}

class HideLayerEvent extends VisualizeStockEvent {
  const HideLayerEvent({required this.layer, required this.visualizeStock});

  final String? layer;
  final Map<String, dynamic>? visualizeStock;
}

class RearrangeColumnsEvent extends VisualizeStockEvent {
  const RearrangeColumnsEvent(
      {required this.fields, required this.visualizeStock});

  final List? fields;
  final Map<String, dynamic>? visualizeStock;
}

class ResetAllFiltersEvent extends VisualizeStockEvent {
  const ResetAllFiltersEvent({required this.visualizeStock});

  final Map<String, dynamic>? visualizeStock;
}

class ColumnVisibilityChangedEvent extends VisualizeStockEvent {
  const ColumnVisibilityChangedEvent(
      {required this.field,
      required this.visibility,
      required this.visualizeStock});

  final String? field;
  final bool? visibility;
  final Map<String, dynamic>? visualizeStock;
}

class FilterColumnEvent extends VisualizeStockEvent {
  const FilterColumnEvent({
    required this.field,
    required this.visualizeStock,
  });

  final String? field;
  final Map<String, dynamic>? visualizeStock;
}

class ClearColumnFilterEvent extends VisualizeStockEvent {
  const ClearColumnFilterEvent({
    required this.field,
    required this.visualizeStock,
  });

  final String? field;
  final Map<String, dynamic>? visualizeStock;
}

class SortColumnEvent extends VisualizeStockEvent {
  const SortColumnEvent({
    required this.field,
    required this.sort,
    required this.visualizeStock,
  });

  final String field;
  final Sort sort;
  final Map<String, dynamic>? visualizeStock;
}

class FilterBySelectedEvent extends VisualizeStockEvent {
  const FilterBySelectedEvent({
    required this.field,
    required this.filterBy,
    required this.visualizeStock,
  });

  final String? field;
  final String? filterBy;
  final Map<String, dynamic>? visualizeStock;
}

class FilterValueChangedEvent extends VisualizeStockEvent {
  const FilterValueChangedEvent({
    required this.field,
    required this.filterValue,
    required this.visualizeStock,
  });

  final String? field;
  final String? filterValue;
  final Map<String, dynamic>? visualizeStock;
}

class SearchValueChangedEvent extends VisualizeStockEvent {
  const SearchValueChangedEvent({
    required this.field,
    required this.searchValue,
    required this.visualizeStock,
  });

  final String? field;
  final String? searchValue;
  final Map<String, dynamic>? visualizeStock;
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
  final Map<String, dynamic>? visualizeStock;
}
