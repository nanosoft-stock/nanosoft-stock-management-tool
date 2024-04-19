part of 'locate_stock_bloc.dart';

abstract class LocateStockState extends Equatable {
  const LocateStockState({
    this.locatedItems,
  });

  final List<Map<String, dynamic>>? locatedItems;

  @override
  List<Object> get props => [
        locatedItems!,
      ];
}

abstract class LocateStockActionState extends LocateStockState {}

class LoadingState extends LocateStockState {}

class LoadedState extends LocateStockState {
  const LoadedState(List<Map<String, dynamic>>? locatedItems) : super(locatedItems: locatedItems);
}

class ReduceDuplicationActionState extends LocateStockActionState {}

class ErrorState extends LocateStockState {}
