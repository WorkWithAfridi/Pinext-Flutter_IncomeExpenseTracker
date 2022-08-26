import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'add_transactions_state.dart';

class AddTransactionsCubit extends Cubit<AddTransactionsState> {
  AddTransactionsCubit()
      : super(
          AddTransactionsInitialState(
            selectedTransactionMode: SelectedTransactionMode.enpense,
          ),
        );

  changeSelectedTransactionMode(
      SelectedTransactionMode selectedTransactionMode) {
    emit(
      AddTransactionsInitialState(
          selectedTransactionMode: selectedTransactionMode),
    );
  }
}
