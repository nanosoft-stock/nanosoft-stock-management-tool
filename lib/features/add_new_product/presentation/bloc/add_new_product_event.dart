part of 'add_new_product_bloc.dart';

abstract class AddNewProductEvent extends Equatable {
  const AddNewProductEvent();

  @override
  List<Object> get props => [];
}

// class AddNewProductInitialEvent extends AddNewProductEvent {}

class AddNewProductLoadingEvent extends AddNewProductEvent {}

class AddNewProductLoadedEvent extends AddNewProductEvent {}

class AddNewProductCategorySelectedEvent extends AddNewProductEvent {
  const AddNewProductCategorySelectedEvent({this.category});

  final String? category;
}

class AddNewProductButtonClickedEvent extends AddNewProductEvent {
  const AddNewProductButtonClickedEvent({required this.fields});

  final List? fields;
}

class AddNewProductErrorEvent extends AddNewProductEvent {}
