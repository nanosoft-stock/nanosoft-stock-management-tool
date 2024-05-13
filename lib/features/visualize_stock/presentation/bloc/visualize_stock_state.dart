part of 'visualize_stock_bloc.dart';

abstract class VisualizeStockState extends Equatable {
  const VisualizeStockState({
    // this.fields,
    // this.stocks,
    this.visualizeStock,
  });

  // final List? fields;
  // final List? stocks;
  final Map? visualizeStock;

  @override
  List<Object> get props => [
        // fields!,
        // stocks!,
        visualizeStock!,
      ];
}

class VisualizeStockActionState extends VisualizeStockState {}

class LoadingState extends VisualizeStockState {}

class LoadedState extends VisualizeStockState {
  const LoadedState({super.visualizeStock});
}

class ImportTableActionState extends VisualizeStockActionState {}

class ExportTableActionState extends VisualizeStockActionState {}

class ReduceDuplicationActionState extends VisualizeStockActionState {}

class ErrorState extends VisualizeStockState {}
