part of 'signin_cubit_cubit.dart';

abstract class SigninState extends Equatable {
  SigninState(this.pageController, this.cards, this.numberOfCardsStored);
  final PageController pageController;
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
    super.pageController,
    super.cards,
    super.numberOfCardsStored,
  );
}

class SigninLoadingState extends SigninState {
  SigninLoadingState(
    super.pageController,
    super.cards,
    super.numberOfCardsStored,
  );
}

class SigninSuccessState extends SigninState {
  SigninSuccessState(
    super.pageController,
    super.cards,
    super.numberOfCardsStored,
  );
}

class SigninErrorState extends SigninState {
  String errorMessage;
  SigninErrorState(
    super.pageController,
    super.cards,
    super.numberOfCardsStored,
    this.errorMessage,
  );
}
