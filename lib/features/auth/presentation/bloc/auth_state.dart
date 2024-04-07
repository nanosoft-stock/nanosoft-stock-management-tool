part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

abstract class AuthActionState extends AuthState {}

class LoginState extends AuthState {}

class SignUpState extends AuthState {}

class LoginSuccessfulActionState extends AuthActionState {}

class SignUpSuccessfulActionState extends AuthActionState {}

class ErrorState extends AuthActionState {}
