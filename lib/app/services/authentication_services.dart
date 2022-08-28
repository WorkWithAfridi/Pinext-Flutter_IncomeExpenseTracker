import 'package:firebase_auth/firebase_auth.dart';
import 'package:pinext/app/handlers/card_handler.dart';
import 'package:pinext/app/handlers/user_handler.dart';
import 'package:pinext/app/models/pinext_card_model.dart';
import 'package:pinext/app/models/pinext_user_model.dart';
import 'package:pinext/app/services/firebase_services.dart';

class AuthenticationServices {
  AuthenticationServices._internal();
  static final AuthenticationServices _authenticationServices =
      AuthenticationServices._internal();
  factory AuthenticationServices() => _authenticationServices;

  Future signupUserUsingEmailAndPassword({
    required String emailAddress,
    required String password,
    required String username,
    required List<PinextCardModel> pinextCards,
    required String netBalance,
    required String monthlyBudget,
    required String budgetSpentSoFar,
  }) async {
    String response;
    try {
      UserCredential userCredential =
          await FirebaseServices().firebaseAuth.createUserWithEmailAndPassword(
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
      );

      //storing userData
      await FirebaseServices()
          .firebaseFirestore
          .collection('pinext_users')
          .doc(userCredential.user!.uid)
          .set(pinextUserModel.toMap());

      for (PinextCardModel pinextCard in pinextCards) {
        //storing userCards
        await CardHandler().addCard(pinextCard);
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
    bool status = FirebaseServices().firebaseAuth.currentUser != null;
    if (status) {
      await UserHandler().getCurrentUser();
    }
    return status;
  }

  Future signInUser({
    required String emailAddress,
    required String password,
  }) async {
    String response = "Error";
    try {
      UserCredential userCredential =
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
}
