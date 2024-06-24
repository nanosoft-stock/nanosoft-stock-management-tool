part of 'modify_category_bloc.dart';

abstract class ModifyCategoryState extends Equatable {
  const ModifyCategoryState({this.modifyCategoryData});

  final Map<String, dynamic>? modifyCategoryData;

  @override
  List<Object> get props => [
        Random().nextDouble(),
      ];
}

class ModifyCategoryActionState extends ModifyCategoryState {}

class LoadingState extends ModifyCategoryState {}

class LoadedState extends ModifyCategoryState {
  const LoadedState({super.modifyCategoryData});
}

class ErrorState extends ModifyCategoryActionState {}
