part of 'add_new_stock_bloc.dart';

abstract class AddNewStockEvent extends Equatable {
  const AddNewStockEvent();

  @override
  List<Object> get props => [];
}

class CloudDataChangeEvent extends AddNewStockEvent {
  const CloudDataChangeEvent({required this.onChange});

  final Function() onChange;
}

class LoadedEvent extends AddNewStockEvent {
  const LoadedEvent();
}

class ValueTypedEvent extends AddNewStockEvent {
  const ValueTypedEvent({
    required this.field,
    required this.value,
  });

  final String field;
  final String value;
}

class ValueSelectedEvent extends AddNewStockEvent {
  const ValueSelectedEvent({
    required this.field,
    required this.value,
  });

  final String field;
  final String value;
}

class CheckBoxTapEvent extends AddNewStockEvent {
  const CheckBoxTapEvent({
    required this.field,
    required this.value,
  });

  final String field;
  final bool value;
}

class AddNewStockButtonClickedEvent extends AddNewStockEvent {
  const AddNewStockButtonClickedEvent();
}
