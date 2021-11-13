import 'package:connectivity/connectivity.dart';
import 'package:delivery_app/app_localizations.dart';
import 'package:delivery_app/bloc/Auth/auth_bloc.dart';
import 'package:delivery_app/screens/auth_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants.dart';
import 'Strings.dart';

setPreference(String key, String? value) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString(key, value!);
}

saveNotification(String t, String b) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  List<String> title = prefs.getStringList('title') ?? [];
  List<String> body = prefs.getStringList('body') ?? [];
  title.add(t);
  body.add(b);
  await prefs.setStringList('title', title);
  await prefs.setStringList('body', body);
}

saveAllNotification(List<String> title, List<String> body) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setStringList('title', title);
  await prefs.setStringList('body', body);
}

Future<List<String>> getNotificationsTitle() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getStringList('title') ?? [];
}

Future<List<String>> getNotificationsBody() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getStringList('body') ?? [];
}

void removeAllNotification() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.remove('title');
  await prefs.remove('body');
}

Future<String?> getPreference(String key) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString(key) ?? null;
}

Future<bool> getPreferenceBool(String key) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getBool(key) ?? false;
}

setPreferenceBool(String key, bool value) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setBool(key, value);
}

Widget getProgress() {
  return Center(
      child: SpinKitFadingCube(
    color: secondaryColor,
  ));
}

Future<Locale> setLocale(String languageCode) async {
  SharedPreferences _prefs = await SharedPreferences.getInstance();
  await _prefs.setString(LANGUAGE_CODE, languageCode);
  return _locale(languageCode);
}

Future<Locale> getLocale() async {
  SharedPreferences _prefs = await SharedPreferences.getInstance();
  String languageCode = _prefs.getString(LANGUAGE_CODE) ?? "ar";
  return _locale(languageCode);
}

Locale _locale(String languageCode) {
  switch (languageCode) {
    case "en":
      return Locale("en", 'US');
    case "ar":
      return Locale("ar", "AR");
    default:
      return Locale("en", 'US');
  }
}

String getTranslated(BuildContext context, String key) {
  return AppLocalizations.of(context)!.translate(key)!;
}

bool checkUserNull(BuildContext context) {
  if (AuthBloc.get(context).isUserSignIn()) {
    return false;
  }
  Navigator.pushNamed(context, AuthScreen.id);
  return true;
}

Future<bool> isNetworkAvailable() async {
  var connectivityResult = await (Connectivity().checkConnectivity());
  if (connectivityResult == ConnectivityResult.mobile) {
    return true;
  } else if (connectivityResult == ConnectivityResult.wifi) {
    return true;
  }
  return false;
}

noIntImage() {
  return SvgPicture.asset(
    'assets/images/no_internet.svg',
    fit: BoxFit.contain,
  );
}

noIntText(BuildContext context) {
  return Container(
      child: Text(getTranslated(context, 'NO_INTERNET'),
          style: Theme.of(context).textTheme.headline5));
}

noIntDec(BuildContext context) {
  return Container(
    padding: EdgeInsetsDirectional.only(top: 30.0, start: 30.0, end: 30.0),
    child: Text(getTranslated(context, 'NO_INTERNET_DISC'),
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.headline6),
  );
}

clearSession() {
  SharedPreferences.getInstance().then((value) => value.clear());
}
