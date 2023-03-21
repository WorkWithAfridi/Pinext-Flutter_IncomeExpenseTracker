import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pinext/app/models/pinext_goal_model.dart';
import 'package:pinext/app/services/handlers/goal_handler.dart';

part 'add_goal_state.dart';

class AddGoalCubit extends Cubit<AddGoalState> {
  AddGoalCubit() : super(AddGoalDefaultState());

  Future<void> addGoal(PinextGoalModel pinextGoalModel) async {
    emit(AddGoalLoadingState());
    await Future.delayed(const Duration(seconds: 1));
    await GoalHandler().addGoal(pinextGoalModel: pinextGoalModel);
    emit(AddGoalSuccessState());
  }

  Future<void> updateGoal(PinextGoalModel pinextGoalModel) async {
    emit(AddGoalLoadingState());
    emit(AddGoalLoadingState());
    log('At Goal Cubit');
    await GoalHandler().updateGoal(pinextGoalModel: pinextGoalModel);
    emit(UpdateGoalSuccessState());
  }

  Future<void> deleteGoal(PinextGoalModel pinextGoalModel) async {
    emit(AddGoalLoadingState());
    emit(AddGoalLoadingState());
    log('At Goal Cubit');
    await GoalHandler().deleteGoal(pinextGoalModel: pinextGoalModel);
    emit(DeleteGoalSuccessState());
  }
}
