part of 'visualize_stock_bloc.dart';

abstract class VisualizeStockEvent extends Equatable {
  const VisualizeStockEvent();

  @override
  List<Object> get props => [];
}

class LoadingEvent extends VisualizeStockEvent {}

class LoadedEvent extends VisualizeStockEvent {}

class SortFieldEvent extends VisualizeStockEvent {}

class FilterFieldEvent extends VisualizeStockEvent {}
