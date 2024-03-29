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

  void reset() {
    emit(
      SigninDefaultState(
        const [],
        0,
        const [],
        0,
      ),
    );
  }

  void addCard(PinextCardModel card) {
    final userCards = <PinextCardModel>[...state.cards, card];
    emit(
      SigninDefaultState(
        userCards,
        userCards.length,
        state.goals,
        state.numberOfGoalsStored,
      ),
    );
  }

  void addGoal(PinextGoalModel goal) {
    final userGoals = <PinextGoalModel>[
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

  void removeCard(int cardIndex) {
    final cardList = state.cards;
    cardList.removeAt(cardIndex);
    emit(
      SigninDefaultState(
        cardList,
        cardList.length,
        state.goals,
        state.numberOfGoalsStored,
      ),
    );
  }

  void removeGoal(int goalIndex) {
    final goalsList = state.goals;
    goalsList.removeAt(goalIndex);
    emit(
      SigninDefaultState(
        state.cards,
        state.cards.length,
        goalsList,
        goalsList.length,
      ),
    );
  }

  Future<void> signupUser({
    required String emailAddress,
    required String regionCode,
    required String password,
    required String username,
    required List<PinextCardModel> pinextCards,
    required String netBalance,
    required String monthlyBudget,
    required String budgetSpentSoFar,
    required List<PinextGoalModel> pinextGoals,
  }) async {
    emit(
      SigninLoadingState(
        state.cards,
        state.cards.length,
        state.goals,
        state.goals.length,
      ),
    );
    await Future.delayed(const Duration(seconds: 1));
    final result = await AuthenticationServices().signupUserUsingEmailAndPassword(
      emailAddress: emailAddress,
      password: password,
      username: username,
      pinextCards: pinextCards,
      netBalance: netBalance,
      monthlyBudget: monthlyBudget,
      budgetSpentSoFar: budgetSpentSoFar,
      pinextGoals: pinextGoals,
      regionCode: regionCode,
    );
    if (result == 'Success') {
      emit(
        SigninSuccessState(
          state.cards,
          state.cards.length,
          state.goals,
          state.goals.length,
        ),
      );
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
