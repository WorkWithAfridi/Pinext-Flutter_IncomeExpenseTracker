import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pinext/app/handlers/card_handler.dart';
import 'package:pinext/app/models/pinext_card_model.dart';
import 'package:pinext/app/models/pinext_transaction_model.dart';
import 'package:pinext/app/services/firebase_services.dart';
import 'package:uuid/uuid.dart';

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
    String dateTimeNow = DateTime.now().toString();
    String year = dateTimeNow.substring(0, 3);
    try {
      String dateTimeNow = DateTime.now().toString();
      String year = dateTimeNow.substring(0, 4);
      String month = dateTimeNow.substring(5, 7);
      String date = dateTimeNow.substring(8, 10);
      String transactionId = const Uuid().v4();
      PinextTransactionModel pinextTransactionModel = PinextTransactionModel(
        transactionType: transactionType,
        amount: amount,
        details: description,
        cardId: cardId,
        transactionDate: dateTimeNow,
        transactionId: transactionId,
      );
      //Adding transaction
      FirebaseServices()
          .firebaseFirestore
          .collection("pinext_users")
          .doc(FirebaseServices().getUserId())
          .collection("pinext_transactions")
          .doc(year)
          .collection(month)
          .doc(
            transactionId,
          )
          .set(
            pinextTransactionModel.toMap(),
          );

      // Adjust card balance
      PinextCardModel pinextCardModel = await CardHandler().getCard(cardId);
      double adjustedAmount = transactionType == "Income"
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
      });

      // //Adjusting global balances
      // await FirebaseServices()
      //     .firebaseFirestore
      //     .collection("pinext_users")
      //     .doc(FirebaseServices().getUserId())
      //     .update({
      //   "balance": adjustedAmount,
      // });

      response = "Success";
    } on FirebaseException catch (err) {
      response = err.message.toString();
    } catch (err) {
      response = err.toString();
    }
    return response;
  }
}
