import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'modify_category_event.dart';
part 'modify_category_state.dart';

class ModifyCategoryBloc extends Bloc<ModifyCategoryEvent, ModifyCategoryState> {
  ModifyCategoryBloc() : super(ModifyCategoryInitial()) {
    on<ModifyCategoryEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
