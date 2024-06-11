import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'modify_stock_event.dart';
part 'modify_stock_state.dart';

class ModifyStockBloc extends Bloc<ModifyStockEvent, ModifyStockState> {
  ModifyStockBloc() : super(ModifyStockInitial()) {
    on<ModifyStockEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
