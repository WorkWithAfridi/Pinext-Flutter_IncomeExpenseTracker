import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinext/app/models/pinext_card_model.dart';

import '../../services/handlers/card_handler.dart';
import '../userBloc/user_bloc.dart';

part 'cards_and_balances_state.dart';

class CardsAndBalancesCubit extends Cubit<CardsAndBalancesState> {
  CardsAndBalancesCubit() : super(CardsAndBalancesDefaultState());

  removeCard(PinextCardModel pinextCardModel) async {
    await CardHandler().removeCard(pinextCardModel);
    emit(CardsAndBalancesSuccessfullyRemovedCardState());
  }

  resetState() {
    emit(CardsAndBalancesDefaultState());
  }

  addCard(PinextCardModel pinextCardModel,) async {
    await CardHandler().addCard(
      pinextCardModel: pinextCardModel,
      duringSignIn: false,
    );
    emit(CardsAndBalancesSuccessfullyAddedCardState());
  }
}
