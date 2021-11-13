import 'app_localizations.dart';
import 'bloc/themeBloc/theme_bloc.dart';
import 'helper/Session.dart';
import 'screens/policy_screen.dart';

import 'bloc/controlApp/controlAppEvent.dart';
import 'bloc/Auth/auth_bloc.dart';
import 'bloc/BlocObserver.dart';
import 'bloc/Products/bloc_product.dart';
import 'bloc/chatBloc/chat_bloc.dart';
import 'bloc/controlApp/ControlAppBloc.dart';
import 'data/repo/firebase_firestore.dart';
import 'data/repo/post_auth.dart';
import 'helper/Strings.dart';
import 'screens/Home_screen.dart';
import 'screens/chat.dart';
import 'screens_delivery/categories.dart';
import 'screens_delivery/home.dart';
import 'screens_delivery/new_category.dart';
import 'screens_delivery/products.dart';
import 'screens_delivery/store_details.dart';
import 'screens_user/Search_stores.dart';
import 'screens_user/Stores_maps.dart';
import 'screens_user/setting_Screen.dart';
import 'screens/Q_A_Screen.dart';
import 'splash_screen.dart';
import 'data/repo/firebase_repo.dart';
import 'screens/send_notification.dart';
import 'screens_user/Explore_screen.dart';
import 'screens/auth_screen.dart';
import 'screens_user/Stores_views.dart';
import 'screens_user/favorite_screen.dart';
import 'screens_user/details_screen.dart';
import 'package:delivery_app/themes.dart';
import 'screens_user/search_product.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:flutter/material.dart';
import 'screens_delivery/new_product.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Bloc.observer = MyBlocObserver();
  Future<SharedPreferences> prefs = SharedPreferences.getInstance();

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  prefs.then((value) {
    String? theme = value.getString(THEME);
    ThemeMode themeMode;
    if (theme == DARK)
      themeMode = ThemeMode.dark;
    else if (theme == LIGHT)
      themeMode = ThemeMode.light;
    else
      themeMode = ThemeMode.system;
    runApp(MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (context) =>
                AuthBloc(PostAuth())..add(AuthSingInInitial())),
        BlocProvider(
            create: (context) =>
                BlocProduct(repo: FirebaseRepo())..add(FetchProducts())),
        BlocProvider(
            create: (context) => ControlAppBloc()..add(InitialValue())),
        BlocProvider(
            create: (context) => ChatBloc(DBFireStore())..add(InitialChat())),
        BlocProvider(create: (context) => ThemeBloc(themeMode)),
      ],
      child: MyApp(),
    ));
  });
}

class MyApp extends StatefulWidget {
  static void setLocale(BuildContext context, Locale newLocale) {
    _MyAppState? state = context.findAncestorStateOfType<_MyAppState>();
    state!.setLocale(newLocale);
  }

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale? _locale;

  setLocale(Locale locale) {
    if (mounted)
      setState(() {
        ControlAppBloc.get(context).setDirection(locale.languageCode);
        _locale = locale;
      });
  }

  @override
  void didChangeDependencies() {
    getLocale().then((locale) {
      ControlAppBloc.get(context).setDirection(locale.languageCode);
      if (mounted)
        setState(() {
          this._locale = locale;
        });
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final themeNotifier = BlocProvider.of<ThemeBloc>(context);
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, state) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          localizationsDelegates: [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: [
            Locale('en', ''),
            Locale('ar', ''),
          ],
          locale: _locale,
          theme: themeLight,
          darkTheme: themeDark,
          themeMode: themeNotifier.themeMode,
          initialRoute: SplashScreen.id,
          onGenerateRoute: (settings) {
            switch (settings.name) {
              case SplashScreen.id:
                return PageTransition(
                    child: SplashScreen(), type: PageTransitionType.fade);
              case AuthScreen.id:
                return PageTransition(
                    child: AuthScreen(),
                    type: PageTransitionType.rightToLeftWithFade);
              case ExploreScreen.id:
                return PageTransition(
                    child: ExploreScreen(),
                    type: PageTransitionType.rightToLeftWithFade,
                    settings: settings);
              case DetailsScreen.id:
                return PageTransition(
                    child: DetailsScreen(),
                    type: PageTransitionType.rightToLeftWithFade,
                    settings: settings);
              case FavoriteScreen.id:
                return PageTransition(
                    child: FavoriteScreen(),
                    type: PageTransitionType.rightToLeftWithFade);
              case HomeDelivery.id:
                return PageTransition(
                    child: HomeDelivery(),
                    type: PageTransitionType.rightToLeftWithFade);
              case Categories.id:
                return PageTransition(
                    child: Categories(),
                    type: PageTransitionType.rightToLeftWithFade);
              case Products.id:
                return PageTransition(
                    child: Products(),
                    type: PageTransitionType.rightToLeftWithFade);
              case PolicyScreen.id:
                return PageTransition(
                    child: PolicyScreen(),
                    type: PageTransitionType.rightToLeftWithFade);
              case Setting.id:
                return PageTransition(
                    child: Setting(),
                    type: PageTransitionType.rightToLeftWithFade);
              case NewProduct.id:
                return PageTransition(
                  child: NewProduct(),
                  type: PageTransitionType.rightToLeftWithFade,

                  /// hire data on setting added
                  settings: settings,
                );
              case NewCategory.id:
                return PageTransition(
                    child: NewCategory(),
                    type: PageTransitionType.rightToLeftWithFade,
                    settings: settings);
              case Home.id:
                return PageTransition(
                    child: Home(), type: PageTransitionType.fade);
              case StoreDetails.id:
                return PageTransition(
                  child: StoreDetails(),
                  type: PageTransitionType.rightToLeftWithFade,
                  settings: settings,
                );
              case SearchProducts.id:
                return PageTransition(
                  child: SearchProducts(),
                  type: PageTransitionType.rightToLeftWithFade,
                );
              case SearchStore.id:
                return PageTransition(
                  child: SearchStore(),
                  type: PageTransitionType.rightToLeftWithFade,
                );
              case StoresViews.id:
                return PageTransition(
                  child: StoresViews(),
                  type: PageTransitionType.rightToLeftWithFade,
                );
              case MapStores.id:
                return PageTransition(
                  child: MapStores(),
                  type: PageTransitionType.bottomToTop,
                );
              case SendChat.id:
                return PageTransition(
                  child: SendChat(),
                  settings: settings,
                  type: PageTransitionType.rightToLeftWithFade,
                );
              case SendNotification.id:
                return PageTransition(
                  child: SendNotification(),
                  type: PageTransitionType.rightToLeftWithFade,
                );
              case QAScreen.id:
                return PageTransition(
                  child: QAScreen(),
                  type: PageTransitionType.rightToLeftWithFade,
                );
              default:
                return null;
            }
          },
        );
      },
    );
  }
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  var data = message.notification;
  saveNotification(data!.title!, data.body!);
}
