part of 'add_new_stock_bloc.dart';

abstract class AddNewStockEvent extends Equatable {
  const AddNewStockEvent();

  @override
  List<Object> get props => [];
}

class AddNewStockActionEvent extends AddNewStockEvent {}

class AddNewStockLoadedEvent extends AddNewStockEvent {}

class AddNewStockCategorySelectedEvent extends AddNewStockEvent {
  const AddNewStockCategorySelectedEvent({required this.fields});

  final List? fields;
}

class AddNewStockSkuSelectedEvent extends AddNewStockEvent {
  const AddNewStockSkuSelectedEvent({required this.fields});

  final List? fields;
}

class AddNewStockCheckBoxTapEvent extends AddNewStockEvent {
  const AddNewStockCheckBoxTapEvent({required this.fields});

  final List? fields;
}

class AddNewStockButtonClickedEvent extends AddNewStockEvent {
  const AddNewStockButtonClickedEvent({required this.fields});

  final List? fields;
}

class AddNewStockErrorEvent extends AddNewStockEvent {}
