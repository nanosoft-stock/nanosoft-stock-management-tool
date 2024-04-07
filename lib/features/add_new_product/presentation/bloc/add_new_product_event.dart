part of 'add_new_product_bloc.dart';

abstract class AddNewProductEvent extends Equatable {
  const AddNewProductEvent();

  @override
  List<Object> get props => [];
}

class LoadedEvent extends AddNewProductEvent {}

class CategorySelectedEvent extends AddNewProductEvent {
  const CategorySelectedEvent({required this.fields});

  final List? fields;
}

class AddNewProductButtonClickedEvent extends AddNewProductEvent {
  const AddNewProductButtonClickedEvent({required this.fields});

  final List? fields;
}
