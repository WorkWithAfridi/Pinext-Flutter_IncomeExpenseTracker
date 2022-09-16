import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pinext/app/models/pinext_card_model.dart';
import 'package:pinext/app/models/pinext_transaction_model.dart';
import 'package:pinext/app/models/pinext_user_model.dart';
import 'package:pinext/app/services/firebase_services.dart';
import 'package:pinext/app/services/handlers/card_handler.dart';
import 'package:pinext/app/services/handlers/user_handler.dart';
import 'package:uuid/uuid.dart';

import '../date_time_services.dart';

class TransactionHandler {
  TransactionHandler._internal();
  static final TransactionHandler _transactionHandler =
      TransactionHandler._internal();
  factory TransactionHandler() => _transactionHandler;

  Future addTransaction({
    required String amount,
    required String description,
    required String transactionType,
    required String cardId,
  }) async {
    String response = "Error";
    try {
      String transactionId = const Uuid().v4();
      PinextTransactionModel pinextTransactionModel = PinextTransactionModel(
        transactionType: transactionType,
        amount: amount,
        details: description,
        cardId: cardId,
        transactionDate: DateTime.now().toString(),
        transactionId: transactionId,
      );
      //Adding transaction
      FirebaseServices()
          .firebaseFirestore
          .collection("pinext_users")
          .doc(FirebaseServices().getUserId())
          .collection("pinext_transactions")
          .doc(currentYear)
          .collection(currentMonth)
          .doc(
            transactionId,
          )
          .set(
            pinextTransactionModel.toMap(),
          );

      // Adjust card balance and updating last transaction time
      PinextCardModel pinextCardModel = await CardHandler().getCard(cardId);
      double adjustedAmount = (transactionType == "Income")
          ? pinextCardModel.balance + double.parse(amount)
          : pinextCardModel.balance - double.parse(amount);
      await FirebaseServices()
          .firebaseFirestore
          .collection("pinext_users")
          .doc(FirebaseServices().getUserId())
          .collection("pinext_cards")
          .doc(pinextTransactionModel.cardId)
          .update({
        "balance": adjustedAmount,
        "lastTransactionData": DateTime.now().toString(),
      });

      // //Adjusting global balances
      PinextUserModel pinextUserModel = UserHandler().currentUser;
      if (transactionType == "Income") {
        double adjustedMonthlySavings =
            double.parse(pinextUserModel.monthlySavings) + double.parse(amount);
        double adjustedNetBalance =
            double.parse(pinextUserModel.netBalance) + double.parse(amount);
        await FirebaseServices()
            .firebaseFirestore
            .collection("pinext_users")
            .doc(FirebaseServices().getUserId())
            .update({
          "monthlySavings": adjustedMonthlySavings.toString(),
          "netBalance": adjustedNetBalance.toString(),
        });
        await UserHandler().getCurrentUser();
      } else {
        double adjustedMonthlySavings =
            double.parse(pinextUserModel.monthlySavings) - double.parse(amount);
        double adjustedDailyExpenses =
            double.parse(pinextUserModel.dailyExpenses) + double.parse(amount);
        double adjustedMonthlyExpenses =
            double.parse(pinextUserModel.monthlyExpenses) +
                double.parse(amount);
        double adjustedNetBalance =
            double.parse(pinextUserModel.netBalance) - double.parse(amount);
        double adjustedWeeklyExpenses =
            double.parse(pinextUserModel.weeklyExpenses) + double.parse(amount);
        await FirebaseServices()
            .firebaseFirestore
            .collection("pinext_users")
            .doc(FirebaseServices().getUserId())
            .update({
          "netBalance": adjustedNetBalance.toString(),
          "dailyExpenses": adjustedDailyExpenses.toString(),
          "monthlyExpenses": adjustedMonthlyExpenses.toString(),
          "monthlySavings": adjustedMonthlySavings.toString(),
          "weeklyExpenses": adjustedWeeklyExpenses.toString(),
        });
      }

      response = "Success";
    } on FirebaseException catch (err) {
      response = err.message.toString();
    } catch (err) {
      response = err.toString();
    }
    return response;
  }
}
