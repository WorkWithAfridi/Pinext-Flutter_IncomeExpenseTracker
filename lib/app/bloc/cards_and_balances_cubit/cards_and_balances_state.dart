// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'cards_and_balances_cubit.dart';

abstract class CardsAndBalancesState extends Equatable {
  const CardsAndBalancesState();

  @override
  List<Object> get props => [];
}

class CardsAndBalancesDefaultState extends CardsAndBalancesState {}

class CardsAndBalancesSuccessfullyRemovedCardState
    extends CardsAndBalancesState {}

class CardsAndBalancesSuccessfullyAddedCardState extends CardsAndBalancesState {
}

class CardsAndBalancesSuccessfullyEditedCardState
    extends CardsAndBalancesState {}

class CardsAndBalancesFailedToEditedCardState extends CardsAndBalancesState {
  String errorMessage;
  CardsAndBalancesFailedToEditedCardState({
    required this.errorMessage,
  });
  
}
