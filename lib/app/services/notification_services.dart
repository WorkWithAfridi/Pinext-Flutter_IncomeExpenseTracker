import 'package:elegant_notification/resources/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pinext/app/app_data/app_constants/constants.dart';
import 'package:pinext/app/app_data/app_constants/fonts.dart';
import 'package:pinext/app/app_data/theme_data/colors.dart';

class NotificationService {
  factory NotificationService() => _notificationService;
  NotificationService._internal();
  static final NotificationService _notificationService = NotificationService._internal();

  bool isNotificationPermissionGranted = false;

  Future<void> checkNotificationPermission({required BuildContext context}) async {
    final status = await Permission.notification.request();
    if (status == PermissionStatus.granted) {
      print('Notification permission granted');
      isNotificationPermissionGranted = true;
    } else if (status == PermissionStatus.denied) {
      print('Notification permission denied');
      await showPermissionNeededForRemindersPopUp(context: context);

      isNotificationPermissionGranted = false;
    } else if (status == PermissionStatus.permanentlyDenied) {
      print('Notification permission permanently denied');
      await showPermissionNeededForRemindersPopUp(context: context);
      isNotificationPermissionGranted = false;
    }
  }
}

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

Future showPermissionNeededForRemindersPopUp({
  required BuildContext context,
}) {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(
          'Boost Your Financial Control by eabling Push Notifications services for Pinext',
          style: boldTextStyle.copyWith(
            fontSize: 16,
          ),
        ),
        content: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: ListBody(
            children: [
              Text(
                """
Hey there!

At Pinext, we believe in empowering you to take control of your finances effortlessly. To help you stay on top of your income and expenses, we recommend enabling push notifications for our app. By enabling push notifications, you'll receive timely reminders at the end of each day to add your daily transactions, ensuring accurate tracking and keeping you up to date with your spending habits.

Best regards,
The Pinext Team""",
                style: regularTextStyle.copyWith(
                  color: customBlackColor.withOpacity(.75),
                ),
              ),
            ],
          ),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(defaultBorder),
        ),
        actions: <Widget>[
          TextButton(
            child: Text(
              'Dismiss',
              style: boldTextStyle.copyWith(
                color: errorColor.withOpacity(
                  .8,
                ),
              ),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: Text(
              'Get started',
              style: boldTextStyle.copyWith(
                color: customBlackColor.withOpacity(
                  .8,
                ),
              ),
            ),
            onPressed: () {
              Navigator.of(context).pop();
              openAppSettings();
            },
          ),
        ],
        actionsPadding: dialogButtonPadding,
      );
    },
  );
}

Future<void> requestPermission() async {
  const iosSettings = DarwinInitializationSettings();

  const initializationSettings = InitializationSettings(
    iOS: iosSettings,
  );

  await flutterLocalNotificationsPlugin.show(
    1101,
    'Hello',
    'Wordld',
    const NotificationDetails(),
  );

  // if (result == true) {
  //   print('Notification permission granted');
  // } else {
  //   print('Notification permission denied');
  // }
}

Future<void> showNotification() async {
  const androidPlatformChannelSpecifics = AndroidNotificationDetails(
    'channel_id',
    'channel_name',
    channelDescription: 'channel_description',
    importance: Importance.max,
    priority: Priority.high,
  );

  const iOSPlatformChannelSpecifics = DarwinNotificationDetails();

  const platformChannelSpecifics = NotificationDetails(
    android: androidPlatformChannelSpecifics,
    iOS: iOSPlatformChannelSpecifics,
  );

  await flutterLocalNotificationsPlugin.show(
    0,
    'Notification Title',
    'Notification Body',
    platformChannelSpecifics,
    payload: 'notification_payload',
  );
}
