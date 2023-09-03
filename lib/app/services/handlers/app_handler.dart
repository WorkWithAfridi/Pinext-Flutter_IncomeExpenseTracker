import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pinext/app/API/firebase_directories.dart';
import 'package:pinext/app/app_data/appVersion.dart';
import 'package:pinext/app/app_data/app_constants/constants.dart';
import 'package:pinext/app/app_data/app_constants/fonts.dart';
import 'package:pinext/app/app_data/theme_data/colors.dart';
import 'package:pinext/app/services/firebase_services.dart';
import 'package:pinext/app/shared/widgets/custom_snackbar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class AppHandler {
  factory AppHandler() => _appHandler;
  AppHandler._internal();
  static final AppHandler _appHandler = AppHandler._internal();

  Future<bool> checkIfFirstBoot() async {
    final storageBox = await SharedPreferences.getInstance();
    var isFirstBoot = storageBox.getBool('isFirstBoot');
    if (isFirstBoot == null) {
      isFirstBoot = false;
      await storageBox.setBool('isFirstBoot', isFirstBoot);
      return !isFirstBoot;
    } else {
      return isFirstBoot;
    }
  }

  Future<void> checkForUpdate(BuildContext context) async {
    // showToast(
    //   title: "App Version: $appVersion",
    //   message: "Checking for updates!",
    //   snackbarType: SnackbarType.info,
    //   context: context,
    // );
    await Future.delayed(const Duration(milliseconds: 500)).then((value) async {
      final DocumentSnapshot appDataSnapShot = await FirebaseServices().firebaseFirestore.collection(APPDATA_DIRECTORY).doc(APPVERSION_DIRECTORY).get();
      final currentAvailableAppVersion = (appDataSnapShot.data()! as Map<String, dynamic>)['appVersion'] as String;

      if (currentAvailableAppVersion != appVersion) {
        await showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text(
                'UPDATE',
                style: boldTextStyle.copyWith(
                  fontSize: 20,
                ),
              ),
              content: SingleChildScrollView(
                child: ListBody(
                  children: [
                    Text(
                      'A new version of the app is available. Would you like to download it now?',
                      style: regularTextStyle,
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
                      color: customBlackColor.withOpacity(
                        .8,
                      ),
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: const Text('Download'),
                  onPressed: () async {
                    // String url = "https://drive.google.com/drive/folders/1Z-fPUf9SbRhjLuHZsv87LCJxbRI3bJQT?usp=sharing";
                    const url = 'https://drive.google.com/drive/folders/1Z-fPUf9SbRhjLuHZsv87LCJxbRI3bJQT?usp=sharing';
                    // bool isiOS = Platform.isIOS;
                    if (await canLaunchUrl(Uri.parse(url))) {
                      await launchUrl(
                        Uri.parse(url),
                      );
                      Navigator.of(context).pop();
                    } else {
                      showToast(
                        title: 'Snap',
                        message: 'An error occurred! Please try again later',
                        snackbarType: SnackbarType.error,
                        context: context,
                      );
                      Navigator.of(context).pop();
                    }
                  },
                ),
              ],
              actionsPadding: dialogButtonPadding,
            );
          },
        );
      } else {
        showToast(
          title: 'App Version v$appVersion',
          message: "You're currently on the latest build of the app! :D",
          snackbarType: SnackbarType.info,
          context: context,
        );
      }
    });
  }

  void requestNewFuture(BuildContext context) {
    _sendEmail(
      context,
      'PINEXT: REQUESTING NEW FUTURE!',
      "Enter a detailed description of the future you're requesting!",
    );
  }

  void writeReview(BuildContext context) {
    _sendEmail(
      context,
      'PINEXT: REVIEW',
      'Enter your review here! :D ',
    );
  }

  void sendBugReport(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'Bug Report',
            style: boldTextStyle.copyWith(
              fontSize: 20,
            ),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                Text(
                  "Hi. I assume you found a bug in the source code! If yes, then please do let me know through the 'send mail' button below. If not dismiss it away! :)",
                  style: regularTextStyle,
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
                  color: customBlackColor.withOpacity(
                    .8,
                  ),
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Send mail'),
              onPressed: () {
                _sendEmail(context, 'PINEXT - BUG REPORT', 'Please enter your description and scenario here!');
                Navigator.of(context).pop();
              },
            ),
          ],
          actionsPadding: dialogButtonPadding,
        );
      },
    );
  }

  Future<void> _sendEmail(BuildContext context, String subject, String body) async {
    final email =
        Uri(scheme: 'mailto', path: 'khondakarafridi35@gmail.com', query: 'subject=${Uri.encodeComponent(subject)}&body=${Uri.encodeComponent(body)}');
    if (await canLaunchUrl(email)) {
      await launchUrl(email);
    } else {
      showToast(
        title: 'Snap',
        message: 'An error occurred! Please try again later',
        snackbarType: SnackbarType.error,
        context: context,
      );
      Navigator.of(context).pop();
    }
  }

  Future<void> openPortfolio(BuildContext context) async {
    const url = 'https://sites.google.com/view/workwithafridi';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(
        Uri.parse(url),
      );
      Navigator.of(context).pop();
    } else {
      showToast(
        title: 'Snap',
        message: 'An error occurred! Please try again later',
        snackbarType: SnackbarType.error,
        context: context,
      );
      Navigator.of(context).pop();
    }
  }
}
