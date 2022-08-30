part of 'cards_and_balances_cubit.dart';

abstract class CardsAndBalancesState extends Equatable {
  const CardsAndBalancesState();

  @override
  List<Object> get props => [];
}

class CardsAndBalancesDefaultState extends CardsAndBalancesState {}
class CardsAndBalancesSuccessfullyRemovedCardState extends CardsAndBalancesState {}
class CardsAndBalancesSuccessfullyAddedCardState extends CardsAndBalancesState {}

