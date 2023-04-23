import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pinext/app/models/pinext_card_model.dart';
import 'package:pinext/app/models/pinext_transaction_model.dart';
import 'package:pinext/app/services/handlers/transaction_handler.dart';

part 'delete_transaction_state.dart';

class DeleteTransactionCubit extends Cubit<DeleteTransactionState> {
  DeleteTransactionCubit() : super(DeleteTransactionDefaultState());

  void onResetState() {
    emit(DeleteTransactionDefaultState());
  }

  Future<void> deleteTransaction({
    required PinextTransactionModel transactionModel,
    PinextCardModel? cardModel,
  }) async {
    final response = await TransactionHandler().deleteTransaction(
      transactionModel,
      cardModel,
    );
    if (response == 'Success') {
      emit(
        TransactionDeletedSuccessfully(),
      );
    } else {
      emit(
        TransactionNotDeleted(
          errorMessage: response,
        ),
      );
    }
  }
}
