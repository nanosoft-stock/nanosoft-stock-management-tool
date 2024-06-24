part of 'add_new_stock_bloc.dart';

abstract class AddNewStockEvent extends Equatable {
  const AddNewStockEvent();

  @override
  List<Object> get props => [];
}

class CloudDataChangeEvent extends AddNewStockEvent {
  const CloudDataChangeEvent({required this.onChange});

  final Function(List)? onChange;
}

class LoadedEvent extends AddNewStockEvent {
  const LoadedEvent({required this.fields});

  final List? fields;
}

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
