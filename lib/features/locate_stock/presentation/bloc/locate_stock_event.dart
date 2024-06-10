part of 'locate_stock_bloc.dart';

abstract class LocateStockEvent extends Equatable {
  const LocateStockEvent();

  @override
  List<Object> get props => [];
}

class LoadedEvent extends LocateStockEvent {
  const LoadedEvent({this.locatedStock});

  final Map<String, dynamic>? locatedStock;
}

class CloudDataChangeEvent extends LocateStockEvent {
  const CloudDataChangeEvent({this.locatedStock});

  final Map<String, dynamic>? locatedStock;
}

class AddNewInputRowEvent extends LocateStockEvent {
  const AddNewInputRowEvent({required this.locatedStock});

  final Map<String, dynamic>? locatedStock;
}

class RemoveInputRowEvent extends LocateStockEvent {
  const RemoveInputRowEvent({
    required this.index,
    required this.locatedStock,
  });

  final int? index;
  final Map<String, dynamic>? locatedStock;
}

class AddOverlayLayerEvent extends LocateStockEvent {
  const AddOverlayLayerEvent({
    required this.layer,
    required this.index,
    required this.locatedStock,
  });

  final String? layer;
  final int? index;
  final Map<String, dynamic>? locatedStock;
}

class HideOverlayLayerEvent extends LocateStockEvent {
  const HideOverlayLayerEvent({
    required this.layer,
    required this.locatedStock,
  });

  final String? layer;
  final Map<String, dynamic>? locatedStock;
}

class SearchByFieldFilledEvent extends LocateStockEvent {
  const SearchByFieldFilledEvent({
    required this.index,
    required this.searchBy,
    required this.locatedStock,
  });

  final int? index;
  final String? searchBy;
  final Map<String, dynamic>? locatedStock;
}

class ChooseIdsButtonPressedEvent extends LocateStockEvent {
  const ChooseIdsButtonPressedEvent({
    required this.index,
    required this.locatedStock,
  });

  final int? index;
  final Map<String, dynamic>? locatedStock;
}

class IdEnteredEvent extends LocateStockEvent {
  const IdEnteredEvent({
    required this.index,
    required this.chosenId,
    required this.locatedStock,
  });

  final int? index;
  final String? chosenId;
  final Map<String, dynamic>? locatedStock;
}

class IdsChosenEvent extends LocateStockEvent {
  const IdsChosenEvent({
    required this.index,
    required this.chosenIds,
    required this.locatedStock,
  });

  final int? index;
  final List? chosenIds;
  final Map<String, dynamic>? locatedStock;
}

class ResetAllFiltersEvent extends LocateStockEvent {
  const ResetAllFiltersEvent({
    required this.index,
    required this.locatedStock,
  });

  final int? index;
  final Map<String, dynamic>? locatedStock;
}

class FieldFilterSelectedEvent extends LocateStockEvent {
  const FieldFilterSelectedEvent({
    required this.index,
    required this.field,
    required this.locatedStock,
  });

  final int? index;
  final String? field;
  final Map<String, dynamic>? locatedStock;
}

class FilterFieldEvent extends LocateStockEvent {
  const FilterFieldEvent({
    required this.index,
    required this.locatedStock,
  });

  final int? index;
  final Map<String, dynamic>? locatedStock;
}

class ClearFieldFilterEvent extends LocateStockEvent {
  const ClearFieldFilterEvent({
    required this.index,
    required this.field,
    required this.locatedStock,
  });

  final int? index;
  final String? field;
  final Map<String, dynamic>? locatedStock;
}

class FilterBySelectedEvent extends LocateStockEvent {
  const FilterBySelectedEvent({
    required this.index,
    required this.field,
    required this.filterBy,
    required this.locatedStock,
  });

  final int? index;
  final String? field;
  final String? filterBy;
  final Map<String, dynamic>? locatedStock;
}

class FilterByValueChangedEvent extends LocateStockEvent {
  const FilterByValueChangedEvent({
    required this.index,
    required this.field,
    required this.value,
    required this.locatedStock,
  });

  final int? index;
  final String? field;
  final String? value;
  final Map<String, dynamic>? locatedStock;
}

