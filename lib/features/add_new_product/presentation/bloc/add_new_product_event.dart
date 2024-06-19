part of 'add_new_product_bloc.dart';

abstract class AddNewProductEvent extends Equatable {
  const AddNewProductEvent();

  @override
  List<Object> get props => [];
}

class LoadedEvent extends AddNewProductEvent {}

class ValueTypedEvent extends AddNewProductEvent {
  const ValueTypedEvent({
    required this.field,
    required this.value,
    required this.fields,
  });

  final String field;
  final String value;
  final List? fields;
}

class ValueSelectedEvent extends AddNewProductEvent {
  const ValueSelectedEvent({
    required this.field,
    required this.value,
    required this.fields,
  });

  final String field;
  final String value;
  final List? fields;
}

class AddNewProductButtonClickedEvent extends AddNewProductEvent {
  const AddNewProductButtonClickedEvent({required this.fields});

  final List? fields;
}
