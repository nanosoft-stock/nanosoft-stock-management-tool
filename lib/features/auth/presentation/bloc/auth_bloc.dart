import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:stock_management_tool/features/auth/domain/usecases/sign_in_user_usecase.dart';
import 'package:stock_management_tool/features/auth/domain/usecases/sign_up_user_usecase.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SignInUserUseCase? _signInUserUseCase;
  final SignUpUserUseCase? _signUpUserUseCase;

  AuthBloc(
    this._signInUserUseCase,
    this._signUpUserUseCase,
  ) : super(LoginState()) {
    on<LoginSelectedEvent>(loginSelectedEvent);
    on<SignUpSelectedEvent>(signUpSelectedEvent);
    on<LoginButtonClickedEvent>(loginButtonClickedEvent);
    on<SignUpButtonClickedEvent>(signUpButtonClickedEvent);
  }

  FutureOr<void> loginSelectedEvent(
      LoginSelectedEvent event, Emitter<AuthState> emit) {
    emit(LoginState());
  }

  FutureOr<void> signUpSelectedEvent(
      SignUpSelectedEvent event, Emitter<AuthState> emit) {
    emit(SignUpState());
  }

  FutureOr<void> loginButtonClickedEvent(
      LoginButtonClickedEvent event, Emitter<AuthState> emit) async {
    await _signInUserUseCase!(params: {
      "email": event.email,
      "password": event.password,
    });
    emit(LoginSuccessfulActionState());
  }

  FutureOr<void> signUpButtonClickedEvent(
      SignUpButtonClickedEvent event, Emitter<AuthState> emit) async {
    await _signUpUserUseCase!(params: {
      "username": event.username,
      "email": event.email,
      "password": event.password,
    });
    emit(SignUpSuccessfulActionState());
  }
}
