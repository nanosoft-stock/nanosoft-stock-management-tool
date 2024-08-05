part of 'locate_stock_bloc.dart';

abstract class LocateStockEvent extends Equatable {
  const LocateStockEvent();

  @override
  List<Object> get props => [];
}

class CloudDataChangeEvent extends LocateStockEvent {
  const CloudDataChangeEvent({required this.onChange});

  final Function(Map)? onChange;
}

class LoadedEvent extends LocateStockEvent {
  const LoadedEvent();
}

class AddNewInputRowEvent extends LocateStockEvent {
  const AddNewInputRowEvent();
}

class RemoveInputRowEvent extends LocateStockEvent {
  const RemoveInputRowEvent({
    required this.index,
  });

  final int? index;
}

class AddOverlayLayerEvent extends LocateStockEvent {
  const AddOverlayLayerEvent({
    required this.layer,
    required this.index,
  });

  final String? layer;
  final int? index;
}

class HideOverlayLayerEvent extends LocateStockEvent {
  const HideOverlayLayerEvent({
    required this.layer,
  });

  final String? layer;
}

class SearchByFieldFilledEvent extends LocateStockEvent {
  const SearchByFieldFilledEvent({
    required this.index,
    required this.searchBy,
  });

  final int? index;
  final String? searchBy;
}

class ChooseIdsButtonPressedEvent extends LocateStockEvent {
  const ChooseIdsButtonPressedEvent({
    required this.index,
  });

  final int? index;
}

class IdEnteredEvent extends LocateStockEvent {
  const IdEnteredEvent({
    required this.index,
    required this.chosenId,
  });

  final int? index;
  final String? chosenId;
}

class IdsChosenEvent extends LocateStockEvent {
  const IdsChosenEvent({
    required this.index,
    required this.chosenIds,
  });

  final int? index;
  final List? chosenIds;
}

class ResetAllFiltersEvent extends LocateStockEvent {
  const ResetAllFiltersEvent({
    required this.index,
  });

  final int? index;
}

class FieldFilterSelectedEvent extends LocateStockEvent {
  const FieldFilterSelectedEvent({
    required this.index,
    required this.field,
  });

  final int? index;
  final String? field;
}

class FilterFieldEvent extends LocateStockEvent {
  const FilterFieldEvent({
    required this.index,
  });

  final int? index;
}

class ClearFieldFilterEvent extends LocateStockEvent {
  const ClearFieldFilterEvent({
    required this.index,
    required this.field,
  });

  final int? index;
  final String? field;
}

class FilterBySelectedEvent extends LocateStockEvent {
  const FilterBySelectedEvent({
    required this.index,
    required this.field,
    required this.filterBy,
  });

  final int? index;
  final String? field;
  final String? filterBy;
}

class FilterByValueChangedEvent extends LocateStockEvent {
  const FilterByValueChangedEvent({
    required this.index,
    required this.field,
    required this.value,
  });

  final int? index;
  final String? field;
  final String? value;
}

class SearchValueChangedEvent extends LocateStockEvent {
  const SearchValueChangedEvent({
    required this.index,
    required this.field,
    required this.value,
  });

  final int? index;
  final String? field;
  final String? value;
}

class FilterCheckBoxToggledEvent extends LocateStockEvent {
  const FilterCheckBoxToggledEvent({
    required this.index,
    required this.field,
    required this.title,
    required this.value,
  });

  final int? index;
  final String? field;
  final String? title;
  final bool? value;
}

class SwitchTableViewEvent extends LocateStockEvent {
  const SwitchTableViewEvent({
    required this.index,
    required this.showTable,
  });

  final int? index;
  final bool? showTable;
}

class SwitchStockViewModeEvent extends LocateStockEvent {
  const SwitchStockViewModeEvent({
    required this.index,
    required this.mode,
  });

  final int? index;
  final StockViewMode? mode;
}

class IdCheckBoxToggledEvent extends LocateStockEvent {
  const IdCheckBoxToggledEvent({
    required this.index,
    required this.id,
    required this.state,
  });

  final int? index;
  final String? id;
  final CheckBoxState? state;
}

class SelectAllCheckBoxToggledEvent extends LocateStockEvent {
  const SelectAllCheckBoxToggledEvent({
    required this.index,
    required this.state,
  });

  final int? index;
  final CheckBoxState? state;
}

class PreviewMoveButtonPressedEvent extends LocateStockEvent {
  const PreviewMoveButtonPressedEvent();
}

class ContainerIdEnteredEvent extends LocateStockEvent {
  const ContainerIdEnteredEvent({
    required this.text,
  });

  final String? text;
}

class WarehouseLocationIdEnteredEvent extends LocateStockEvent {
  const WarehouseLocationIdEnteredEvent({
    required this.text,
  });

  final String? text;
}

class MoveItemsButtonPressedEvent extends LocateStockEvent {
  const MoveItemsButtonPressedEvent();
}

class PendingMovesButtonPressedEvent extends LocateStockEvent {
  const PendingMovesButtonPressedEvent();
}

class ExpandPendingMovesItemEvent extends LocateStockEvent {
  const ExpandPendingMovesItemEvent({
    required this.index,
    required this.i,
    required this.isExpanded,
  });

  final int? index;
  final int? i;
  final bool? isExpanded;
}

class CompleteMoveButtonPressedEvent extends LocateStockEvent {
  const CompleteMoveButtonPressedEvent({
    required this.index,
  });

  final int? index;
}

class CancelMoveButtonPressedEvent extends LocateStockEvent {
  const CancelMoveButtonPressedEvent({
    required this.index,
  });

  final int? index;
}

class CompletedMovesButtonPressedEvent extends LocateStockEvent {
  const CompletedMovesButtonPressedEvent();
}

class ExpandCompletedMovesItemEvent extends LocateStockEvent {
  const ExpandCompletedMovesItemEvent({
    required this.index,
    required this.i,
    required this.isExpanded,
  });

  final int? index;
  final int? i;
  final bool? isExpanded;
}
