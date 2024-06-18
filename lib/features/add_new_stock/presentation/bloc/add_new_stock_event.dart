part of 'add_new_stock_bloc.dart';

abstract class AddNewStockEvent extends Equatable {
  const AddNewStockEvent();

  @override
  List<Object> get props => [];
}

class LoadedEvent extends AddNewStockEvent {}

class ValueTypedEvent extends AddNewStockEvent {
  const ValueTypedEvent({
    required this.field,
    required this.value,
    required this.fields,
  });

  final String field;
  final String value;
  final List? fields;
}

class ValueSelectedEvent extends AddNewStockEvent {
  const ValueSelectedEvent({
    required this.field,
    required this.value,
    required this.fields,
  });

  final String field;
  final String value;
  final List? fields;
}

class CheckBoxTapEvent extends AddNewStockEvent {
  const CheckBoxTapEvent({
    required this.field,
    required this.value,
    required this.fields,
  });

  final String field;
  final bool value;
  final List? fields;
}

class AddNewStockButtonClickedEvent extends AddNewStockEvent {
  const AddNewStockButtonClickedEvent({
    required this.fields,
  });

  final List? fields;
}
