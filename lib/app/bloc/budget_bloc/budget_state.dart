part of 'budget_bloc.dart';

abstract class BudgetState extends Equatable {
  const BudgetState();
  
  @override
  List<Object> get props => [];
}

class BudgetInitial extends BudgetState {}
