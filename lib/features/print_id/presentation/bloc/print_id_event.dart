part of 'print_id_bloc.dart';

abstract class PrintIdEvent extends Equatable {
  const PrintIdEvent();

  @override
  List<Object> get props => [];
}

class LoadingEvent extends PrintIdEvent {}

class LoadedEvent extends PrintIdEvent {}

class PrintIdSelectedEvent extends PrintIdEvent {
  const PrintIdSelectedEvent({required this.printId});

  final String? printId;
}

class PrintCountChangedEvent extends PrintIdEvent {
  const PrintCountChangedEvent({required this.printCount});

  final String? printCount;
}

class PrintPressedEvent extends PrintIdEvent {
  const PrintPressedEvent();
}
