import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:pinext/app/models/pinext_card_model.dart';
import 'package:pinext/app/models/pinext_goal_model.dart';
import 'package:pinext/app/models/pinext_user_model.dart';
import 'package:pinext/app/services/date_time_services.dart';
import 'package:pinext/app/services/firebase_services.dart';
import 'package:pinext/app/services/handlers/card_handler.dart';
import 'package:pinext/app/services/handlers/goal_handler.dart';
import 'package:pinext/app/services/handlers/user_handler.dart';

class AuthenticationServices {
  factory AuthenticationServices() => _authenticationServices;
  AuthenticationServices._internal();
  static final AuthenticationServices _authenticationServices = AuthenticationServices._internal();

  Future<String> googleSignin() async {
    late String response;
    try {
      final googleSignin = GoogleSignIn();
      final googleUser = await googleSignin.signIn();
      if (googleUser != null) {
        final googleAuth = await googleUser.authentication;
        if (googleAuth.accessToken != null
            //  && googleAuth.idToken != null
            ) {
          final credential = GoogleAuthProvider.credential(
            accessToken: googleAuth.accessToken,
            idToken: googleAuth.idToken,
          );
          //Signin user
          final userCredential = await FirebaseServices().firebaseAuth.signInWithCredential(credential);

          //Setup user data
          if (userCredential.additionalUserInfo!.isNewUser) {
            //Creating new user data and storing it in firebase
            final userId = userCredential.user!.uid;

            final pinextUserModel = PinextUserModel(
              userId: userId,
              emailAddress: userCredential.user!.email ?? '$userId@pinextmail.com',
              username: userCredential.user!.displayName ?? '$userId pinextuser',
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
            );

            //storing userData
            await FirebaseServices().firebaseFirestore.collection('pinext_users').doc(userCredential.user!.uid).set(pinextUserModel.toMap());
          }
          await UserHandler().getCurrentUser();
          response = 'Success';
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
    return response;
  }

  Future<String> signupUserUsingEmailAndPassword({
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
      final userCredential = await FirebaseServices().firebaseAuth.createUserWithEmailAndPassword(
            email: emailAddress,
            password: password,
          );

      final userId = userCredential.user!.uid;

      final pinextUserModel = PinextUserModel(
        userId: userId,
        emailAddress: emailAddress,
        username: username,
        netBalance: netBalance,
        monthlyBudget: monthlyBudget,
        dailyExpenses: '0',
        monthlyExpenses: budgetSpentSoFar,
        weeklyExpenses: '0',
        monthlyEarnings: '0',
        monthlySavings: '0',
        accountCreatedOn: DateTime.now().toString(),
        currentDate: currentDate,
        currentMonth: currentMonth,
        currentWeekOfTheYear: currentWeekOfTheYear,
        currentYear: currentYear,
      );

      //storing userData
      await FirebaseServices().firebaseFirestore.collection('pinext_users').doc(userCredential.user!.uid).set(pinextUserModel.toMap());

      for (final pinextCard in pinextCards) {
        //storing userCards
        await CardHandler().addCard(
          pinextCardModel: pinextCard,
          duringSignIn: true,
        );
      }
      for (final goal in pinextGoals) {
        await GoalHandler().addGoal(
          pinextGoalModel: goal,
        );
      }
      await UserHandler().getCurrentUser();
      response = 'Success';
    } on FirebaseException catch (err) {
      response = err.message.toString();
    } catch (err) {
      response = err.toString();
    }
    return response;
  }

  Future<bool> isUserSignedIn() async {
    if (FirebaseServices().firebaseAuth.currentUser != null) {
      DocumentSnapshot userSnapshot = await FirebaseServices().firebaseFirestore.collection('pinext_users').doc(FirebaseServices().getUserId()).get();
      if (userSnapshot.data() != null) {
        return true;
      }
      return false;
    }
    return false;
  }

  Future<String> signInUser({
    required String emailAddress,
    required String password,
  }) async {
    var response = 'Error';
    try {
      await FirebaseServices().firebaseAuth.signInWithEmailAndPassword(
            email: emailAddress,
            password: password,
          );
      await UserHandler().getCurrentUser();
      response = 'Success';
    } on FirebaseException catch (err) {
      response = err.message.toString();
    } catch (err) {
      response = 'Error';
    }
    return response;
  }

  Future<bool> signOutUser() async {
    try {
      await FirebaseServices().firebaseAuth.signOut();
    } catch (err) {
      return false;
    }
    return true;
  }

  Future<String> resetPassword({required String email}) async {
    var response = 'Error';
    try {
      await FirebaseServices().firebaseAuth.sendPasswordResetEmail(
            email: email,
          );
      response = 'Success';
    } on FirebaseException catch (err) {
      response = err.message.toString();
    } catch (err) {
      response = 'Error';
    }
    return response;
  }
}
