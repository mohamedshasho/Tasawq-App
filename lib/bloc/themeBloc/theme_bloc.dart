import 'dart:async';

import 'package:delivery_app/helper/Session.dart';
import 'package:delivery_app/helper/Strings.dart';
import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

part 'theme_event.dart';
part 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc(this._themeMode) : super(ThemeInitial());

  static ThemeBloc get(context) => BlocProvider.of(context);
  ThemeMode _themeMode;
  ThemeMode get themeMode => _themeMode;
  @override
  Stream<ThemeState> mapEventToState(
    ThemeEvent event,
  ) async* {
    if (event is ChangeTheme) {
      _themeMode = event.theme;
      String theme;
      if (_themeMode == ThemeMode.light)
        theme = LIGHT;
      else if (_themeMode == ThemeMode.dark)
        theme = DARK;
      else
        theme = SYSTEM;
      await setPreference(THEME, theme);
      emit(ChangedTheme());
    }
  }
}
