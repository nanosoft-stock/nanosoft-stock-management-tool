part of 'locate_stock_bloc.dart';

abstract class LocateStockState extends Equatable {
  const LocateStockState({
    this.index,
    this.locatedStock,
    this.selectedItems,
    this.pendingStateItems,
    this.completedStateItems,
  });

  final int? index;
  final Map<String, dynamic>? locatedStock;
  final Map<String, dynamic>? selectedItems;
  final List<Map<String, dynamic>>? pendingStateItems;
  final List<Map<String, dynamic>>? completedStateItems;

  @override
  List<Object> get props => [
        locatedStock!,
      ];
}

abstract class LocateStockActionState extends LocateStockState {
  const LocateStockActionState({
    super.index,
    super.locatedStock,
    super.selectedItems,
    super.pendingStateItems,
    super.completedStateItems,
  });

  @override
  List<Object> get props => [
        locatedStock!,
      ];
}

class LoadingState extends LocateStockState {}

class LoadedState extends LocateStockState {
  const LoadedState({
    super.locatedStock,
    super.selectedItems,
  });
}

class MultipleSelectionOverlayActionState extends LocateStockActionState {
  const MultipleSelectionOverlayActionState({
    super.index,
    super.locatedStock,
    super.selectedItems,
  });
}

class PreviewMoveActionState extends LocateStockActionState {
  const PreviewMoveActionState({
    super.locatedStock,
    super.selectedItems,
  });
}

class PendingMoveActionState extends LocateStockActionState {
  const PendingMoveActionState({
    super.locatedStock,
    super.pendingStateItems,
  });
}

class CompletedMovesActionState extends LocateStockActionState {
  const CompletedMovesActionState({
    super.locatedStock,
    super.completedStateItems,
  });
}

class ReduceDuplicationActionState extends LocateStockActionState {}

class ErrorState extends LocateStockState {}
