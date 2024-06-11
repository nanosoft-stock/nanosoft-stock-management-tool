import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'print_id_event.dart';
part 'print_id_state.dart';

class PrintIdBloc extends Bloc<PrintIdEvent, PrintIdState> {
  PrintIdBloc() : super(PrintIdInitial()) {
    on<PrintIdEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
