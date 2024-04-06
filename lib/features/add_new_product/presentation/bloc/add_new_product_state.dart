part of 'add_new_product_bloc.dart';

abstract class AddNewProductState extends Equatable {
  const AddNewProductState({this.fields});

  final List? fields;

  @override
  List<Object> get props => [fields!];
}

// class AddNewProductInitialState extends AddNewProductState {}

class AddNewProductLoadingState extends AddNewProductState {}

class AddNewProductLoadedState extends AddNewProductState {
  const AddNewProductLoadedState(List fields) : super(fields: fields);
}

// class AddNewProductCategorySelectedState extends AddNewProductState {}

// class AddNewProductButtonClickedState extends AddNewProductState {}

class AddNewProductErrorState extends AddNewProductState {}
