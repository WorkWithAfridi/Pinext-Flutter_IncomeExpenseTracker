import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:elegant_notification/elegant_notification.dart';
import 'package:elegant_notification/resources/arrays.dart';
import 'package:flutter/material.dart';

import '../../app_data/app_constants/domentions.dart';
import '../../app_data/app_constants/fonts.dart';

enum SnackbarType {
  error,
  info,
  success,
}

GetCustomSnackbar({
  required String title,
  required String message,
  required SnackbarType snackbarType,
  required BuildContext context,
}) {
  const AnimationType snackbarAnimationType = AnimationType.fromTop;
  const Duration snackbarToastDuration = Duration(
    seconds: 3,
  );
  const Duration snackbarAnimationDuration = Duration(
    milliseconds: 150,
  );
  const isSnackbarDismissible = false;
  Text titleText = Text(
    title,
    style: boldTextStyle,
  );
  Text messageText = Text(
    message,
    style: regularTextStyle,
  );
  double width = getWidth(context) - 50;

  late AwesomeSnackbarContent snackbarContent;
  if (snackbarType == SnackbarType.success) {
    ElegantNotification.success(
      title: titleText,
      description: messageText,
      width: width,
      animationDuration: snackbarAnimationDuration,
      toastDuration: snackbarToastDuration,
      autoDismiss: true,
    ).show(context);
  } else if (snackbarType == SnackbarType.info) {
    ElegantNotification.info(
      title: titleText,
      description: messageText,
      width: width,
      animationDuration: snackbarAnimationDuration,
      toastDuration: snackbarToastDuration,
      autoDismiss: true,
    ).show(context);
  } else if (snackbarType == SnackbarType.error) {
    ElegantNotification.error(
      title: titleText,
      description: messageText,
      width: width,
      animationDuration: snackbarAnimationDuration,
      toastDuration: snackbarToastDuration,
      autoDismiss: true,
    ).show(context);
  }
}
