// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'add_subscription_cubit.dart';

abstract class AddSubscriptionState extends Equatable {
  bool automaticallyPayActivated;
  String selectedCardNo;
  String alreadyPaid;
  AddSubscriptionState({
    required this.automaticallyPayActivated,
    required this.selectedCardNo,
    required this.alreadyPaid,
  });

  @override
  List<Object> get props => [
        automaticallyPayActivated,
        selectedCardNo,
        alreadyPaid,
      ];
}

class AddSubscriptionDefaultState extends AddSubscriptionState {
  AddSubscriptionDefaultState({
    required super.automaticallyPayActivated,
    required super.selectedCardNo,
    required super.alreadyPaid,
  });
}

class AddSubscriptionLoadingState extends AddSubscriptionState {
  AddSubscriptionLoadingState({
    required super.automaticallyPayActivated,
    required super.selectedCardNo,
    required super.alreadyPaid,
  });
}

class AddSubscriptionSuccessState extends AddSubscriptionState {
  AddSubscriptionSuccessState({
    required super.automaticallyPayActivated,
    required super.selectedCardNo,
    required super.alreadyPaid,
  });
}

class AddSubscriptionErrorState extends AddSubscriptionState {
  AddSubscriptionErrorState({
    required super.automaticallyPayActivated,
    required super.selectedCardNo,
    required super.alreadyPaid,
  });
}

class SubscriptionSuccessfullyUpdatedState extends AddSubscriptionState {
  SubscriptionSuccessfullyUpdatedState({
    required super.automaticallyPayActivated,
    required super.selectedCardNo,
    required super.alreadyPaid,
  });
}

class SubscriptionFailedToUpdateState extends AddSubscriptionState {
  String errorMessage;
  SubscriptionFailedToUpdateState({
    required super.automaticallyPayActivated,
    required super.selectedCardNo,
    required super.alreadyPaid,
    required this.errorMessage,
  });
}

class UpdateSubscriptionMarkAsPaidAndAddTransactionButtonLoadingState extends AddSubscriptionState {
  UpdateSubscriptionMarkAsPaidAndAddTransactionButtonLoadingState({
    required super.automaticallyPayActivated,
    required super.selectedCardNo,
    required super.alreadyPaid,
  });
}

class DeletedSubscriptionSuccessState extends AddSubscriptionState {
  DeletedSubscriptionSuccessState({
    required super.automaticallyPayActivated,
    required super.selectedCardNo,
    required super.alreadyPaid,
  });
}

class UpdateSubscriptionMarkAsPaidButtonLoadingState extends AddSubscriptionState {
  UpdateSubscriptionMarkAsPaidButtonLoadingState({
    required super.automaticallyPayActivated,
    required super.selectedCardNo,
    required super.alreadyPaid,
  });
}
