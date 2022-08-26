part of 'add_transactions_cubit.dart';

enum SelectedTransactionMode {
  enpense,
  income,
}

abstract class AddTransactionsState extends Equatable {
  AddTransactionsState({
    required this.selectedTransactionMode,
    required this.selectedCardNo,
  });
  SelectedTransactionMode selectedTransactionMode;
  String selectedCardNo;

  @override
  List<Object> get props => [
        selectedTransactionMode,
        selectedCardNo,
      ];
}

class AddTransactionsDefaultState extends AddTransactionsState {
  AddTransactionsDefaultState({
    required super.selectedTransactionMode,
    required super.selectedCardNo,
  });
}

class AddTransactionsSuccessState extends AddTransactionsState {
  AddTransactionsSuccessState({
    required super.selectedTransactionMode,
    required super.selectedCardNo,
  });
}

class AddTransactionsLoadingState extends AddTransactionsState {
  AddTransactionsLoadingState({
    required super.selectedTransactionMode,
    required super.selectedCardNo,
  });
}
