part of 'signin_cubit_cubit.dart';

abstract class SigninState extends Equatable {
  SigninState(this.cards, this.numberOfCardsStored);
  List<PinextCardModel> cards;
  int numberOfCardsStored;

  @override
  List<Object> get props => [
        cards,
        numberOfCardsStored,
      ];
}

class SigninDefaultState extends SigninState {
  SigninDefaultState(
    super.cards,
    super.numberOfCardsStored,
  );
}

class SigninLoadingState extends SigninState {
  SigninLoadingState(
    super.cards,
    super.numberOfCardsStored,
  );
}

class SigninSuccessState extends SigninState {
  SigninSuccessState(
    super.cards,
    super.numberOfCardsStored,
  );
}

class SigninErrorState extends SigninState {
  String errorMessage;
  SigninErrorState(
    super.cards,
    super.numberOfCardsStored,
    this.errorMessage,
  );
}
