part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class LoginSelectedEvent extends AuthEvent {}

class SignUpSelectedEvent extends AuthEvent {}

class LoginButtonClickedEvent extends AuthEvent {
  const LoginButtonClickedEvent({
    required this.email,
    required this.password,
  });

  final String email;
  final String password;
}

class SignUpButtonClickedEvent extends AuthEvent {
  const SignUpButtonClickedEvent({
    required this.username,
    required this.email,
    required this.password,
  });

  final String username;
  final String email;
  final String password;
}
