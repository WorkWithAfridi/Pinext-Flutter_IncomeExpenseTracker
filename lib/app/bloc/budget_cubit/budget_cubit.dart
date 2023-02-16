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
  updatePaidAmount(double amount) {
    double paidAmount = state.paidAmount + amount;
    emit(
      BudgetDefault(
        paidAmount: paidAmount,
        dueAmount: state.dueAmount,
      ),
    );
  }

  updateDueAmount(double amount) {
    double dueAmount = state.dueAmount + amount;
    emit(
      BudgetDefault(
        paidAmount: state.paidAmount,
        dueAmount: dueAmount,
      ),
    );
  }
}
