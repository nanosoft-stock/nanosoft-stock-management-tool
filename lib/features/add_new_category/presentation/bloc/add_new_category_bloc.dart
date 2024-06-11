import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'add_new_category_event.dart';
part 'add_new_category_state.dart';

class AddNewCategoryBloc extends Bloc<AddNewCategoryEvent, AddNewCategoryState> {
  AddNewCategoryBloc() : super(AddNewCategoryInitial()) {
    on<AddNewCategoryEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
