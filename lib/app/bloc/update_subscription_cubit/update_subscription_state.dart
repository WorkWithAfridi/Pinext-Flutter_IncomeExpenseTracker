part of 'update_subscription_cubit.dart';

abstract class UpdateSubscriptionState extends Equatable {
  const UpdateSubscriptionState();

  @override
  List<Object> get props => [];
}

class UpdateSubscriptionDefault extends UpdateSubscriptionState {}
class SubscriptionUpdatedSuccessfullyState extends UpdateSubscriptionState {}
class SubscriptionUpdatedErrorState extends UpdateSubscriptionState {}
