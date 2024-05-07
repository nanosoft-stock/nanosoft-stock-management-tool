part of 'locate_stock_bloc.dart';

abstract class LocateStockState extends Equatable {
  const LocateStockState({
    this.index,
    this.locatedStock,
  });

  final int? index;
  final Map<String, dynamic>? locatedStock;

  @override
  List<Object> get props => [
        locatedStock!,
      ];
}

abstract class LocateStockActionState extends LocateStockState {}

class LoadingState extends LocateStockState {}

class LoadedState extends LocateStockState {
  const LoadedState({
    super.index,
    super.locatedStock,
  });
}

class ReduceDuplicationActionState extends LocateStockActionState {}

class ErrorState extends LocateStockState {}
