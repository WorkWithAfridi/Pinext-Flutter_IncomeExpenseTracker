import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:pinext/app/models/pinext_subscription_model.dart';
import 'package:pinext/app/services/handlers/subscription_handler.dart';

part 'update_subscription_state.dart';

class UpdateSubscriptionCubit extends Cubit<UpdateSubscriptionState> {
  UpdateSubscriptionCubit() : super(UpdateSubscriptionDefault());

  Future<void> updateSubscriptionStatus({
    required PinextSubscriptionModel subscriptionModel,
    required BuildContext context,
  }) async {
    subscriptionModel.lastPaidOn = DateTime.now().toString();
    final response = await SubscriptionHandler().updateSubscription(
      subscriptionModel: subscriptionModel,
      addTransactionToArchive: true,
      context: context,
    );
    if (response == 'Success') {
      emit(SubscriptionUpdatedSuccessfullyState());
    } else {
      emit(
        SubscriptionUpdatedErrorState(
          errorMessage: response,
        ),
      );
    }
  }

  void resetState() {
    emit(UpdateSubscriptionDefault());
  }
}
