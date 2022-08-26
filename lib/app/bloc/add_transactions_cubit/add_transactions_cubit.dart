import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'add_transactions_state.dart';

class AddTransactionsCubit extends Cubit<AddTransactionsState> {
  AddTransactionsCubit()
      : super(
          AddTransactionsDefaultState(
            selectedTransactionMode: SelectedTransactionMode.enpense,
            selectedCardNo: "none",
          ),
        );

  changeSelectedTransactionMode(
      SelectedTransactionMode selectedTransactionMode) {
    emit(
      AddTransactionsDefaultState(
        selectedTransactionMode: selectedTransactionMode,
        selectedCardNo: state.selectedCardNo,
      ),
    );
  }

  addTransaction() {
    emit(AddTransactionsLoadingState(
      selectedTransactionMode: state.selectedTransactionMode,
      selectedCardNo: state.selectedCardNo,
    ));
    Future.delayed(const Duration(seconds: 2)).then((value) {
      emit(AddTransactionsDefaultState(
        selectedTransactionMode: state.selectedTransactionMode,
        selectedCardNo: state.selectedCardNo,
      ));
      emit(AddTransactionsSuccessState(
        selectedCardNo: state.selectedCardNo,
        selectedTransactionMode: state.selectedTransactionMode,
      ));
    });
  }

  selectCard(String selectedCardNo) {
    emit(AddTransactionsDefaultState(
      selectedCardNo: selectedCardNo,
      selectedTransactionMode: state.selectedTransactionMode,
    ));
  }
}
