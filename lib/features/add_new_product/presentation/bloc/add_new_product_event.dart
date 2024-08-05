part of 'add_new_product_bloc.dart';

abstract class AddNewProductEvent extends Equatable {
  const AddNewProductEvent();

  @override
  List<Object> get props => [];
}

class CloudDataChangeEvent extends AddNewProductEvent {
  const CloudDataChangeEvent({required this.onChange});

  final Function(List)? onChange;
}

class LoadedEvent extends AddNewProductEvent {
  const LoadedEvent();
}

class ValueTypedEvent extends AddNewProductEvent {
  const ValueTypedEvent({
    required this.field,
    required this.value,
  });

  final String field;
  final String value;
}

class ValueSelectedEvent extends AddNewProductEvent {
  const ValueSelectedEvent({
    required this.field,
    required this.value,
  });

  final String field;
  final String value;
}

class AddNewProductButtonClickedEvent extends AddNewProductEvent {
  const AddNewProductButtonClickedEvent();
}
