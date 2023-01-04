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
    required this.countAs,
  });
  SelectedTransactionMode selectedTransactionMode;
  String selectedCardNo;
  String selectedDescription;
  bool countAs;

  @override
  List<Object> get props => [
        selectedTransactionMode,
        selectedCardNo,
        selectedDescription,
        countAs
      ];
}

class AddTransactionsDefaultState extends AddTransactionsState {
  AddTransactionsDefaultState({
    required super.selectedTransactionMode,
    required super.selectedCardNo,
    required super.selectedDescription,
    required super.countAs,
  });
}

class AddTransactionsSuccessState extends AddTransactionsState {
  AddTransactionsSuccessState({
    required super.selectedTransactionMode,
    required super.selectedCardNo,
    required super.selectedDescription,
    required super.countAs,
  });
}

class AddTransactionsErrorState extends AddTransactionsState {
  String errorMessage;
  AddTransactionsErrorState({
    required super.selectedTransactionMode,
    required super.selectedCardNo,
    required super.selectedDescription,
    required super.countAs,
    required this.errorMessage,
  });
}

class AddTransactionsLoadingState extends AddTransactionsState {
  AddTransactionsLoadingState({
    required super.selectedTransactionMode,
    required super.selectedCardNo,
    required super.selectedDescription,
    required super.countAs,
  });
}
