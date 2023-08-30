import 'dart:convert';

import 'package:delivery_app/bloc/Products/bloc_product.dart';
import 'package:delivery_app/bloc/controlApp/ControlAppBloc.dart';
import 'package:delivery_app/bloc/controlApp/controlAppEvent.dart';
import 'package:delivery_app/helper/Session.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;

import 'Strings.dart';

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
FirebaseMessaging messaging = FirebaseMessaging.instance;

class NotificationsService {
  static final NotificationsService _notifications =
      NotificationsService._internal();
  factory NotificationsService() {
    return _notifications;
  }
  NotificationsService._internal();

  Future initialise(BuildContext context) async {
    iOSPermission();
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    // final IOSInitializationSettings initializationSettingsIOS =
    //     IOSInitializationSettings();
    // final MacOSInitializationSettings initializationSettingsMacOS =
    //     MacOSInitializationSettings();
    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid,
            // iOS: initializationSettingsIOS,
            // macOS: initializationSettingsMacOS
        );

    flutterLocalNotificationsPlugin.initialize(initializationSettings);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      var data = message.notification;
      generateSimpleNotication(data!.title!, data.body!);
      ControlAppBloc.get(context)
          .add(AddNotification(title: data.title!, body: data.body!));
    });
    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
      BlocProduct.get(context).add(SetToken(newToken.toString()));
    });
  }

  Future<String?> getToken() async {
    return await messaging.getToken();
  }

  void iOSPermission() async {
    await messaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  Future<String> sendNotificationBody(
      {required String title,
      required String body,
      required List<String> tokens,
      required BuildContext context}) async {
    try {
      var response = await http.post(
        Uri.parse(fcmUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'key=$fcmKey'
        },
        body: jsonEncode({
          //to:"token once"
          "registration_ids": tokens,
          "notification": {"title": title, "body": body, "sound": "default"},
          "android": {
            "priority": "HIGH",
            "notification": {
              "notification_priority": "PRIORITY_MAX",
              "sound": "default",
              "default_sound": true,
              "default_vibrate_timings": true,
              "default_light_settings": true
            }
          },
          "data": {
            "type": "notification",
            "id": "1",
            "click_action": "FLUTTER_NOTIFICATION_CLICK"
          }
        }),
      );
      if (response.statusCode == 200) {
        return getTranslated(context, 'Send Notification Successful');
      } else {
        return getTranslated(context, 'Send Notification Failed');
      }
    } catch (e) {
      return e.toString();
    }
  }
}

Future<void> generateSimpleNotication(String title, String msg,
    {String? type, String? id}) async {
  var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      '5', 'Stories alerts',
      importance: Importance.max, priority: Priority.high);
  // var iosDetail = IOSNotificationDetails();

  var platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      // iOS: iosDetail
  );
  await flutterLocalNotificationsPlugin.show(
      0, title, msg, platformChannelSpecifics);
}
