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

class HideOverlayLayerEvent extends LocateStockEvent {
  const HideOverlayLayerEvent({
    required this.layer,
    required this.locatedStock,
  });

  final String? layer;
  final Map<String, dynamic>? locatedStock;
}

class SearchByFieldFilled extends LocateStockEvent {
  const SearchByFieldFilled({
    required this.index,
    required this.searchBy,
    required this.locatedStock,
  });

  final int? index;
  final String? searchBy;
  final Map<String, dynamic>? locatedStock;
}

class CustomSearchMenuSelected extends LocateStockEvent {}

class ChooseIdsButtonPressed extends LocateStockEvent {
  const ChooseIdsButtonPressed({
    required this.index,
    required this.locatedStock,
  });

  final int? index;
  final Map<String, dynamic>? locatedStock;
}

class IdEntered extends LocateStockEvent {
  const IdEntered({
    required this.index,
    required this.chosenId,
    required this.locatedStock,
  });

  final int? index;
  final String? chosenId;
  final Map<String, dynamic>? locatedStock;
}

class IdsChosen extends LocateStockEvent {
  const IdsChosen({
    required this.index,
    required this.chosenIds,
    required this.locatedStock,
  });

  final int? index;
  final List? chosenIds;
  final Map<String, dynamic>? locatedStock;
}

class SwitchTableView extends LocateStockEvent {
  const SwitchTableView({
    required this.index,
    required this.showTable,
    required this.locatedStock,
  });

  final int? index;
  final bool? showTable;
  final Map<String, dynamic>? locatedStock;
}

class SwitchStockViewMode extends LocateStockEvent {
  const SwitchStockViewMode({
    required this.index,
    required this.mode,
    required this.locatedStock,
  });

  final int? index;
  final StockViewMode? mode;
  final Map<String, dynamic>? locatedStock;
}

class IdCheckBoxToggled extends LocateStockEvent {
  const IdCheckBoxToggled({
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

class SelectAllCheckBoxToggled extends LocateStockEvent {
  const SelectAllCheckBoxToggled({
    required this.index,
    required this.state,
    required this.locatedStock,
  });

  final int? index;
  final CheckBoxState? state;
  final Map<String, dynamic>? locatedStock;
}

class PreviewMoveButtonPressed extends LocateStockEvent {
  const PreviewMoveButtonPressed({required this.locatedStock});

  final Map<String, dynamic>? locatedStock;
}

class ContainerIdEntered extends LocateStockEvent {
  const ContainerIdEntered({
    required this.text,
    required this.locatedStock,
  });

  final String? text;
  final Map<String, dynamic>? locatedStock;
}

class WarehouseLocationIdEntered extends LocateStockEvent {
  const WarehouseLocationIdEntered({
    required this.text,
    required this.locatedStock,
  });

  final String? text;
  final Map<String, dynamic>? locatedStock;
}

class MoveItemsButtonPressed extends LocateStockEvent {
  const MoveItemsButtonPressed({
    required this.locatedStock,
  });

  final Map<String, dynamic>? locatedStock;
}

class PendingMovesButtonPressed extends LocateStockEvent {
  const PendingMovesButtonPressed({
    required this.locatedStock,
  });

  final Map<String, dynamic>? locatedStock;
}

class CompleteMoveButtonPressed extends LocateStockEvent {
  const CompleteMoveButtonPressed({
    required this.index,
    required this.locatedStock,
  });

  final int? index;
  final Map<String, dynamic>? locatedStock;
}

class CancelMoveButtonPressed extends LocateStockEvent {
  const CancelMoveButtonPressed({
    required this.index,
    required this.locatedStock,
  });

  final int? index;
  final Map<String, dynamic>? locatedStock;
}

class CompletedMovesButtonPressed extends LocateStockEvent {
  const CompletedMovesButtonPressed({
    required this.locatedStock,
  });

  final Map<String, dynamic>? locatedStock;
}
