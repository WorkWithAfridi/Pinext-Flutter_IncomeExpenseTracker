import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pinext/app/models/pinext_subscription_model.dart';
import 'package:pinext/app/services/handlers/subscription_handler.dart';

part 'add_subscription_state.dart';

class AddSubscriptionCubit extends Cubit<AddSubscriptionState> {
  AddSubscriptionCubit()
      : super(
          AddSubscriptionDefaultState(
            automaticallyPayActivated: false,
            selectedCardNo: "",
            alreadyPaid: "",
          ),
        );

  selectCard(String selectedCardNo) {
    if (state.selectedCardNo == selectedCardNo) {
      emit(
        AddSubscriptionDefaultState(
          selectedCardNo: "",
          automaticallyPayActivated: state.automaticallyPayActivated,
          alreadyPaid: state.alreadyPaid,
        ),
      );
    } else {
      emit(
        AddSubscriptionDefaultState(
          selectedCardNo: selectedCardNo,
          automaticallyPayActivated: state.automaticallyPayActivated,
          alreadyPaid: state.alreadyPaid,
        ),
      );
    }
  }

  toogleAutomaticallyPaySwitch(bool value) {
    emit(
      AddSubscriptionDefaultState(
        selectedCardNo: state.selectedCardNo,
        automaticallyPayActivated: value,
        alreadyPaid: state.alreadyPaid,
      ),
    );
  }

  addSubscription(
    PinextSubscriptionModel pinextSubscriptionModel,
  ) async {
    emit(
      AddSubscriptionLoadingState(
        automaticallyPayActivated: pinextSubscriptionModel.automaticallyDeductEnabled,
        selectedCardNo: pinextSubscriptionModel.assignedCardId,
        alreadyPaid: state.alreadyPaid,
      ),
    );
    await Future.delayed(
      const Duration(seconds: 1),
    );
    String response = await SubscriptionHandler().addSubscription(subscriptionModel: pinextSubscriptionModel);
    if (response == "success") {
      emit(
        AddSubscriptionSuccessState(
          automaticallyPayActivated: pinextSubscriptionModel.automaticallyDeductEnabled,
          selectedCardNo: pinextSubscriptionModel.assignedCardId,
          alreadyPaid: state.alreadyPaid,
        ),
      );
    } else {
      emit(
        AddSubscriptionErrorState(
          automaticallyPayActivated: pinextSubscriptionModel.automaticallyDeductEnabled,
          selectedCardNo: pinextSubscriptionModel.assignedCardId,
          alreadyPaid: state.alreadyPaid,
        ),
      );
    }
  }

  updateSubscription(PinextSubscriptionModel subscriptionModel, bool addTransactionToArchive) async {
    emit(
      AddSubscriptionLoadingState(
        automaticallyPayActivated: subscriptionModel.automaticallyDeductEnabled,
        selectedCardNo: subscriptionModel.assignedCardId,
        alreadyPaid: "",
      ),
    );
    String response = await SubscriptionHandler().updateSubscription(
      subscriptionModel: subscriptionModel,
      addTransactionToArchive: addTransactionToArchive,
    );
    if (response == "success") {
      emit(
        SubscriptionSuccessfullyUpdatedState(
          automaticallyPayActivated: subscriptionModel.automaticallyDeductEnabled,
          selectedCardNo: subscriptionModel.assignedCardId,
          alreadyPaid: "",
        ),
      );
    } else {
      emit(
        SubscriptionFailedToUpdateState(
          automaticallyPayActivated: subscriptionModel.automaticallyDeductEnabled,
          selectedCardNo: subscriptionModel.assignedCardId,
          alreadyPaid: "",
        ),
      );
    }
  }

  changeAlreadyPaidStatus(String status) {
    emit(
      AddSubscriptionDefaultState(
        selectedCardNo: state.selectedCardNo,
        automaticallyPayActivated: state.automaticallyPayActivated,
        alreadyPaid: status,
      ),
    );
  }

  resetState() {
    emit(
      AddSubscriptionDefaultState(
        automaticallyPayActivated: state.automaticallyPayActivated,
        selectedCardNo: state.selectedCardNo,
        alreadyPaid: state.alreadyPaid,
      ),
    );
  }
}
