import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'add_card_state.dart';

class AddCardCubit extends Cubit<AddCardState> {
  AddCardCubit()
      : super(
          AddCardDefaultState(
            balance: 0.00,
            title: "none",
            description: "none",
            color: "none",
          ),
        );

  changeTitle(String newTitle) {
    emit(
      AddCardDefaultState(
        title: newTitle,
        description: state.description,
        balance: state.balance,
        color: state.color,
      ),
    );
  }

  changeDescription(String newDescription) {
    emit(
      AddCardDefaultState(
        title: state.title,
        description: newDescription,
        balance: state.balance,
        color: state.color,
      ),
    );
  }

  changeBalance(double newBalance) {
    emit(
      AddCardDefaultState(
        title: state.title,
        description: state.description,
        balance: newBalance,
        color: state.color,
      ),
    );
  }

  changeColor(String color) {
    log(color);
    emit(
      AddCardDefaultState(
        title: state.title,
        description: state.description,
        balance: state.balance,
        color: color,
      ),
    );
  }

  addCard(String title, String description, String balance, String color) {
    log(title);
    if (title.isNotEmpty && description.isNotEmpty && balance.isNotEmpty) {
      emit(
        AddCardSuccessState(
          title: state.title,
          description: state.description,
          balance: state.balance,
          color: state.color,
        ),
      );
    } else {
      emit(
        AddCardErrorState(
          title: state.title,
          description: state.description,
          balance: state.balance,
          color: state.color,
        ),
      );
    }
  }
}
