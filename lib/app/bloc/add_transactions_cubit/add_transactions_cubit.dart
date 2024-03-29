import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinext/app/bloc/userBloc/user_bloc.dart';
import 'package:pinext/app/services/handlers/transaction_handler.dart';

part 'add_transactions_state.dart';

class AddTransactionsCubit extends Cubit<AddTransactionsState> {
  AddTransactionsCubit()
      : super(
          AddTransactionsDefaultState(
            selectedTransactionMode: SelectedTransactionMode.enpense,
            selectedCardNo: 'none',
            selectedDescription: 'none',
            markAs: true,
            selectedTag: '',
            transactionDate: DateTime.now(),
          ),
        );

  void changeSelectedTransactionMode(SelectedTransactionMode selectedTransactionMode) {
    emit(
      AddTransactionsDefaultState(
        selectedTransactionMode: selectedTransactionMode,
        selectedCardNo: state.selectedCardNo,
        selectedDescription: state.selectedDescription,
        markAs: state.markAs,
        selectedTag: state.selectedTag,
        transactionDate: state.transactionDate,
      ),
    );
  }

  void togglemarkAs(value) {
    emit(
      AddTransactionsDefaultState(
        selectedTransactionMode: state.selectedTransactionMode,
        selectedCardNo: state.selectedCardNo,
        selectedDescription: state.selectedDescription,
        markAs: !state.markAs,
        selectedTag: state.selectedTag,
        transactionDate: state.transactionDate,
      ),
    );
  }

  Future<void> addTransaction({
    required String amount,
    required String details,
    required String transctionType,
    required String transctionTag,
    required BuildContext context,
  }) async {
    emit(
      AddTransactionsLoadingState(
        selectedTransactionMode: state.selectedTransactionMode,
        selectedCardNo: state.selectedCardNo,
        selectedDescription: state.selectedDescription,
        markAs: state.markAs,
        selectedTag: state.selectedTag,
        transactionDate: state.transactionDate,
      ),
    );
    final response = await TransactionHandler().addTransaction(
      amount: amount,
      description: details,
      transactionType: transctionType,
      cardId: state.selectedCardNo,
      markedAs: state.markAs,
      transactionTag: transctionTag,
      context: context,
      transactionDate: state.transactionDate,
    );
    if (response == 'Success') {
      context.read<UserBloc>().add(RefreshUserStateEvent(context: context));
      await Future.delayed(const Duration(seconds: 1));
      emit(
        AddTransactionsSuccessState(
          selectedTransactionMode: state.selectedTransactionMode,
          selectedCardNo: state.selectedCardNo,
          selectedDescription: state.selectedDescription,
          markAs: state.markAs,
          selectedTag: state.selectedTag,
          transactionDate: state.transactionDate,
        ),
      );
    } else {
      emit(
        AddTransactionsErrorState(
          selectedTransactionMode: state.selectedTransactionMode,
          selectedCardNo: state.selectedCardNo,
          errorMessage: response,
          selectedDescription: state.selectedDescription,
          markAs: state.markAs,
          selectedTag: state.selectedTag,
          transactionDate: state.transactionDate,
        ),
      );
    }
  }

  void selectCard(String selectedCardNo) {
    emit(
      AddTransactionsDefaultState(
        selectedCardNo: selectedCardNo,
        selectedTransactionMode: state.selectedTransactionMode,
        selectedDescription: state.selectedDescription,
        markAs: state.markAs,
        selectedTag: state.selectedTag,
        transactionDate: state.transactionDate,
      ),
    );
  }

  void updateEntryDate(DateTime dateTime) {
    emit(
      AddTransactionsDefaultState(
        selectedCardNo: state.selectedCardNo,
        selectedTransactionMode: state.selectedTransactionMode,
        selectedDescription: state.selectedDescription,
        markAs: state.markAs,
        selectedTag: state.selectedTag,
        transactionDate: dateTime,
      ),
    );
  }

  void reset() {
    emit(
      AddTransactionsDefaultState(
        selectedTransactionMode: state.selectedTransactionMode,
        selectedCardNo: state.selectedCardNo,
        selectedDescription: state.selectedDescription,
        markAs: state.markAs,
        selectedTag: state.selectedTag,
        transactionDate: state.transactionDate,
      ),
    );
  }

  void changeSelectedDescription(String selectedDescription) {
    emit(
      AddTransactionsDefaultState(
        selectedTransactionMode: state.selectedTransactionMode,
        selectedCardNo: state.selectedCardNo,
        selectedDescription: selectedDescription,
        markAs: state.markAs,
        transactionDate: state.transactionDate,
        selectedTag: state.selectedTag,
      ),
    );
  }

  void changeSelectedTag(String selectedTag) {
    if (selectedTag == 'Income') {
      changeSelectedTransactionMode(SelectedTransactionMode.income);
    } else if (selectedTag == 'Others' || selectedTag == 'Transfer' || selectedTag == 'Miscellaneous' || selectedTag == '') {
      changeSelectedTransactionMode(state.selectedTransactionMode);
    } else {
      changeSelectedTransactionMode(SelectedTransactionMode.enpense);
    }
    emit(
      AddTransactionsDefaultState(
        selectedTransactionMode: state.selectedTransactionMode,
        selectedCardNo: state.selectedCardNo,
        selectedDescription: state.selectedDescription,
        markAs: state.markAs,
        selectedTag: selectedTag,
        transactionDate: state.transactionDate,
      ),
    );
  }
}
