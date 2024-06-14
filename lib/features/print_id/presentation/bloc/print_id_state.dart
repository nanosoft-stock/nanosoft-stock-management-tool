part of 'print_id_bloc.dart';

abstract class PrintIdState extends Equatable {
  const PrintIdState({this.printIdData});

  final Map<String, dynamic>? printIdData;

  @override
  List<Object> get props => [
        Random().nextDouble(),
      ];
}

class PrintIdActionState extends PrintIdState {}

class LoadingState extends PrintIdState {}

class LoadedState extends PrintIdState {
  const LoadedState({super.printIdData});
}

class ErrorState extends PrintIdState {}
