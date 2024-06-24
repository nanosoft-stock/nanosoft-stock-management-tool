part of 'add_new_category_bloc.dart';

abstract class AddNewCategoryState extends Equatable {
  const AddNewCategoryState({this.addNewCategoryData});

  final Map<String, dynamic>? addNewCategoryData;

  @override
  List<Object> get props => [
        Random().nextDouble(),
      ];
}

class AddNewCategoryActionState extends AddNewCategoryState {}

class LoadingState extends AddNewCategoryState {}

class LoadedState extends AddNewCategoryState {
  const LoadedState({super.addNewCategoryData});
}

class ErrorState extends AddNewCategoryActionState {}
