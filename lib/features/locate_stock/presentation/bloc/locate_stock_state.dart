part of 'locate_stock_bloc.dart';

abstract class LocateStockState extends Equatable {
  const LocateStockState({
    this.locatedItems,
    this.selectedItems,
  });

  final List<Map<String, dynamic>>? locatedItems;
  final Map<String, dynamic>? selectedItems;

  @override
  List<Object> get props => [
        locatedItems!,
      ];
}

abstract class LocateStockActionState extends LocateStockState {}

class LoadingState extends LocateStockState {}

class LoadedState extends LocateStockState {
  const LoadedState({super.locatedItems, super.selectedItems});
}

class ReduceDuplicationActionState extends LocateStockActionState {}

class PreviewMoveActionState extends LocateStockState {}

class ErrorState extends LocateStockState {}
