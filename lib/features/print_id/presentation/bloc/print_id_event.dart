part of 'print_id_bloc.dart';

abstract class PrintIdEvent extends Equatable {
  const PrintIdEvent();

  @override
  List<Object> get props => [];
}

class LoadingEvent extends PrintIdEvent {}

class LoadedEvent extends PrintIdEvent {}

class PrintIdSelectedEvent extends PrintIdEvent {
  const PrintIdSelectedEvent(
      {required this.printId, required this.printIdData});

  final String? printId;
  final Map<String, dynamic>? printIdData;
}

class PrintCountChangedEvent extends PrintIdEvent {
  const PrintCountChangedEvent(
      {required this.printCount, required this.printIdData});

  final String? printCount;
  final Map<String, dynamic>? printIdData;
}

class PrintPressedEvent extends PrintIdEvent {
  const PrintPressedEvent({required this.printIdData});

  final Map<String, dynamic>? printIdData;
}