class SearchValueChangedEvent extends LocateStockEvent {
  const SearchValueChangedEvent({
    required this.index,
    required this.field,
    required this.value,
    required this.locatedStock,
  });

  final int? index;
  final String? field;
  final String? value;
  final Map<String, dynamic>? locatedStock;
}

class FilterCheckBoxToggledEvent extends LocateStockEvent {
  const FilterCheckBoxToggledEvent({
    required this.index,
    required this.field,
    required this.title,
    required this.value,
    required this.locatedStock,
  });

  final int? index;
  final String? field;
  final String? title;
  final bool? value;
  final Map<String, dynamic>? locatedStock;
}

class SwitchTableViewEvent extends LocateStockEvent {
  const SwitchTableViewEvent({
    required this.index,
    required this.showTable,
    required this.locatedStock,
  });

  final int? index;
  final bool? showTable;
  final Map<String, dynamic>? locatedStock;
}

class SwitchStockViewModeEvent extends LocateStockEvent {
  const SwitchStockViewModeEvent({
    required this.index,
    required this.mode,
    required this.locatedStock,
  });

  final int? index;
  final StockViewMode? mode;
  final Map<String, dynamic>? locatedStock;
}

class IdCheckBoxToggledEvent extends LocateStockEvent {
  const IdCheckBoxToggledEvent({
    required this.index,
    required this.id,
    required this.state,
    required this.locatedStock,
  });

  final int? index;
  final String? id;
  final CheckBoxState? state;
  final Map<String, dynamic>? locatedStock;
}

class SelectAllCheckBoxToggledEvent extends LocateStockEvent {
  const SelectAllCheckBoxToggledEvent({
    required this.index,
    required this.state,
    required this.locatedStock,
  });

  final int? index;
  final CheckBoxState? state;
  final Map<String, dynamic>? locatedStock;
}

class PreviewMoveButtonPressedEvent extends LocateStockEvent {
  const PreviewMoveButtonPressedEvent({required this.locatedStock});

  final Map<String, dynamic>? locatedStock;
}

class ContainerIdEnteredEvent extends LocateStockEvent {
  const ContainerIdEnteredEvent({
    required this.text,
    required this.locatedStock,
  });

  final String? text;
  final Map<String, dynamic>? locatedStock;
}

class WarehouseLocationIdEnteredEvent extends LocateStockEvent {
  const WarehouseLocationIdEnteredEvent({
    required this.text,
    required this.locatedStock,
  });

  final String? text;
  final Map<String, dynamic>? locatedStock;
}

class MoveItemsButtonPressedEvent extends LocateStockEvent {
  const MoveItemsButtonPressedEvent({
    required this.locatedStock,
  });

  final Map<String, dynamic>? locatedStock;
}

class PendingMovesButtonPressedEvent extends LocateStockEvent {
  const PendingMovesButtonPressedEvent({
    required this.locatedStock,
  });

  final Map<String, dynamic>? locatedStock;
}

class ExpandPendingMovesItemEvent extends LocateStockEvent {
  const ExpandPendingMovesItemEvent({
    required this.index,
    required this.isExpanded,
    required this.locatedStock,
  });

  final int? index;
  final bool? isExpanded;
  final Map<String, dynamic>? locatedStock;
}

class CompleteMoveButtonPressedEvent extends LocateStockEvent {
  const CompleteMoveButtonPressedEvent({
    required this.index,
    required this.locatedStock,
  });

  final int? index;
  final Map<String, dynamic>? locatedStock;
}

class CancelMoveButtonPressedEvent extends LocateStockEvent {
  const CancelMoveButtonPressedEvent({
    required this.index,
    required this.locatedStock,
  });

  final int? index;
  final Map<String, dynamic>? locatedStock;
}

class CompletedMovesButtonPressedEvent extends LocateStockEvent {
  const CompletedMovesButtonPressedEvent({
    required this.locatedStock,
  });

  final Map<String, dynamic>? locatedStock;
}

class ExpandCompletedMovesItemEvent extends LocateStockEvent {
  const ExpandCompletedMovesItemEvent({
    required this.index,
    required this.isExpanded,
    required this.locatedStock,
  });

  final int? index;
  final bool? isExpanded;
  final Map<String, dynamic>? locatedStock;
}
