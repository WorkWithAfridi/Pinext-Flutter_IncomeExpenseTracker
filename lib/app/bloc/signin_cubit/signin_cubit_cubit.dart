import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:pinext/app/models/pinext_card_model.dart';

part 'signin_cubit_state.dart';

class SigninCubit extends Cubit<SigninState> {
  SigninCubit()
      : super(
          SigninDefaultState(
            PageController(initialPage: 0),
            const [],
            0,
          ),
        );

  addCard(PinextCardModel card) {
    List<PinextCardModel> userCards = [...state.cards, card];
    emit(SigninDefaultState(
      state.pageController,
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
        state.pageController,
        cardList,
        cardList.length,
      ),
    );
  }
}
