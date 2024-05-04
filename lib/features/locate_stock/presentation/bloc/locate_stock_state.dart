part of 'locate_stock_bloc.dart';

abstract class LocateStockState extends Equatable {
  const LocateStockState({
    this.locatedStock,
    this.selectedItems,
  });

  final Map<String, dynamic>? locatedStock;
  final Map<String, dynamic>? selectedItems;

  @override
  List<Object> get props => [
        locatedStock!,
      ];
}

abstract class LocateStockActionState extends LocateStockState {}

class LoadingState extends LocateStockState {}

class LoadedState extends LocateStockState {
  const LoadedState({super.locatedStock, super.selectedItems});
}

class ReduceDuplicationActionState extends LocateStockActionState {}

class PreviewMoveActionState extends LocateStockState {}

class ErrorState extends LocateStockState {}
