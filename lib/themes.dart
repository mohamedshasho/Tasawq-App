import 'package:flutter/material.dart';

import 'constants.dart';

var themeLight = ThemeData(
  colorScheme: ColorScheme(
    primary: primary,
    onPrimary: Colors.black,
    secondary: secondaryColor,
    onSecondary: Colors.black,
    background: ContainerBackgroundColor,
    onBackground: Colors.black,
    surface: kItemColor,
    onSurface: Colors.black,
    error: Colors.red,
    onError: Colors.white,
    brightness: Brightness.light,
  ),
  fontFamily: "Cairo",
  canvasColor: kBackgroundScaffold,
  focusColor: kItemFocusColorLight,
  shadowColor: shadowColorLight,
  iconTheme: IconThemeData(color: kItemColor),
  scaffoldBackgroundColor: kBackgroundScaffold,
  radioTheme: RadioThemeData(
    fillColor: MaterialStateProperty.all(secondaryColor),
  ),
  cardColor: Colors.white,
  //card color
  // buttonColor: kItemColor, // replaced to surface
  //button color
  dividerColor: secondaryColor,
  //divider and listTile and PopMenuDividers color
  bottomAppBarColor: primary,
  sliderTheme: SliderThemeData(
    thumbShape: RoundSliderThumbShape(elevation: 4),
    thumbColor: secondaryColor,
    activeTrackColor: secondaryColorDark,
    inactiveTrackColor: secondaryColor,
    overlayColor: secondaryColor.withOpacity(0.5),
  ),
  textTheme: ThemeData
      .light()
      .textTheme
      .copyWith(
    headline1: TextStyle(
      fontSize: 35.0,
      fontWeight: FontWeight.bold,
      color: kTextColorH2,
      // fontFamily: "Cairo",
    ),
    headline2: TextStyle(
      fontSize: 30.0,
      fontWeight: FontWeight.bold,
      color: kTextColorH2,
    ),
    headline3: TextStyle(
      fontSize: 25.0,
      color: kTextColorH2,
    ),
    headline4: TextStyle(
      fontSize: 20,
      color: kTextColorH2,
    ),
    headline6: TextStyle(
      fontSize: 12.0,
      color: kTextColorH6,
    ),
    headline5: TextStyle(
      fontSize: 15.0,
      color: kTextColorH2,
    ),
  ),
);

var themeDark = ThemeData(
  colorScheme: ColorScheme(
    primary: primaryDark,
    onPrimary: Colors.white,
    secondary: secondaryColorDark,
    onSecondary: Colors.white,
    background: ContainerBackgroundColorDark,
    onBackground: Colors.white,
    surface: kButtonColor,
    onSurface: Colors.white,
    error: Colors.red,
    onError: Colors.white,
    brightness: Brightness.dark,
  ),
  fontFamily: 'Cairo',
  canvasColor: kBackgroundScaffoldDark,
  focusColor: kItemFocusColorDark,
  // item selected and unselected
  scaffoldBackgroundColor: kBackgroundScaffoldDark,
  cardColor: Color(0xFF111111),
  shadowColor: shadowColorDark,
  radioTheme: RadioThemeData(
    fillColor: MaterialStateProperty.all(secondaryColorDark),
  ),
  dividerColor: secondaryColorDark,
  sliderTheme: SliderThemeData(
    thumbShape: RoundSliderThumbShape(elevation: 4),
    thumbColor: Colors.black,
    activeTrackColor: Colors.black45,
    inactiveTrackColor: Colors.black26,
    overlayColor: Colors.black.withOpacity(0.5),
  ),
  textTheme: ThemeData
      .dark()
      .textTheme
      .copyWith(
    headline1: TextStyle(
      fontSize: 35.0,
      fontWeight: FontWeight.bold,
    ),
    headline2: TextStyle(
      fontSize: 30.0,
      fontWeight: FontWeight.bold,
    ),
    headline3: TextStyle(
      fontSize: 25.0,
    ),
    headline4: TextStyle(
      fontSize: 20,
    ),
    headline6: TextStyle(
      fontSize: 12.0,
    ),
    headline5: TextStyle(
      fontSize: 15.0,
    ),
  ),
  primaryTextTheme: ThemeData
      .dark()
      .textTheme
      .apply(
    fontFamily: 'Cairo',
  ),
  bottomAppBarTheme: BottomAppBarTheme(color: primary),
);
