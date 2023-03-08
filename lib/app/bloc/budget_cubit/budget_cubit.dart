import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'budget_state.dart';

class BudgetCubit extends Cubit<BudgetState> {
  BudgetCubit()
      : super(
          BudgetDefault(
            paidAmount: 0,
            dueAmount: 0,
          ),
        );
  void updatePaidAmount(double amount) {
    final paidAmount = state.paidAmount + amount;
    emit(
      BudgetDefault(
        paidAmount: paidAmount,
        dueAmount: state.dueAmount,
      ),
    );
  }

  void updateDueAmount(double amount) {
    final dueAmount = state.dueAmount + amount;
    emit(
      BudgetDefault(
        paidAmount: state.paidAmount,
        dueAmount: dueAmount,
      ),
    );
  }

  void resetSubscriptionDetailCount() {
    emit(
      BudgetDefault(
        paidAmount: 0,
        dueAmount: 0,
      ),
    );
  }
}
