import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pinext/app/models/pinext_goal_model.dart';
import 'package:pinext/app/services/handlers/goal_handler.dart';

part 'add_goal_state.dart';

class AddGoalCubit extends Cubit<AddGoalState> {
  AddGoalCubit() : super(AddGoalDefaultState());
  addGoal(PinextGoalModel pinextGoalModel) async {
    emit(AddGoalLoadingState());
    log("At Goal Cubit");
    await GoalHandler().addGoal(pinextGoalModel: pinextGoalModel);
    emit(AddGoalSuccessState());
  }
}
