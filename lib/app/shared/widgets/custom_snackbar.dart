import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pinext/app/app_data/theme_data/colors.dart';

enum SnackbarType {
  error,
  info,
  success,
}

void showToast({
  required String title,
  required String message,
  required SnackbarType snackbarType,
  required BuildContext context,
}) {
  Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_LONG,
    gravity: ToastGravity.TOP,
    backgroundColor: darkPurpleColor,
    textColor: whiteColor,
    fontSize: 14,
  );

  // const snackbarAnimationType = AnimationType.fromTop;
  // const snackbarToastDuration = Duration(
  //   seconds: 3,
  // );
  // const snackbarAnimationDuration = Duration(
  //   milliseconds: 150,
  // );
  // const isSnackbarDismissible = false;
  // final titleText = Text(
  //   title,
  //   style: boldTextStyle,
  // );
  // final messageText = Text(
  //   message,
  //   style: regularTextStyle,
  // );
  // final width = getWidth(context) - 50;

  // late AwesomeSnackbarContent snackbarContent;
  // if (snackbarType == SnackbarType.success) {
  //   ElegantNotification.success(
  //     title: titleText,
  //     description: messageText,
  //     width: width,
  //     animationDuration: snackbarAnimationDuration,
  //   ).show(context);
  // } else if (snackbarType == SnackbarType.info) {
  //   ElegantNotification.info(
  //     title: titleText,
  //     description: messageText,
  //     width: width,
  //     animationDuration: snackbarAnimationDuration,
  //   ).show(context);
  // } else if (snackbarType == SnackbarType.error) {
  //   ElegantNotification.error(
  //     title: titleText,
  //     description: messageText,
  //     width: width,
  //     animationDuration: snackbarAnimationDuration,
  //   ).show(context);
  // }
}
