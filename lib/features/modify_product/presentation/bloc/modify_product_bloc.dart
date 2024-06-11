import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'modify_product_event.dart';
part 'modify_product_state.dart';

class ModifyProductBloc extends Bloc<ModifyProductEvent, ModifyProductState> {
  ModifyProductBloc() : super(ModifyProductInitial()) {
    on<ModifyProductEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
