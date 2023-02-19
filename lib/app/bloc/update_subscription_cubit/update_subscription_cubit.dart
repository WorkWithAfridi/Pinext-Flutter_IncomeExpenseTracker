import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pinext/app/models/pinext_subscription_model.dart';
import 'package:pinext/app/services/handlers/subscription_handler.dart';

part 'update_subscription_state.dart';

class UpdateSubscriptionCubit extends Cubit<UpdateSubscriptionState> {
  UpdateSubscriptionCubit() : super(UpdateSubscriptionDefault());
  updateSubscriptionStatus({required PinextSubscriptionModel subscriptionModel}) async {
    subscriptionModel.lastPaidOn = DateTime.now().toString();
    String response = await SubscriptionHandler().updateSubscription(
      subscriptionModel: subscriptionModel,
      addTransactionToArchive: true,
    );
    if (response == "success") {
      emit(SubscriptionUpdatedSuccessfullyState());
    } else {
      emit(SubscriptionUpdatedErrorState());
    }
  }
}
