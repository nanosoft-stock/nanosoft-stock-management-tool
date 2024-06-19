part of 'add_new_stock_bloc.dart';

abstract class AddNewStockState extends Equatable {
  const AddNewStockState({this.fields});

  final List? fields;

  @override
  List<Object> get props => [
        Random().nextDouble(),
      ];
}

abstract class AddNewStockActionState extends AddNewStockState {}

class LoadingState extends AddNewStockState {}

class LoadedState extends AddNewStockState {
  const LoadedState(List fields) : super(fields: fields);
}

class ReduceDuplicationActionState extends AddNewStockActionState {}

class NewStockAddedActionState extends AddNewStockActionState {}

class ErrorState extends AddNewStockState {}
