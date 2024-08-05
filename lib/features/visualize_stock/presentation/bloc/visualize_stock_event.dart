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

class LoadedEvent extends VisualizeStockEvent {
  const LoadedEvent();
}

class ImportButtonClickedEvent extends VisualizeStockEvent {
  const ImportButtonClickedEvent();
}

class ExportButtonClickedEvent extends VisualizeStockEvent {
  const ExportButtonClickedEvent();
}

class ShowTableFilterLayerEvent extends VisualizeStockEvent {
  const ShowTableFilterLayerEvent();
}

class ShowColumnFilterLayerEvent extends VisualizeStockEvent {
  const ShowColumnFilterLayerEvent({
    required this.field,
  });

  final String? field;
}

class ShowTableColumnFilterLayerEvent extends VisualizeStockEvent {
  const ShowTableColumnFilterLayerEvent({
    required this.field,
  });

  final String? field;
}

class HideLayerEvent extends VisualizeStockEvent {
  const HideLayerEvent({
    required this.layer,
  });

  final String? layer;
}

class RearrangeColumnsEvent extends VisualizeStockEvent {
  const RearrangeColumnsEvent({
    required this.fields,
  });

  final List? fields;
}

class ResetAllFiltersEvent extends VisualizeStockEvent {
  const ResetAllFiltersEvent();
}

class ColumnVisibilityChangedEvent extends VisualizeStockEvent {
  const ColumnVisibilityChangedEvent({
    required this.field,
    required this.visibility,
  });

  final String? field;
  final bool? visibility;
}

class FilterColumnEvent extends VisualizeStockEvent {
  const FilterColumnEvent({
    required this.field,
  });

  final String? field;
}

class ClearColumnFilterEvent extends VisualizeStockEvent {
  const ClearColumnFilterEvent({
    required this.field,
  });

  final String? field;
}

class SortColumnEvent extends VisualizeStockEvent {
  const SortColumnEvent({
    required this.field,
    required this.sort,
  });

  final String field;
  final Sort sort;
}

class FilterBySelectedEvent extends VisualizeStockEvent {
  const FilterBySelectedEvent({
    required this.field,
    required this.filterBy,
  });

  final String? field;
  final String? filterBy;
}

class FilterValueChangedEvent extends VisualizeStockEvent {
  const FilterValueChangedEvent({
    required this.field,
    required this.filterValue,
  });

  final String? field;
  final String? filterValue;
}

class SearchValueChangedEvent extends VisualizeStockEvent {
  const SearchValueChangedEvent({
    required this.field,
    required this.searchValue,
  });

  final String? field;
  final String? searchValue;
}

class CheckBoxToggledEvent extends VisualizeStockEvent {
  const CheckBoxToggledEvent({
    required this.field,
    required this.title,
    required this.value,
  });

  final String? field;
  final String title;
  final bool? value;
}
