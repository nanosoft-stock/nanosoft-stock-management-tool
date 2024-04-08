part of 'home_bloc.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object> get props => [];
}

class LoadedEvent extends HomeEvent {}

class ViewSelectedEvent extends HomeEvent {
  const ViewSelectedEvent({required this.view});

  final String? view;

  @override
  List<Object> get props => [view!];
}

class SignOutEvent extends HomeEvent {}
