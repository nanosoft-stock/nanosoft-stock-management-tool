import 'dart:async';
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:stock_management_tool/features/print_id/domain/usecases/initial_usecase.dart';
import 'package:stock_management_tool/features/print_id/domain/usecases/print_count_entered_usecase.dart';
import 'package:stock_management_tool/features/print_id/domain/usecases/print_id_selected_usecase.dart';
import 'package:stock_management_tool/features/print_id/domain/usecases/print_pressed_usecase.dart';

part 'print_id_event.dart';
part 'print_id_state.dart';

class PrintIdBloc extends Bloc<PrintIdEvent, PrintIdState> {
  final InitialPrintIdUseCase? _initialPrintIdUseCase;
  final PrintIdSelectedUseCase? _printIdSelectedUseCase;
  final PrintCountEnteredUseCase? _printCountEnteredUseCase;
  final PrintPressedUseCase? _printPressedUseCase;

  PrintIdBloc(this._initialPrintIdUseCase, this._printIdSelectedUseCase,
      this._printCountEnteredUseCase, this._printPressedUseCase)
      : super(LoadingState()) {
    on<LoadedEvent>(loadedEvent);
    on<PrintIdSelectedEvent>(printIdSelectedEvent);
    on<PrintCountChangedEvent>(printCountChangedEvent);
    on<PrintPressedEvent>(printPressedEvent);
  }

  FutureOr<void> loadedEvent(
      LoadedEvent event, Emitter<PrintIdState> emit) async {
    emit(LoadedState(printIdData: await _initialPrintIdUseCase!()));
  }

  FutureOr<void> printIdSelectedEvent(
      PrintIdSelectedEvent event, Emitter<PrintIdState> emit) async {
    emit(LoadedState(
        printIdData: await _printIdSelectedUseCase!(params: {
      "printable_id": event.printableId,
      "print_id_data": event.printIdData,
    })));
  }

  FutureOr<void> printCountChangedEvent(
      PrintCountChangedEvent event, Emitter<PrintIdState> emit) async {
    emit(LoadedState(
        printIdData: await _printCountEnteredUseCase!(params: {
      "print_count": event.printCount,
      "print_id_data": event.printIdData,
    })));
  }

  FutureOr<void> printPressedEvent(
      PrintPressedEvent event, Emitter<PrintIdState> emit) async {
    emit(LoadedState(
        printIdData: await _printPressedUseCase!(params: {
      "print_id_data": event.printIdData,
    })));
  }
}
