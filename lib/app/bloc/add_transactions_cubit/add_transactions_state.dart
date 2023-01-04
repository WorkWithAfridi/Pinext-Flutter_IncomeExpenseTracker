part of 'add_transactions_cubit.dart';

enum SelectedTransactionMode {
  enpense,
  income,
}

abstract class AddTransactionsState extends Equatable {
  AddTransactionsState({
    required this.selectedTransactionMode,
    required this.selectedCardNo,
    required this.selectedDescription,
    required this.markAs,
  });
  SelectedTransactionMode selectedTransactionMode;
  String selectedCardNo;
  String selectedDescription;
  bool markAs;

  @override
  List<Object> get props => [
        selectedTransactionMode,
        selectedCardNo,
        selectedDescription,
        markAs
      ];
}

class AddTransactionsDefaultState extends AddTransactionsState {
  AddTransactionsDefaultState({
    required super.selectedTransactionMode,
    required super.selectedCardNo,
    required super.selectedDescription,
    required super.markAs,
  });
}

class AddTransactionsSuccessState extends AddTransactionsState {
  AddTransactionsSuccessState({
    required super.selectedTransactionMode,
    required super.selectedCardNo,
    required super.selectedDescription,
    required super.markAs,
  });
}

class AddTransactionsErrorState extends AddTransactionsState {
  String errorMessage;
  AddTransactionsErrorState({
    required super.selectedTransactionMode,
    required super.selectedCardNo,
    required super.selectedDescription,
    required super.markAs,
    required this.errorMessage,
  });
}

class AddTransactionsLoadingState extends AddTransactionsState {
  AddTransactionsLoadingState({
    required super.selectedTransactionMode,
    required super.selectedCardNo,
    required super.selectedDescription,
    required super.markAs,
  });
}
