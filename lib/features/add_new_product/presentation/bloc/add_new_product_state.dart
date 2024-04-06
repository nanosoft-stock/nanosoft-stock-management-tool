part of 'add_new_product_bloc.dart';

abstract class AddNewProductState extends Equatable {
  const AddNewProductState({this.fields});

  final List? fields;

  @override
  List<Object> get props => [fields!];
}

abstract class AddNewProductActionState extends AddNewProductState {}

class LoadingState extends AddNewProductState {}

class LoadedState extends AddNewProductState {
  const LoadedState(List fields) : super(fields: fields);
}

class NewProductAddedActionState extends AddNewProductActionState {}

class ErrorState extends AddNewProductState {}
