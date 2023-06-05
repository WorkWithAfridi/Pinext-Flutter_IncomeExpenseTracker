import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pinext/app/API/firebase_directories.dart';
import 'package:pinext/app/models/pinext_user_model.dart';
import 'package:pinext/app/services/date_time_services.dart';
import 'package:pinext/app/services/firebase_services.dart';

class UserHandler {
  factory UserHandler() => _userServices;
  UserHandler._internal();
  static final UserHandler _userServices = UserHandler._internal();

  late PinextUserModel currentUser;
  Future<PinextUserModel> getCurrentUser() async {
    DocumentSnapshot userSnapshot = await FirebaseServices().firebaseFirestore.collection('pinext_users').doc(FirebaseServices().getUserId()).get();
    currentUser = PinextUserModel.fromMap(userSnapshot.data() as Map<String, dynamic>);

    await updateUserDataMonthlyStats(currentUser);
    return currentUser;
  }

  Future updateUserDataMonthlyStats(PinextUserModel user) async {
    await FirebaseServices()
        .firebaseFirestore
        .collection('pinext_users')
        .doc(FirebaseServices().getUserId())
        .collection('pinext_user_monthly_stats')
        .doc(user.currentYear)
        .collection('savings')
        .doc(user.currentMonth)
        .set({
      'amount': user.monthlySavings,
    });
    await FirebaseServices()
        .firebaseFirestore
        .collection('pinext_users')
        .doc(FirebaseServices().getUserId())
        .collection('pinext_user_monthly_stats')
        .doc(user.currentYear)
        .collection('expenses')
        .doc(user.currentMonth)
        .set({
      'amount': user.monthlyExpenses,
    });
  }

  Future updateUserDateTime(PinextUserModel user) async {
    if (user.currentYear != currentYear) {
      await FirebaseServices().firebaseFirestore.collection('pinext_users').doc(FirebaseServices().getUserId()).update({
        'currentDate': currentDate,
        'currentMonth': currentMonth,
        'currentWeekOfTheYear': currentWeekOfTheYear,
        'currentYear': currentYear,
      });
    } else if (user.currentMonth != currentMonth) {
      await FirebaseServices().firebaseFirestore.collection('pinext_users').doc(FirebaseServices().getUserId()).update({
        'currentDate': currentDate,
        'currentMonth': currentMonth,
        'currentWeekOfTheYear': currentWeekOfTheYear,
      });
    } else if (user.currentWeekOfTheYear != currentWeekOfTheYear) {
      await FirebaseServices().firebaseFirestore.collection('pinext_users').doc(FirebaseServices().getUserId()).update({
        'currentDate': currentDate,
        'currentWeekOfTheYear': currentWeekOfTheYear,
      });
    } else if (user.currentDate != currentDate) {
      await FirebaseServices().firebaseFirestore.collection('pinext_users').doc(FirebaseServices().getUserId()).update({
        'currentDate': currentDate,
      });
    }
    return;
  }

  Future resetUserStats(PinextUserModel user) async {
    if (user.currentYear != currentYear) {
      await FirebaseServices().firebaseFirestore.collection('pinext_users').doc(FirebaseServices().getUserId()).update({
        'monthlyExpenses': '0',
        'monthlyEarnings': '0',
        'dailyExpenses': '0',
        'weeklyExpenses': '0',
        'monthlySavings': '0',
      });
    } else if (user.currentMonth != currentMonth) {
      await FirebaseServices().firebaseFirestore.collection('pinext_users').doc(FirebaseServices().getUserId()).update({
        'monthlyExpenses': '0',
        'monthlyEarnings': '0',
        'dailyExpenses': '0',
        // 'weeklyExpenses': "0",
        'monthlySavings': '0',
      });
    } else if (user.currentWeekOfTheYear != currentWeekOfTheYear) {
      await FirebaseServices().firebaseFirestore.collection('pinext_users').doc(FirebaseServices().getUserId()).update({
        'dailyExpenses': '0',
        'weeklyExpenses': '0',
      });
    } else if (user.currentDate != currentDate) {
      await FirebaseServices().firebaseFirestore.collection('pinext_users').doc(FirebaseServices().getUserId()).update({
        'dailyExpenses': '0',
      });
    }
    return;
  }

  Future updateNetBalance(String amount) async {
    await FirebaseServices().firebaseFirestore.collection(USERS_DIRECTORY).doc(FirebaseServices().getUserId()).update({
      'netBalance': amount,
    });
    return;
  }

  Future updateUserRegion(String regionCode) async {
    await FirebaseServices().firebaseFirestore.collection(USERS_DIRECTORY).doc(FirebaseServices().getUserId()).update({
      'regionCode': regionCode,
    });
    return;
  }

  Future deleteUserData() async {
    try {
      await FirebaseServices().firebaseFirestore.collection('pinext_users').doc(currentUser.userId).delete();
      final pinextUserModel = PinextUserModel(
        userId: currentUser.userId,
        emailAddress: currentUser.emailAddress,
        username: currentUser.username,
        netBalance: '0',
        monthlyBudget: '1',
        dailyExpenses: '0',
        monthlyExpenses: '0',
        weeklyExpenses: '0',
        monthlySavings: '0',
        monthlyEarnings: '0',
        accountCreatedOn: DateTime.now().toString(),
        currentDate: currentDate,
        currentMonth: currentMonth,
        currentWeekOfTheYear: currentWeekOfTheYear,
        currentYear: currentYear,
        regionCode: currentUser.regionCode,
      );
      await FirebaseServices().firebaseFirestore.collection('pinext_users').doc(currentUser.userId).set(pinextUserModel.toMap());
      return 'Success';
    } on FirebaseAuthException catch (e) {
      return e.message.toString();
    } catch (e) {
      return 'An error occurred while deleting your date. Please contact admin at afridi.khondakar@gmail.com.';
    }
  }

  Future<String> deleteUser() async {
    try {
      await FirebaseServices().firebaseFirestore.collection('pinext_users').doc(currentUser.userId).delete();
      await FirebaseServices().firebaseAuth.currentUser!.delete();
      return 'Success';
    } on FirebaseAuthException catch (e) {
      return e.message.toString();
    } catch (e) {
      return 'An error occurred while deleting your account. Please contact admin at afridi.khondakar@gmail.com.';
    }
  }
}
