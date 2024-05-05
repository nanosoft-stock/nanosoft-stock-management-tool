part of 'locate_stock_bloc.dart';

abstract class LocateStockState extends Equatable {
  const LocateStockState({
    this.locatedStock,
    this.selectedItems,
    this.index,
  });

  final Map<String, dynamic>? locatedStock;
  final Map<String, dynamic>? selectedItems;
  final int? index;

  @override
  List<Object> get props => [
        locatedStock!,
      ];
}

abstract class LocateStockActionState extends LocateStockState {
  const LocateStockActionState({
    super.locatedStock,
    super.selectedItems,
    super.index,
  });

  @override
  List<Object> get props => [
        locatedStock!,
      ];
}

class LoadingState extends LocateStockState {}

class LoadedState extends LocateStockState {
  const LoadedState({super.locatedStock, super.selectedItems});
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

class ReduceDuplicationActionState extends LocateStockActionState {}

class ErrorState extends LocateStockState {}
