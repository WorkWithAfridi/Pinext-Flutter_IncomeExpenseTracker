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
    required this.selectedTag,
    required this.markAs,
    required this.transactionDate,
  });
  SelectedTransactionMode selectedTransactionMode;
  String selectedCardNo;
  String selectedDescription;
  String selectedTag;
  bool markAs;
  DateTime transactionDate;

  @override
  List<Object> get props => [selectedTransactionMode, selectedCardNo, selectedDescription, markAs, selectedTag, transactionDate.microsecondsSinceEpoch];
}

class AddTransactionsDefaultState extends AddTransactionsState {
  AddTransactionsDefaultState({
    required super.selectedTransactionMode,
    required super.selectedCardNo,
    required super.selectedDescription,
    required super.selectedTag,
    required super.markAs,
    required super.transactionDate,
  });
}

class AddTransactionsSuccessState extends AddTransactionsState {
  AddTransactionsSuccessState({
    required super.selectedTransactionMode,
    required super.selectedCardNo,
    required super.selectedDescription,
    required super.selectedTag,
    required super.markAs,
    required super.transactionDate,
  });
}

class AddTransactionsErrorState extends AddTransactionsState {
  AddTransactionsErrorState({
    required super.selectedTransactionMode,
    required super.selectedCardNo,
    required super.selectedDescription,
    required super.selectedTag,
    required super.markAs,
    required this.errorMessage,
    required super.transactionDate,
  });
  String errorMessage;
}

class AddTransactionsLoadingState extends AddTransactionsState {
  AddTransactionsLoadingState({
    required super.selectedTransactionMode,
    required super.selectedCardNo,
    required super.selectedDescription,
    required super.selectedTag,
    required super.markAs,
    required super.transactionDate,
  });
}
