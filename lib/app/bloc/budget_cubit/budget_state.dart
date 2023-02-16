// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'budget_cubit.dart';

abstract class BudgetState extends Equatable {
  double paidAmount;
  double dueAmount;
  BudgetState({
    required this.paidAmount,
    required this.dueAmount,
  });

  @override
  List<Object> get props => [
        paidAmount,
        dueAmount,
      ];
}

class BudgetDefault extends BudgetState {
  BudgetDefault({required super.paidAmount, required super.dueAmount});
}
