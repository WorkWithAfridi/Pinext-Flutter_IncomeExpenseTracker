import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:elegant_notification/elegant_notification.dart';
import 'package:elegant_notification/resources/arrays.dart';
import 'package:flutter/material.dart';
import 'package:pinext/app/app_data/app_constants/domentions.dart';
import 'package:pinext/app/app_data/app_constants/fonts.dart';

enum SnackbarType {
  error,
  info,
  success,
}

void GetCustomSnackbar({
  required String title,
  required String message,
  required SnackbarType snackbarType,
  required BuildContext context,
}) {
  const snackbarAnimationType = AnimationType.fromTop;
  const snackbarToastDuration = Duration(
    seconds: 3,
  );
  const snackbarAnimationDuration = Duration(
    milliseconds: 150,
  );
  const isSnackbarDismissible = false;
  final titleText = Text(
    title,
    style: boldTextStyle,
  );
  final messageText = Text(
    message,
    style: regularTextStyle,
  );
  final width = getWidth(context) - 50;

  late AwesomeSnackbarContent snackbarContent;
  if (snackbarType == SnackbarType.success) {
    ElegantNotification.success(
      title: titleText,
      description: messageText,
      width: width,
      animationDuration: snackbarAnimationDuration,
    ).show(context);
  } else if (snackbarType == SnackbarType.info) {
    ElegantNotification.info(
      title: titleText,
      description: messageText,
      width: width,
      animationDuration: snackbarAnimationDuration,
    ).show(context);
  } else if (snackbarType == SnackbarType.error) {
    ElegantNotification.error(
      title: titleText,
      description: messageText,
      width: width,
      animationDuration: snackbarAnimationDuration,
    ).show(context);
  }
}
