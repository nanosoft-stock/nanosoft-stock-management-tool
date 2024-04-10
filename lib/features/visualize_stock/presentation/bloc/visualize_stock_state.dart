part of 'visualize_stock_bloc.dart';

abstract class VisualizeStockState extends Equatable {
  const VisualizeStockState({this.fields, this.stocks});

  final List? fields;
  final List? stocks;

  @override
  List<Object> get props => [
        fields!,
        stocks!,
      ];
}

class VisualizeStockActionState extends VisualizeStockState {}

class LoadingState extends VisualizeStockState {}

class LoadedState extends VisualizeStockState {
  const LoadedState(List fields, List stocks) : super(fields: fields, stocks: stocks);
}

class ImportTableActionState extends VisualizeStockActionState {}

class ExportTableActionState extends VisualizeStockActionState {}

class ErrorState extends VisualizeStockState {}
