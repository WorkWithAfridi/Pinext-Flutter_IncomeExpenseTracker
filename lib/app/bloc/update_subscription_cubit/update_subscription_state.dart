// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'update_subscription_cubit.dart';

abstract class UpdateSubscriptionState extends Equatable {
  const UpdateSubscriptionState();

  @override
  List<Object> get props => [];
}

class UpdateSubscriptionDefault extends UpdateSubscriptionState {}

class SubscriptionUpdatedSuccessfullyState extends UpdateSubscriptionState {}

class SubscriptionUpdatedErrorState extends UpdateSubscriptionState {
  String errorMessage;
  SubscriptionUpdatedErrorState({
    required this.errorMessage,
  });
}
