import 'package:flutter/material.dart';
import 'package:pinext/app/API/firebase_directories.dart';
import 'package:pinext/app/models/pinext_subscription_model.dart';
import 'package:pinext/app/services/firebase_services.dart';
import 'package:pinext/app/services/handlers/transaction_handler.dart';
import 'package:pinext/app/services/handlers/user_handler.dart';

class SubscriptionHandler {
  factory SubscriptionHandler() => _subscriptionServices;
  SubscriptionHandler._internal();
  static final SubscriptionHandler _subscriptionServices = SubscriptionHandler._internal();

  Future<String> addSubscription({
    required PinextSubscriptionModel subscriptionModel,
  }) async {
    var response = 'error';
    try {
      await FirebaseServices()
          .firebaseFirestore
          .collection(USERS_DIRECTORY)
          .doc(FirebaseServices().getUserId())
          .collection('pinext_subscriptions')
          .doc(subscriptionModel.subscriptionId)
          .set(subscriptionModel.toMap());
      response = 'success';
    } catch (err) {
      response = 'error';
    }
    return response;
  }

  Future<void> removeSubscription({
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

  Future<String> updateSubscription({
    required PinextSubscriptionModel subscriptionModel,
    required bool addTransactionToArchive,
    required BuildContext context,
  }) async {
    try {
      final response;
      if (addTransactionToArchive) {
        final response = await TransactionHandler().addTransaction(
          amount: subscriptionModel.amount,
          description: subscriptionModel.title,
          transactionType: 'Expense',
          cardId: subscriptionModel.assignedCardId,
          transactionTag: 'Subscription',
          markedAs: true,
          context: context,
        );

        if (response == 'Success') {
          await FirebaseServices()
              .firebaseFirestore
              .collection(USERS_DIRECTORY)
              .doc(UserHandler().currentUser.userId)
              .collection('pinext_subscriptions')
              .doc(subscriptionModel.subscriptionId)
              .update(subscriptionModel.toMap());
        } else {
          return response;
        }
      }

      await FirebaseServices()
          .firebaseFirestore
          .collection(USERS_DIRECTORY)
          .doc(UserHandler().currentUser.userId)
          .collection('pinext_subscriptions')
          .doc(subscriptionModel.subscriptionId)
          .update(subscriptionModel.toMap());

      return 'Success';
    } catch (err) {
      return 'Error';
    }
  }
}
