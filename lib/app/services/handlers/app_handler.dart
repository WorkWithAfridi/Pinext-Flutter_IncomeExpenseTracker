import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

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
              ),
            );
          },
        );
      }
    });
  }
}
