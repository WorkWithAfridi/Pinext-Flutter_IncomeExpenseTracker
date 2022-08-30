import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pinext/app/models/pinext_card_model.dart';
import 'package:pinext/app/services/authentication_services.dart';

part 'signin_cubit_state.dart';

class SigninCubit extends Cubit<SigninState> {
  SigninCubit()
      : super(
          SigninDefaultState(
            const [],
            0,
          ),
        );

  reset() {
    emit(SigninDefaultState(const [], 0));
  }

  addCard(PinextCardModel card) {
    List<PinextCardModel> userCards = [...state.cards, card];
    emit(SigninDefaultState(
      userCards,
      userCards.length,
    ));
  }

  removeCard(int cardIndex) {
    log(cardIndex.toString());
    log(state.cards.length.toString());
    var cardList = state.cards;
    cardList.removeAt(cardIndex);
    log(cardList.length.toString());
    emit(
      SigninDefaultState(
        cardList,
        cardList.length,
      ),
    );
  }

  signupUser({
    required String emailAddress,
    required String password,
    required String username,
    required List<PinextCardModel> pinextCards,
    required String netBalance,
    required String monthlyBudget,
    required String budgetSpentSoFar,
  }) async {
    emit(SigninLoadingState(pinextCards, pinextCards.length));
    await Future.delayed(const Duration(seconds: 2));
    String result =
        await AuthenticationServices().signupUserUsingEmailAndPassword(
      emailAddress: emailAddress,
      password: password,
      username: username,
      pinextCards: pinextCards,
      netBalance: netBalance,
      monthlyBudget: monthlyBudget,
      budgetSpentSoFar: budgetSpentSoFar,
    );
    if (result == "Success") {
      emit(SigninSuccessState(pinextCards, pinextCards.length));
    } else {
      emit(SigninErrorState(pinextCards, pinextCards.length, result));
    }
  }
}
