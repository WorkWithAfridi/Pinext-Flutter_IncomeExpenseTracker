// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'edit_budget_cubit.dart';

abstract class EditBudgetState extends Equatable {
  const EditBudgetState();

  @override
  List<Object> get props => [];
}

class EditBudgetDefaultState extends EditBudgetState {}

class EditBudgetLoadingState extends EditBudgetState {}

class EditBudgetSuccessState extends EditBudgetState {}

class EditBudgetErrorState extends EditBudgetState {
  String errorMessage;
  EditBudgetErrorState({
    required this.errorMessage,
  });
}
