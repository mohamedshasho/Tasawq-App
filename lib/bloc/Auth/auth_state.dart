part of 'auth_bloc.dart';

@immutable
abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSingInSuccess extends AuthState {
  final Store user;
  AuthSingInSuccess(this.user);
}

class AuthSingInError extends AuthState {
  final String msg;
  AuthSingInError(this.msg);
}

class AuthSinUpSuccess extends AuthState {
  final Store user;
  AuthSinUpSuccess(this.user);
}

class AuthSingUpError extends AuthState {
  final String msg;
  AuthSingUpError(this.msg);
}

class AuthSignOutSuccess extends AuthState {}
