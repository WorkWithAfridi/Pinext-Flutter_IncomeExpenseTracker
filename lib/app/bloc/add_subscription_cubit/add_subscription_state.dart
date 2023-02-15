// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'add_subscription_cubit.dart';

abstract class AddSubscriptionState extends Equatable {
  String title;
  String description;
  String amount;
  bool automaticallyPayActivated;
  String selectedCardNo;
  AddSubscriptionState({
    required this.title,
    required this.description,
    required this.amount,
    required this.automaticallyPayActivated,
    required this.selectedCardNo,
  });

  @override
  List<Object> get props => [
        title,
        description,
        amount,
        automaticallyPayActivated,
        selectedCardNo,
      ];
}

class AddSubscriptionDefaultState extends AddSubscriptionState {
  AddSubscriptionDefaultState({
    required super.title,
    required super.description,
    required super.amount,
    required super.automaticallyPayActivated,
    required super.selectedCardNo,
  });
}

class AddSubscriptionLoadingState extends AddSubscriptionState {
  AddSubscriptionLoadingState({
    required super.title,
    required super.description,
    required super.amount,
    required super.automaticallyPayActivated,
    required super.selectedCardNo,
  });
}
