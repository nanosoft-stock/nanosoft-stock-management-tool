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
  const LoadedEvent({required this.fields});

  final List? fields;
}

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
