import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'add_card_state.dart';

class AddCardCubit extends Cubit<AddCardState> {
  AddCardCubit()
      : super(
          AddCardDefaultState(
            balance: 0,
            title: 'none',
            description: 'none',
            color: 'none',
          ),
        );

  void changeTitle(String newTitle) {
    emit(
      AddCardDefaultState(
        title: newTitle,
        description: state.description,
        balance: state.balance,
        color: state.color,
      ),
    );
  }

  void changeDescription(String newDescription) {
    emit(
      AddCardDefaultState(
        title: state.title,
        description: newDescription,
        balance: state.balance,
        color: state.color,
      ),
    );
  }

  void changeBalance(double newBalance) {
    emit(
      AddCardDefaultState(
        title: state.title,
        description: state.description,
        balance: newBalance,
        color: state.color,
      ),
    );
  }

  void changeColor(String color) {
    emit(
      AddCardDefaultState(
        title: state.title,
        description: state.description,
        balance: state.balance,
        color: color,
      ),
    );
  }

  void updateCardDetails(String title, String description, String balance, String color) {
    if (title.isNotEmpty && balance.isNotEmpty) {
      emit(
        EditCardSuccessState(
          title: title.toString(),
          description: description.toString(),
          balance: double.parse(balance),
          color: color.toString(),
        ),
      );
    } else {
      emit(
        EditCardErrorState(
          title: title.toString(),
          description: description.toString(),
          balance: double.parse(balance),
          color: color.toString(),
        ),
      );
    }
  }

  void addCard(String title, String description, String balance, String color) {
    if (title.isNotEmpty && balance.isNotEmpty) {
      emit(
        AddCardSuccessState(
          title: title.toString(),
          description: description.toString(),
          balance: double.parse(balance),
          color: color,
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

  void reset() {
    emit(
      AddCardDefaultState(
        title: state.title,
        description: state.description,
        balance: state.balance,
        color: state.color,
      ),
    );
  }
}
