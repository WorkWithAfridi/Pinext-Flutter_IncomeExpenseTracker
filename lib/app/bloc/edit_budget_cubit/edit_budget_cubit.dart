import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:pinext/app/services/firebase_services.dart';
import 'package:pinext/app/services/handlers/user_handler.dart';

part 'edit_budget_state.dart';

class EditBudgetCubit extends Cubit<EditBudgetState> {
  EditBudgetCubit() : super(EditBudgetDefaultState());

  Future<void> updateBudgetAndMonthlyExpenses({required String monthlyBudget, required String amountSpentSoFar}) async {
    emit(EditBudgetLoadingState());
    await Future.delayed(const Duration(seconds: 1));
    var response = 'Error';

    try {
      await FirebaseServices().firebaseFirestore.collection('pinext_users').doc(UserHandler().currentUser.userId).update({
        'monthlyBudget': monthlyBudget,
        'monthlyExpenses': amountSpentSoFar,
      });
      response = 'Success';
    } on FirebaseException catch (err) {
      response = err.message.toString();
    } catch (err) {
      response = err.toString();
    }
    if (response == 'Success') {
      emit(EditBudgetSuccessState());
    } else {
      emit(EditBudgetErrorState(errorMessage: response));
    }
  }

  resetState() {
    emit(EditBudgetDefaultState());
  }
}
