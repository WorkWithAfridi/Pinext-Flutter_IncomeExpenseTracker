// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'edit_net_balance_cubit.dart';

abstract class EditNetBalanceState extends Equatable {
  const EditNetBalanceState();

  @override
  List<Object> get props => [];
}

class EditNetBalanceDefaultState extends EditNetBalanceState {}

class EditNetBalanceLoadingState extends EditNetBalanceState {}

class EditNetBalanceSuccessState extends EditNetBalanceState {}

class EditNetBalanceErrorState extends EditNetBalanceState {
  String errorMessage;
  EditNetBalanceErrorState({
    required this.errorMessage,
  });
}
