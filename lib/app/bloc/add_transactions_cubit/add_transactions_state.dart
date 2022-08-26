part of 'add_transactions_cubit.dart';

enum SelectedTransactionMode {
  enpense,
  income,
}

abstract class AddTransactionsState extends Equatable {
  AddTransactionsState({required this.selectedTransactionMode});
  SelectedTransactionMode selectedTransactionMode;

  @override
  List<Object> get props => [
        selectedTransactionMode,
      ];
}

class AddTransactionsInitialState extends AddTransactionsState {
  AddTransactionsInitialState({required super.selectedTransactionMode});
}
