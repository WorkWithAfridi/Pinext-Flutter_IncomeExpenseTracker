import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:pinext/app/models/pinext_card_model.dart';
import 'package:pinext/app/models/pinext_user_model.dart';
import 'package:pinext/app/services/date_time_services.dart';
import 'package:pinext/app/services/firebase_services.dart';
import 'package:pinext/app/services/handlers/card_handler.dart';
import 'package:pinext/app/services/handlers/goal_handler.dart';
import 'package:pinext/app/services/handlers/user_handler.dart';

import '../models/pinext_goal_model.dart';

class AuthenticationServices {
  AuthenticationServices._internal();
  static final AuthenticationServices _authenticationServices = AuthenticationServices._internal();
  factory AuthenticationServices() => _authenticationServices;

  Future googleSignin() async {
    late String response;
    try {
      final GoogleSignIn googleSignin = GoogleSignIn();
      final GoogleSignInAccount? googleUser = await googleSignin.signIn();
      if (googleUser != null) {
        final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
        if (googleAuth.accessToken != null
            //  && googleAuth.idToken != null
            ) {
          final credential = GoogleAuthProvider.credential(
            accessToken: googleAuth.accessToken,
            idToken: googleAuth.idToken,
          );
          //Signin user
          UserCredential userCredential = await FirebaseServices().firebaseAuth.signInWithCredential(credential);

          //Setup user data
          if (userCredential.additionalUserInfo!.isNewUser) {
            //Creating new user data and storing it in firebase
            var userId = userCredential.user!.uid;

            PinextUserModel pinextUserModel = PinextUserModel(
              userId: userId,
              emailAddress: userCredential.user!.email ?? "$userId@pinextmail.com",
              username: userCredential.user!.displayName ?? "$userId pinextuser",
              netBalance: "0",
              monthlyBudget: "1",
              dailyExpenses: '0',
              monthlyExpenses: "0",
              weeklyExpenses: '0',
              monthlySavings: '0',
              accountCreatedOn: DateTime.now().toString(),
              currentDate: currentDate,
              currentMonth: currentMonth,
              currentWeekOfTheYear: currentWeekOfTheYear,
              currentYear: currentYear,
            );

            //storing userData
            await FirebaseServices()
                .firebaseFirestore
                .collection('pinext_users')
                .doc(userCredential.user!.uid)
                .set(pinextUserModel.toMap());

            for (PinextCardModel pinextCard in []) {
              //storing userCards
              await CardHandler().addCard(
                pinextCardModel: pinextCard,
                duringSignIn: true,
              );
            }
            for (PinextGoalModel goal in []) {
              await GoalHandler().addGoal(
                pinextGoalModel: goal,
              );
            }
          }
          await UserHandler().getCurrentUser();
          response = "Success";
          log(response);
          // }
        }
      } else {
        response = "Error, couldn't sign in user!";
      }
    } on FirebaseException catch (err) {
      response = err.message.toString();
    } catch (err) {
      response = err.toString();
    }
    log(response.toString());
    return response;
  }

  Future signupUserUsingEmailAndPassword({
    required String emailAddress,
    required String password,
    required String username,
    required List<PinextCardModel> pinextCards,
    required List<PinextGoalModel> pinextGoals,
    required String netBalance,
    required String monthlyBudget,
    required String budgetSpentSoFar,
  }) async {
    String response;
    try {
      UserCredential userCredential = await FirebaseServices().firebaseAuth.createUserWithEmailAndPassword(
            email: emailAddress,
            password: password,
          );

      var userId = userCredential.user!.uid;

      PinextUserModel pinextUserModel = PinextUserModel(
        userId: userId,
        emailAddress: emailAddress,
        username: username,
        netBalance: netBalance,
        monthlyBudget: monthlyBudget,
        dailyExpenses: '0',
        monthlyExpenses: budgetSpentSoFar,
        weeklyExpenses: '0',
        monthlySavings: '0',
        accountCreatedOn: DateTime.now().toString(),
        currentDate: currentDate,
        currentMonth: currentMonth,
        currentWeekOfTheYear: currentWeekOfTheYear,
        currentYear: currentYear,
      );

      //storing userData
      await FirebaseServices()
          .firebaseFirestore
          .collection('pinext_users')
          .doc(userCredential.user!.uid)
          .set(pinextUserModel.toMap());

      for (PinextCardModel pinextCard in pinextCards) {
        //storing userCards
        await CardHandler().addCard(
          pinextCardModel: pinextCard,
          duringSignIn: true,
        );
      }
      for (PinextGoalModel goal in pinextGoals) {
        await GoalHandler().addGoal(
          pinextGoalModel: goal,
        );
      }
      await UserHandler().getCurrentUser();
      response = "Success";
    } on FirebaseException catch (err) {
      response = err.message.toString();
    } catch (err) {
      response = err.toString();
    }
    return response;
  }

  Future<bool> isUserSignedIn() async {
    if (FirebaseServices().firebaseAuth.currentUser != null) {
      DocumentSnapshot userSnapshot = await FirebaseServices()
          .firebaseFirestore
          .collection("pinext_users")
          .doc(FirebaseServices().getUserId())
          .get();
      if (userSnapshot.data() != null) {
        return true;
      }
      return false;
    }
    return false;
  }

  Future signInUser({
    required String emailAddress,
    required String password,
  }) async {
    String response = "Error";
    try {
      await FirebaseServices().firebaseAuth.signInWithEmailAndPassword(
            email: emailAddress,
            password: password,
          );
      await UserHandler().getCurrentUser();
      response = "Success";
    } on FirebaseException catch (err) {
      response = err.message.toString();
    } catch (err) {
      response = "Error";
    }
    return response;
  }

  signOutUser() async {
    try {
      await FirebaseServices().firebaseAuth.signOut();
    } catch (err) {
      return false;
    }
    return true;
  }

  resetPassword({required String email}) async {
    String response = "Error";
    try {
      await FirebaseServices().firebaseAuth.sendPasswordResetEmail(email: "khondakarafridi007@gmail.com");
      response = "Success";
    } on FirebaseException catch (err) {
      response = err.message.toString();
    } catch (err) {
      response = "Error";
    }
    return response;
  }
}
