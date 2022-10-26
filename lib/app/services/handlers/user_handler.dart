import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pinext/app/API/firebase_directories.dart';
import 'package:pinext/app/models/pinext_user_model.dart';
import 'package:pinext/app/services/firebase_services.dart';

import '../date_time_services.dart';

class UserHandler {
  UserHandler._internal();
  static final UserHandler _userServices = UserHandler._internal();
  factory UserHandler() => _userServices;

  late PinextUserModel currentUser;
  Future<PinextUserModel> getCurrentUser() async {
    DocumentSnapshot userSnapshot =
        await FirebaseServices().firebaseFirestore.collection("pinext_users").doc(FirebaseServices().getUserId()).get();
    currentUser = PinextUserModel.fromMap(userSnapshot.data() as Map<String, dynamic>);
    log(currentUser.toString());
    updateUserDataMonthlyStats(currentUser);
    return currentUser;
  }

  Future updateUserDataMonthlyStats(PinextUserModel user) async {
    await FirebaseServices()
        .firebaseFirestore
        .collection("pinext_users")
        .doc(FirebaseServices().getUserId())
        .collection("pinext_user_monthly_stats")
        .doc(user.currentYear)
        .collection("savings")
        .doc(user.currentMonth)
        .set({
      "amount": user.monthlySavings,
    });
    await FirebaseServices()
        .firebaseFirestore
        .collection("pinext_users")
        .doc(FirebaseServices().getUserId())
        .collection("pinext_user_monthly_stats")
        .doc(user.currentYear)
        .collection("expenses")
        .doc(user.currentMonth)
        .set({
      "amount": user.monthlyExpenses,
    });
  }

  Future updateUserDateTime(PinextUserModel user) async {
    if (user.currentYear != currentYear) {
      await FirebaseServices().firebaseFirestore.collection("pinext_users").doc(FirebaseServices().getUserId()).update({
        'currentDate': currentDate,
        'currentMonth': currentMonth,
        'currentWeekOfTheYear': currentWeekOfTheYear,
        'currentYear': currentYear,
      });
    } else if (user.currentMonth != currentMonth) {
      await FirebaseServices().firebaseFirestore.collection("pinext_users").doc(FirebaseServices().getUserId()).update({
        'currentDate': currentDate,
        'currentMonth': currentMonth,
        'currentWeekOfTheYear': currentWeekOfTheYear,
      });
    } else if (user.currentWeekOfTheYear != currentWeekOfTheYear) {
      await FirebaseServices().firebaseFirestore.collection("pinext_users").doc(FirebaseServices().getUserId()).update({
        'currentDate': currentDate,
        'currentWeekOfTheYear': currentWeekOfTheYear,
      });
    } else if (user.currentDate != currentDate) {
      await FirebaseServices().firebaseFirestore.collection("pinext_users").doc(FirebaseServices().getUserId()).update({
        'currentDate': currentDate,
      });
    }
    return;
  }

  Future resetUserStats(PinextUserModel user) async {
    if (user.currentYear != currentYear) {
      await FirebaseServices().firebaseFirestore.collection("pinext_users").doc(FirebaseServices().getUserId()).update({
        'monthlyExpenses': "0",
        'dailyExpenses': "0",
        'weeklyExpenses': "0",
        'monthlySavings': "0",
      });
    } else if (user.currentMonth != currentMonth) {
      await FirebaseServices().firebaseFirestore.collection("pinext_users").doc(FirebaseServices().getUserId()).update({
        'monthlyExpenses': "0",
        'dailyExpenses': "0",
        // 'weeklyExpenses': "0",
        'monthlySavings': "0",
      });
    } else if (user.currentWeekOfTheYear != currentWeekOfTheYear) {
      await FirebaseServices().firebaseFirestore.collection("pinext_users").doc(FirebaseServices().getUserId()).update({
        'dailyExpenses': "0",
        'weeklyExpenses': "0",
      });
    } else if (user.currentDate != currentDate) {
      await FirebaseServices().firebaseFirestore.collection("pinext_users").doc(FirebaseServices().getUserId()).update({
        'dailyExpenses': "0",
      });
    }
    return;
  }

  Future updateNetBalance(String amount) async {
    await FirebaseServices().firebaseFirestore.collection(USERS_DIRECTORY).doc(FirebaseServices().getUserId()).update({
      "netBalance": amount,
    });
    return;
  }
}
