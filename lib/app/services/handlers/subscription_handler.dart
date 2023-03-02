import 'package:pinext/app/API/firebase_directories.dart';
import 'package:pinext/app/models/pinext_subscription_model.dart';
import 'package:pinext/app/services/firebase_services.dart';
import 'package:pinext/app/services/handlers/transaction_handler.dart';
import 'package:pinext/app/services/handlers/user_handler.dart';

class SubscriptionHandler {
  SubscriptionHandler._internal();
  static final SubscriptionHandler _subscriptionServices = SubscriptionHandler._internal();
  factory SubscriptionHandler() => _subscriptionServices;

  Future addSubscription({
    required PinextSubscriptionModel subscriptionModel,
  }) async {
    String response = "error";
    try {
      await FirebaseServices()
          .firebaseFirestore
          .collection(USERS_DIRECTORY)
          .doc(FirebaseServices().getUserId())
          .collection('pinext_subscriptions')
          .doc(subscriptionModel.subscriptionId)
          .set(subscriptionModel.toMap());
      response = "success";
    } catch (err) {
      response = "error";
    }
    return response;
  }

  removeSubscription({
    required PinextSubscriptionModel subscriptionModel,
  }) async {
    await FirebaseServices()
        .firebaseFirestore
        .collection(USERS_DIRECTORY)
        .doc(FirebaseServices().getUserId())
        .collection('pinext_subscriptions')
        .doc(subscriptionModel.subscriptionId)
        .delete();
    return;
  }

  Future updateSubscription({
    required PinextSubscriptionModel subscriptionModel,
    required bool addTransactionToArchive,
  }) async {
    try {
      await FirebaseServices()
          .firebaseFirestore
          .collection(USERS_DIRECTORY)
          .doc(UserHandler().currentUser.userId)
          .collection("pinext_subscriptions")
          .doc(subscriptionModel.subscriptionId)
          .update(subscriptionModel.toMap());
      if (addTransactionToArchive) {
        await TransactionHandler().addTransaction(
          amount: subscriptionModel.amount,
          description: subscriptionModel.title,
          transactionType: "Expense",
          cardId: subscriptionModel.assignedCardId,
          transactionTag: "Subscription",
          markedAs: true,
        );
      }
      return "success";
    } catch (err) {
      return "error";
    }
  }
}
