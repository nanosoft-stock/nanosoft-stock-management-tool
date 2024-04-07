part of 'add_new_stock_bloc.dart';

abstract class AddNewStockEvent extends Equatable {
  const AddNewStockEvent();

  @override
  List<Object> get props => [];
}

class LoadedEvent extends AddNewStockEvent {}

class CategorySelectedEvent extends AddNewStockEvent {
  const CategorySelectedEvent({required this.fields});

  final List? fields;
}

class SkuSelectedEvent extends AddNewStockEvent {
  const SkuSelectedEvent({required this.fields});

  final List? fields;
}

class CheckBoxTapEvent extends AddNewStockEvent {
  const CheckBoxTapEvent({required this.fields});

  final List? fields;
}

class AddNewStockButtonClickedEvent extends AddNewStockEvent {
  const AddNewStockButtonClickedEvent({required this.fields});

  final List? fields;
}
