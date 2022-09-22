import 'dart:developer';
import 'dart:ui';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  final _localNotifications = FlutterLocalNotificationsPlugin();

  Future<void> initializePlatformNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await _localNotifications.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);
  }

  static onSelectNotification(String? payload) {
    log("click", name: "notification_click");
    if (payload != null && payload.isNotEmpty) {}
  }

  void showLocalNotification({
    required int id,
    required String title,
    required String body,
    required String payload,
  }) {
    _localNotifications.show(
      id,
      title,
      body,
      NotificationDetails(
          android: AndroidNotificationDetails(
        'channel id',
        'channel budget',
        groupKey: 'com.example.expense_tracker',
        channelDescription: 'channel description',
        importance: Importance.max,
        priority: Priority.max,
        playSound: true,
        ticker: 'ticker',
        // largeIcon: const DrawableResourceAndroidBitmap('justwater'),
        // styleInformation: MessagingStyleInformation(Person(name: "fsdfs"),
        //     conversationTitle: "fsdfdsf"),
        // // BigPictureStyleInformation(
        // //   FilePathAndroidBitmap(bigPicture),
        // //   hideExpandedLargeIcon: false,
        // // ),
        color: const Color(0xff2196f3),
      )),
      payload: payload,
    );
  }
}
