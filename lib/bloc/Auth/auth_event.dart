part of 'auth_bloc.dart';

@immutable
abstract class AuthEvent {}

class AuthSingInInitial extends AuthEvent {}

class SingIn extends AuthEvent {
  // final UserModel user;
  final String email;
  final String password;
  SingIn({required this.email, required this.password});
}

class SingUP extends AuthEvent {
  // final UserModel user;
  final String email;
  final String password;
  final String username;
  final String typePerson;
  final String? category;
  SingUP(
      {required this.typePerson,
      required this.email,
      required this.password,
      required this.username,
      this.category});
}

class SingOut extends AuthEvent {}

class SignInWithGoogle extends AuthEvent {}

class SignInWithFacebook extends AuthEvent {}
