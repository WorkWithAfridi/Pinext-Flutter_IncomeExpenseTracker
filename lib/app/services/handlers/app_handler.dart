import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pinext/app/shared/widgets/custom_snackbar.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../API/firebase_directories.dart';
import '../../app_data/appVersion.dart';
import '../../app_data/app_constants/constants.dart';
import '../../app_data/app_constants/fonts.dart';
import '../../app_data/theme_data/colors.dart';
import '../firebase_services.dart';

class AppHandler {
  AppHandler._internal();
  static final AppHandler _appHandler = AppHandler._internal();
  factory AppHandler() => _appHandler;

  final storageBox = GetStorage();
  checkIfFirstBoot() async {
    var isFirstBoot = storageBox.read("isFirstBoot");
    if (isFirstBoot == null) {
      isFirstBoot = false;
      storageBox.write("isFirstBoot", isFirstBoot);
      return !isFirstBoot;
    } else {
      return isFirstBoot;
    }
  }

  checkForUpdate(BuildContext context) async {
    Future.delayed(const Duration(seconds: 5)).then((value) async {
      DocumentSnapshot appDataSnapShot = await FirebaseServices()
          .firebaseFirestore
          .collection(APPDATA_DIRECTORY)
          .doc(APPVERSION_DIRECTORY)
          .get();
      String currentAvailableAppVersion =
          (appDataSnapShot.data() as Map<String, dynamic>)["appVersion"];
      // log(currentAvailableAppVersion);
      if (currentAvailableAppVersion != appVersion) {
        showDialog(
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
                      "A new version of the app is available. Would you like to download it now?",
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
                  child: const Text('Download'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
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
              ],
              actionsPadding: const EdgeInsets.symmetric(
                horizontal: defaultPadding,
                vertical: 4,
              ),
            );
          },
        );
      }
    });
  }

  sendBugReport(BuildContext context) {
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
                _sendEmail(context);
              },
            ),
          ],
          actionsPadding: const EdgeInsets.symmetric(
            horizontal: defaultPadding,
            vertical: 4,
          ),
        );
      },
    );
  }

  _sendEmail(BuildContext context) async {
    final Uri email = Uri(
        scheme: "mailto",
        path: "khondakarafridi35@gmail.com",
        query:
            "subject=${Uri.encodeComponent("PINEXT - BUG REPORT")}&body=${Uri.encodeComponent("Please enter your description and scenario here!")}");
    // final url =
    //     "mailto:<khondakarafridi35@gmail.com>?subject=${Uri.encodeFull("PINEXT - BUG REPORT")}&body=<${Uri.encodeFull("Please enter your description and scenario here!")}>";
    if (await canLaunchUrl(email)) {
      await launchUrl(email);
      Navigator.of(context).pop();
    } else {
      GetCustomSnackbar(
        title: "Snap",
        message: "An error occurred! Please try again later",
        snackbarType: SnackbarType.error,
        context: context,
      );
      Navigator.of(context).pop();
    }
  }

  openPortfolio(BuildContext context) async {
    String url = "https://sites.google.com/view/workwithafridi";
    // bool isiOS = Platform.isIOS;
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(
        Uri.parse(url),
      );
      Navigator.of(context).pop();
    } else {
      GetCustomSnackbar(
        title: "Snap",
        message: "An error occurred! Please try again later",
        snackbarType: SnackbarType.error,
        context: context,
      );
      Navigator.of(context).pop();
    }
  }

  showHelpDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'Hello!!',
            style: boldTextStyle.copyWith(
              fontSize: 20,
            ),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                Text(
                  "Welcome aboard on Pinext.\nA personal Income and Expense tracker. Where you can track your daily expenses or income and store them in a cloud based archive. You'll be able to view or update your transactions at any time and even generate reports based on your transactions directly through the app! :)",
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
          ],
          actionsPadding: const EdgeInsets.symmetric(
            horizontal: defaultPadding,
            vertical: 4,
          ),
        );
      },
    );
  }
}
