import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:delivery_app/data/repo/post_auth.dart';
import 'package:delivery_app/helper/Session.dart';
import 'package:delivery_app/helper/Strings.dart';
import 'package:delivery_app/models/store.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  PostAuthData repo;
  AuthBloc(this.repo) : super(AuthInitial());
  static AuthBloc get(context) => BlocProvider.of(context);
  Store? userModel;

  bool isUserSignIn() {
    return userModel!.email != null;
  }

  @override
  Stream<AuthState> mapEventToState(
    AuthEvent event,
  ) async* {
    if (event is AuthSingInInitial) {
      String? email = await getPreference(EMAIL);
      String? username = await getPreference(USERNAME) ?? 'User';
      String? typePerson = await getPreference(TYPE_PERSON) ?? '';
      userModel = Store(email: email, username: username, type: typePerson);
      if (email != null) yield AuthSingInSuccess(userModel!);
    }
    if (event is SingIn) {
      if (!await isNetworkAvailable()) {
        return;
      }
      try {
        yield AuthLoading();
        User user =
            await repo.singIN(email: event.email, password: event.password);
        String? username = await getPreference(USERNAME) ?? 'User';
        String? typePerson = await getPreference(TYPE_PERSON);
        userModel =
            Store(email: user.email, username: username, type: typePerson);
        yield AuthSingInSuccess(userModel!);
      } catch (e) {
        yield AuthSingInError(e.toString());
      }
    }
    if (event is SingUP) {
      if (!await isNetworkAvailable()) {
        return;
      }
      try {
        yield AuthLoading();
        User user = await repo.singUp(
            email: event.email,
            password: event.password,
            typePerson: event.typePerson,
            username: event.username,
            category: event.category);
        String? username = await getPreference(USERNAME) ?? 'User';
        String? typePerson = await getPreference(TYPE_PERSON);
        userModel =
            Store(email: user.email, username: username, type: typePerson);
        yield AuthSingInSuccess(userModel!);
      } catch (e) {
        yield AuthSingInError(e.toString());
      }
    }

    if (event is SignInWithGoogle) {
      if (!await isNetworkAvailable()) {
        return;
      }
      try {
        yield AuthLoading();
        User user = await repo.signInWithGoogle();
        String? username = await getPreference(USERNAME) ?? 'User';
        userModel = Store(email: user.email, username: username, type: USER);
        yield AuthSingInSuccess(userModel!);
      } catch (e) {
        yield AuthSingInError(e.toString());
      }
    }
    if (event is SignInWithFacebook) {
      if (!await isNetworkAvailable()) {
        return;
      }
      try {
        yield AuthLoading();
        User user = await repo.signInWithFacebook();
        String? username = await getPreference(USERNAME) ?? 'User';
        // String? typePerson = await getPrefrence(TYPE_PERSON); //no save only user
        userModel = Store(email: user.email, username: username, type: USER);
        yield AuthSingInSuccess(userModel!);
      } catch (e) {
        yield AuthSingInError(e.toString());
      }
    }
    if (event is SingOut) {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        userModel = null;
        userModel = Store(email: null, username: '', type: 'User');
        clearSession();
        await FirebaseAuth.instance.signOut();
        yield AuthSignOutSuccess();
      }
    }
  }
}
