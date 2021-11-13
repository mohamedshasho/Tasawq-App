import 'dart:ui';

import 'package:delivery_app/app_icons/app_icons.dart';
import 'package:delivery_app/bloc/Auth/auth_bloc.dart';
import 'package:delivery_app/bloc/Products/bloc_product.dart';
import 'package:delivery_app/bloc/themeBloc/theme_bloc.dart';
import 'package:delivery_app/componants/ContainerBn.dart';
import 'package:delivery_app/componants/appbar_custom.dart';
import 'package:delivery_app/helper/Session.dart';
import 'package:delivery_app/helper/Strings.dart';
import 'package:delivery_app/screens/Home_screen.dart';
import 'package:delivery_app/screens/Q_A_Screen.dart';
import 'package:delivery_app/screens/auth_screen.dart';
import 'package:delivery_app/screens/policy_screen.dart';
import 'package:delivery_app/wedgets/language_dialog.dart';
import 'package:delivery_app/wedgets/set_map_lat_long.dart';
import 'package:delivery_app/wedgets/theme_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share/share.dart';

import '../constants.dart';

class Setting extends StatelessWidget {
  static const String id = 'setting';
  static const IconData share_alt = IconData(0xf1e0);
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    BlocProduct bloc = BlocProduct.get(context);
    ThemeBloc themeBloc = ThemeBloc.get(context);
    AuthBloc authBloc = AuthBloc.get(context);
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(3.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BuildAppbar(
                title: getTranslated(context, 'Setting'),
                onTap: () => Navigator.pop(context),
              ),
              authBloc.isUserSignIn()
                  ? Text(
                      getTranslated(context, 'Personal'),
                      style: Theme.of(context).textTheme.headline4,
                    )
                  : const SizedBox(),
              authBloc.isUserSignIn()
                  ? ListTile(
                      leading: Icon(
                        Icons.person,
                        color: Theme.of(context).iconTheme.color,
                      ),
                      title: Text(
                        getTranslated(context, 'User Name'),
                        style: Theme.of(context).textTheme.headline5,
                      ),
                      subtitle: BlocBuilder<BlocProduct, DataState>(
                        builder: (context, state) {
                          return Text(
                            bloc.userStore != null
                                ? bloc.userStore!.value.username!
                                : 'User',
                            style: Theme.of(context).textTheme.headline5,
                          );
                        },
                      ),
                      trailing: IconButton(
                        onPressed: () {
                          _showBottomSheetUsername(context);
                        },
                        color: Theme.of(context).accentColor,
                        icon: const Icon(Icons.edit_outlined),
                      ),
                    )
                  : const SizedBox(),
              SizedBox(height: height * 0.01),
              authBloc.isUserSignIn()
                  ? Text(
                      ' ${getTranslated(context, 'Manage address')}:',
                      style: Theme.of(context).textTheme.headline4,
                    )
                  : const SizedBox(),
              authBloc.isUserSignIn()
                  ? BlocBuilder<BlocProduct, DataState>(
                      builder: (context, state) {
                        return ListTile(
                          leading: Icon(Icons.location_on_rounded,
                              color: Theme.of(context).iconTheme.color),
                          title: Text(
                            '${getTranslated(context, 'Locality')}: ${bloc.userStore != null && bloc.userStore!.value.locationUser != null ? bloc.userStore!.value.locationUser!.locality : ''}',
                            style: Theme.of(context).textTheme.headline5,
                          ),
                          subtitle: Text(
                            '${getTranslated(context, 'subLocality')}: ${bloc.userStore != null && bloc.userStore!.value.locationUser != null ? bloc.userStore!.value.locationUser!.subLocality : ''}',
                            style: Theme.of(context).textTheme.headline6,
                          ),
                          trailing: IconButton(
                            color: Theme.of(context).accentColor,
                            icon: const Icon(Icons.edit_location_outlined),
                            onPressed: () {
                              _showBottomSheetAddress(context);
                            },
                          ),
                        );
                      },
                    )
                  : const SizedBox(),
              const Divider(),
              SizedBox(height: height * 0.01),
              Text(
                getTranslated(context, 'General'),
                style: Theme.of(context).textTheme.headline4,
              ),
              Card(
                elevation: 0.5,
                child: Column(
                  children: [
                    InkWell(
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (ctx) {
                              return ThemeDialog();
                            });
                      },
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          children: [
                            const Icon(AppIcons.theme),
                            const SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  getTranslated(context, 'Change Theme'),
                                  style: Theme.of(context).textTheme.headline5,
                                ),
                                BlocBuilder<ThemeBloc, ThemeState>(
                                  builder: (context, state) {
                                    String theme;
                                    if (themeBloc.themeMode == ThemeMode.light)
                                      theme = LIGHT;
                                    else if (themeBloc.themeMode ==
                                        ThemeMode.dark)
                                      theme = DARK;
                                    else
                                      theme = SYSTEM;
                                    return Text(getTranslated(context, theme));
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (ctx) {
                              return LanguageDialog();
                            });
                      },
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          children: [
                            const Icon(AppIcons.language),
                            const SizedBox(width: 10),
                            Text(
                              getTranslated(context, 'Change Language'),
                              style: Theme.of(context).textTheme.headline5,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Text(getTranslated(context, 'About')),
              Card(
                elevation: 0.5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ItemAboutSetting(
                      title: 'Policy',
                      iconData: AppIcons.policy,
                      onPress: () =>
                          Navigator.pushNamed(context, PolicyScreen.id),
                    ),
                    ItemAboutSetting(
                      title: 'Invite Friends',
                      iconData: AppIcons.share,
                      onPress: () {
                        var str =
                            "$appName\n\n${getTranslated(context, 'APPFIND')}\n$androidLink$packageName";
                        Share.share(str);
                      },
                    ),
                    ItemAboutSetting(
                      title: 'Common Questions',
                      iconData: AppIcons.questions,
                      onPress: () => Navigator.pushNamed(context, QAScreen.id),
                    ),
                    ItemAboutSetting(
                      title: authBloc.isUserSignIn() ? 'Logout' : 'Sing In',
                      iconData: authBloc.isUserSignIn()
                          ? AppIcons.logout
                          : Icons.login,
                      onPress: () {
                        if (authBloc.isUserSignIn()) {
                          authBloc.add(SingOut());
                          Navigator.pushNamedAndRemoveUntil(
                              context, Home.id, (route) => false);
                        } else {
                          Navigator.pushNamed(context, AuthScreen.id);
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ItemAboutSetting extends StatelessWidget {
  const ItemAboutSetting(
      {required this.title, required this.iconData, this.onPress});
  final String title;
  final IconData iconData;
  final Function()? onPress;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPress,
      child: Container(
        child: Row(
          children: [
            Icon(iconData),
            const SizedBox(width: 10),
            Text(
              getTranslated(context, title),
              style: Theme.of(context).textTheme.headline5,
            ),
          ],
        ),
        padding: const EdgeInsets.all(12.0),
      ),
    );
  }
}

void _showBottomSheetAddress(BuildContext context) {
  BlocProduct bloc = BlocProduct.get(context);
  String? locality = bloc.userStore!.value.locationUser != null
      ? bloc.userStore!.value.locationUser!.locality
      : null;
  String? subLocality = bloc.userStore!.value.locationUser != null
      ? bloc.userStore!.value.locationUser!.subLocality
      : null;
  showModalBottomSheet<void>(
    context: context,
    shape: RoundedRectangleBorder(
        borderRadius: const BorderRadius.only(
      topLeft: const Radius.circular(15),
      topRight: const Radius.circular(15),
    )),
    elevation: 5,
    builder: (BuildContext context) {
      return SingleChildScrollView(
        padding: EdgeInsets.only(
            top: 10,
            bottom: MediaQueryData.fromWindow(window).viewInsets.bottom + 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(getTranslated(context, 'Edit Address')),
            const Divider(),
            TextFormField(
              initialValue: bloc.userStore!.value.locationUser != null &&
                      bloc.userStore!.value.locationUser!.locality != null
                  ? bloc.userStore!.value.locationUser!.locality
                  : null,
              onChanged: (val) {
                locality = val;
              },
              decoration: kTextFieldDecoration.copyWith(
                labelText: getTranslated(context, 'Locality'),
              ),
            ),
            const SizedBox(height: 10),
            TextFormField(
              initialValue: bloc.userStore!.value.locationUser != null &&
                      bloc.userStore!.value.locationUser!.locality != null
                  ? bloc.userStore!.value.locationUser!.subLocality
                  : null,
              onChanged: (val) {
                subLocality = val;
              },
              decoration: kTextFieldDecoration.copyWith(
                labelText: getTranslated(context, 'subLocality'),
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    getTranslated(context, 'on Map'),
                    style: Theme.of(context).textTheme.headline5,
                  ),
                  IconButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (ctx) {
                            return SetMapLatLong();
                          });
                    },
                    icon: const Icon(Icons.map),
                  )
                ],
              ),
            ),
            const SizedBox(height: 10),
            ContainerBn(
              title: getTranslated(context, 'Save'),
              color: Theme.of(context).buttonColor,
              onPress: () {
                if (locality != null || subLocality != null) {
                  bloc.add(EditAddress(
                      locality: locality!, subLocality: subLocality!));
                  Navigator.pop(context);
                }
              },
            ),
          ],
        ),
      );
    },
  );
}

void _showBottomSheetUsername(BuildContext context) {
  String? username;
  showModalBottomSheet<void>(
    context: context,
    shape: const RoundedRectangleBorder(
        borderRadius: const BorderRadius.only(
      topLeft: const Radius.circular(15),
      topRight: const Radius.circular(15),
    )),
    elevation: 5,
    builder: (BuildContext context) {
      BlocProduct bloc = BlocProduct.get(context);
      return SingleChildScrollView(
        padding: EdgeInsets.only(
            top: 10,
            bottom: MediaQueryData.fromWindow(window).viewInsets.bottom + 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(getTranslated(context, 'Edit Username')),
            const Divider(),
            TextFormField(
              initialValue: bloc.userStore!.value.username,
              decoration: kTextFieldDecoration.copyWith(
                labelText: getTranslated(context, 'Username'),
              ),
              onChanged: (val) {
                username = val;
              },
            ),
            const SizedBox(height: 10),
            ContainerBn(
              title: getTranslated(context, 'Save'),
              color: Theme.of(context).buttonColor,
              onPress: () {
                if (username != null) bloc.add(EditUsername(username!));
                Navigator.pop(context);
              },
            ),
          ],
        ),
      );
    },
  );
}
