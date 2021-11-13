part of 'theme_bloc.dart';

@immutable
abstract class ThemeEvent {}

class ChangeTheme extends ThemeEvent {
  final ThemeMode theme;
  ChangeTheme(this.theme);
}
