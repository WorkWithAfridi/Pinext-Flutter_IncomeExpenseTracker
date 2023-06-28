import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:pinext/app/app_data/app_constants/constants.dart';
import 'package:pinext/app/app_data/app_constants/fonts.dart';
import 'package:pinext/app/app_data/theme_data/colors.dart';
import 'package:pinext/app/models/notification_message_model.dart';
import 'package:pinext/app/services/firebase_services.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'alert_state.dart';

class AlertCubit extends Cubit<AlertState> {
  AlertCubit()
      : super(
          const AlertState(),
        );

  Future<void> getAlertMessage({
    required BuildContext context,
  }) async {
    final DocumentSnapshot alertSnapshot = await FirebaseServices().firebaseFirestore.collection('app_data').doc('alert_message').get();
    final notificationMessageModel = NotificationMessageModel.fromMap(alertSnapshot.data() as Map<String, dynamic>);
    if (notificationMessageModel.showAlert) {
      notificationMessageModel.alertMessage = notificationMessageModel.alertMessage.replaceAll('*newline*', '\n');
      await Future.delayed(const Duration(seconds: 2)).then((value) async {
        final storageBox = await SharedPreferences.getInstance();
        if (storageBox.getBool('${notificationMessageModel.id}MarkedAsRead') ?? false) {
          return;
        }
        await showAlertMessage(context, notificationMessageModel);
      });
    }
  }

  Future<void> showAlertMessage(
    BuildContext context,
    NotificationMessageModel notificationMessageModel,
  ) async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            notificationMessageModel.alertTitle,
            style: boldTextStyle.copyWith(
              fontSize: 20,
            ),
          ),
          content: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: ListBody(
              children: [
                Text(
                  notificationMessageModel.alertMessage,
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
                  color: customBlackColor.withOpacity(
                    .8,
                  ),
                ),
              ),
              onPressed: () async {
                Navigator.of(context).pop();

                final storageBox = await SharedPreferences.getInstance();
                await storageBox.setBool('${notificationMessageModel.id}MarkedAsRead', true);
              },
            ),
          ],
          actionsPadding: dialogButtonPadding,
        );
      },
    );
  }
}
