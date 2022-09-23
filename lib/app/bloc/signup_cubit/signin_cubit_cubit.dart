import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pinext/app/models/pinext_card_model.dart';
import 'package:pinext/app/models/pinext_goal_model.dart';
import 'package:pinext/app/services/authentication_services.dart';

part 'signin_cubit_state.dart';

class SigninCubit extends Cubit<SigninState> {
  SigninCubit()
      : super(
          SigninDefaultState(
            const [],
            0,
            const [],
            0,
          ),
        );

  reset() {
    emit(SigninDefaultState(
      const [],
      0,
      const [],
      0,
    ));
  }

  addCard(PinextCardModel card) {
    List<PinextCardModel> userCards = [...state.cards, card];
    emit(SigninDefaultState(
      userCards,
      userCards.length,
      state.goals,
      state.numberOfGoalsStored,
    ));
  }

  addGoal(PinextGoalModel goal) {
    List<PinextGoalModel> userGoals = [
      ...state.goals,
      goal,
    ];
    emit(
      SigninDefaultState(
        state.cards,
        state.cards.length,
        userGoals,
        userGoals.length,
      ),
    );
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
        state.goals,
        state.numberOfGoalsStored,
      ),
    );
  }

  removeGoal(int goalIndex) {
    log(goalIndex.toString());
    log(state.goals.length.toString());
    var goalsList = state.goals;
    goalsList.removeAt(goalIndex);
    log(goalsList.length.toString());
    emit(
      SigninDefaultState(
        state.cards,
        state.cards.length,
        goalsList,
        goalsList.length,
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
    required List<PinextGoalModel> pinextGoals,
  }) async {
    emit(SigninLoadingState(
      state.cards,
      state.cards.length,
      state.goals,
      state.goals.length,
    ));
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
      pinextGoals: pinextGoals,
    );
    if (result == "Success") {
      emit(SigninSuccessState(
        state.cards,
        state.cards.length,
        state.goals,
        state.goals.length,
      ));
    } else {
      emit(
        SigninErrorState(
          state.cards,
          state.cards.length,
          result,
          state.goals,
          state.goals.length,
        ),
      );
    }
  }
}
