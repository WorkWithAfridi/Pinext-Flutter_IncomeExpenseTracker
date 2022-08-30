import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pinext/app/models/pinext_card_model.dart';

import '../../services/handlers/card_handler.dart';

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

  addCard(PinextCardModel pinextCardModel) {
    
  }
}
