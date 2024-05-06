import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:stock_management_tool/features/home/domain/usecases/sign_out_user_usecase.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final SignOutUserUseCase _signOutUserUseCase;

  HomeBloc(this._signOutUserUseCase)
      : super(const ViewLoadedState("Visualise Stock")) {
    on<LoadedEvent>(loadedEvent);
    on<ViewSelectedEvent>(viewSelectedEvent);
    on<SignOutEvent>(signOutEvent);
  }

  FutureOr<void> loadedEvent(LoadedEvent event, Emitter<HomeState> emit) {
    emit(const ViewLoadedState("Visualise Stock"));
  }

  FutureOr<void> viewSelectedEvent(
      ViewSelectedEvent event, Emitter<HomeState> emit) {
    emit(ViewLoadedState(event.view!));
  }

  FutureOr<void> signOutEvent(
      SignOutEvent event, Emitter<HomeState> emit) async {
    await _signOutUserUseCase();
    emit(SignOutActionState());
  }
}
