part of 'visualize_stock_bloc.dart';

abstract class VisualizeStockState extends Equatable {
  const VisualizeStockState({
    this.visualizeStock,
  });

  final Map? visualizeStock;

  @override
  List<Object> get props => [
        Random().nextDouble(),
      ];
}

class VisualizeStockActionState extends VisualizeStockState {}

class LoadingState extends VisualizeStockState {}

class LoadedState extends VisualizeStockState {
  const LoadedState({super.visualizeStock});
}

class ImportTableActionState extends VisualizeStockActionState {}

class ExportTableActionState extends VisualizeStockActionState {}

class ErrorState extends VisualizeStockState {}
