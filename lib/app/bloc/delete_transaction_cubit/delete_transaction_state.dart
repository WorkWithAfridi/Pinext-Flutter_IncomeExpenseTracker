// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'delete_transaction_cubit.dart';

abstract class DeleteTransactionState extends Equatable {
  const DeleteTransactionState();

  @override
  List<Object> get props => [];
}

class DeleteTransactionDefaultState extends DeleteTransactionState {}

class TransactionDeletedSuccessfully extends DeleteTransactionState {}

class TransactionNotDeleted extends DeleteTransactionState {
  String errorMessage;
  TransactionNotDeleted({
    required this.errorMessage,
  });
}
