part of 'signin_cubit_cubit.dart';

abstract class SigninState extends Equatable {
  SigninState(
    this.cards,
    this.numberOfCardsStored,
    this.goals,
    this.numberOfGoalsStored,
  );
  List<PinextCardModel> cards;
  int numberOfCardsStored;
  List<PinextGoalModel> goals;
  int numberOfGoalsStored;
  @override
  List<Object> get props => [
        cards,
        numberOfCardsStored,
        goals,
        numberOfGoalsStored,
      ];
}

class SigninDefaultState extends SigninState {
  SigninDefaultState(
    super.cards,
    super.numberOfCardsStored,
    super.goals,
    super.numberOfGoalsStored,
  );
}

class SigninLoadingState extends SigninState {
  SigninLoadingState(
    super.cards,
    super.numberOfCardsStored,
    super.goals,
    super.numberOfGoalsStored,
  );
}

class SigninSuccessState extends SigninState {
  SigninSuccessState(
    super.cards,
    super.numberOfCardsStored,
    super.goals,
    super.numberOfGoalsStored,
  );
}

class SigninErrorState extends SigninState {
  String errorMessage;
  SigninErrorState(
    super.cards,
    super.numberOfCardsStored,
    this.errorMessage,
    super.goals,
    super.numberOfGoalsStored,
  );
}
