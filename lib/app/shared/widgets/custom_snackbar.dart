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

const AnimationType snackbarAnimationType = AnimationType.fromTop;
const Duration snackbarToastDuration = Duration(
  seconds: 5,
);
const Duration snackbarAnimationDuration = Duration(
  milliseconds: 200,
);
const isSnackbarDismissible = true;

GetCustomSnackbar({
  required String title,
  required String message,
  required SnackbarType snackbarType,
  required BuildContext context,
}) {
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
      dismissible: isSnackbarDismissible,
    ).show(context);
    // snackbarContent = AwesomeSnackbarContent(
    //   title: title,
    //   message: message,
    //   contentType: ContentType.success,
    // );
  } else if (snackbarType == SnackbarType.info) {
    ElegantNotification.info(
      title: titleText,
      description: messageText,
      width: width,
      animationDuration: snackbarAnimationDuration,
      toastDuration: snackbarToastDuration,
      dismissible: isSnackbarDismissible,
    ).show(context);

    // snackbarContent = AwesomeSnackbarContent(
    //   title: title,
    //   message: message,
    //   contentType: ContentType.help,
    // );
  } else if (snackbarType == SnackbarType.error) {
    ElegantNotification.error(
      title: titleText,
      description: messageText,
      width: width,
      animationDuration: snackbarAnimationDuration,
      toastDuration: snackbarToastDuration,
      dismissible: isSnackbarDismissible,
    ).show(context);

    // snackbarContent = AwesomeSnackbarContent(
    //   title: title,
    //   message: message,
    //   contentType: ContentType.failure,
    // );
  }
  // var snackbar = SnackBar(
  //   elevation: 0,
  //   behavior: SnackBarBehavior.floating,
  //   backgroundColor: Colors.transparent,
  //   content: snackbarContent,
  // );

  // ScaffoldMessenger.of(context).showSnackBar(snackbar);
}
