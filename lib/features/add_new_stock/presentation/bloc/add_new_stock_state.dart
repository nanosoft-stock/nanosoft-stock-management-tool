part of 'add_new_stock_bloc.dart';

abstract class AddNewStockState extends Equatable {
  const AddNewStockState({this.fields});

  final List? fields;

  @override
  List<Object> get props => [
        Random().nextDouble(),
      ];
}

abstract class AddNewStockActionState extends AddNewStockState {
  const AddNewStockActionState({required this.message});

  final String message;
}

class LoadingState extends AddNewStockState {}

class LoadedState extends AddNewStockState {
  const LoadedState({required super.fields});
}

class SuccessActionState extends AddNewStockActionState {
  const SuccessActionState({required super.message});
}

class ErrorActionState extends AddNewStockActionState {
  const ErrorActionState({required super.message, this.stackTrace});

  final StackTrace? stackTrace;
}
