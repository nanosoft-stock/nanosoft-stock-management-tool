part of 'home_bloc.dart';

abstract class HomeState extends Equatable {
  const HomeState({this.view});

  final String? view;

  @override
  List<Object> get props => [view!];
}

abstract class HomeActionState extends HomeState {}

class LoadingState extends HomeState {}

class ViewLoadedState extends HomeState {
  const ViewLoadedState(String view) : super(view: view);
}

class SignOutActionState extends HomeActionState {}

class ErrorState extends HomeState {}
