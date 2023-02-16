import 'package:pinext/app/API/firebase_directories.dart';
import 'package:pinext/app/models/pinext_subscription_model.dart';
import 'package:pinext/app/services/firebase_services.dart';

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
}
