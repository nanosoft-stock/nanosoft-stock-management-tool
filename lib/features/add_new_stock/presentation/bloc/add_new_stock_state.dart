part of 'add_new_stock_bloc.dart';

abstract class AddNewStockState extends Equatable {
  const AddNewStockState({this.fields});

  final List? fields;

  @override
  List<Object> get props {
    return [
      fields!,
    ];
  }
}

class AddNewStockActionState extends AddNewStockState {}

class AddNewStockLoadingState extends AddNewStockState {}

class AddNewStockLoadedState extends AddNewStockState {
  const AddNewStockLoadedState(List fields) : super(fields: fields);
}

class AddNewStockErrorState extends AddNewStockState {}
