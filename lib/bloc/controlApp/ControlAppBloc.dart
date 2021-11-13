import 'package:bloc/bloc.dart';
import 'package:delivery_app/bloc/controlApp/controlAppEvent.dart';
import 'package:delivery_app/helper/Session.dart';
import 'package:delivery_app/screens/Profile_screen.dart';
import 'package:delivery_app/screens/chats_screen.dart';
import 'package:delivery_app/screens/notification_screen.dart';
import 'package:delivery_app/wedgets/HomeCategories_views.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'controlAppState.dart';

enum ChangeViews { Gird, List }

class ControlAppBloc extends Bloc<ControlAppEvent, ControlAppState> {
  ControlAppBloc() : super(ControlAppStateInitial());
  int index = 0;
  String? catID;

  ChangeViews changeViews = ChangeViews.Gird;
  ControlAppState get initialState => ControlAppChangedBottomBar(index);
  static ControlAppBloc get(context) => BlocProvider.of(context);
  late List<String> notificationTitle;
  late List<String> notificationBody;
  String direction = 'en'; //default
  List<Widget> screens = [
    HomeCategoriesView(),
    ChatScreen(),
    NotificationScreen(),
    ProfileScreen(),
  ];
  List<String> screenTitle = [
    'Home',
    'Chats',
    'Notification',
    'Profile',
  ];
  void setDirection(String dir) {
    direction = dir;
  }

  @override
  Stream<ControlAppState> mapEventToState(ControlAppEvent event) async* {
    if (event is ControlAppChangeBottomBar) {
      this.index = event.index;
      yield ControlAppChangedBottomBar(event.index);
    }
    if (event is InitialValue) {
      notificationTitle = await getNotificationsTitle();
      notificationBody = await getNotificationsBody();
    }
    if (event is ChangeCategory) {
      catID = event.catID;
      yield ChangedCategory();
    }
    if (event is ChangeGridToList) {
      if (changeViews == ChangeViews.Gird)
        changeViews = ChangeViews.List;
      else
        changeViews = ChangeViews.Gird;
      yield ChangedViews();
    }
    if (event is AddNotification) {
      await saveNotification(event.title, event.body);
      notificationTitle = await getNotificationsTitle();
      notificationBody = await getNotificationsBody();
      yield ChangedNotification();
    }
    if (event is RemoveNotification) {
      notificationTitle.removeAt(event.index);
      notificationBody.removeAt(event.index);
      await saveAllNotification(notificationTitle, notificationBody);
      yield ChangedNotification();
    }
  }
}
