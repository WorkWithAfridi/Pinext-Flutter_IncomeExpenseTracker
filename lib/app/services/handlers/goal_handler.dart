import 'package:pinext/app/models/pinext_goal_model.dart';

import '../firebase_services.dart';

class GoalHandler {
  GoalHandler._internal();
  static final GoalHandler _goalHandler = GoalHandler._internal();
  factory GoalHandler() => _goalHandler;

  Future addGoal({
    required PinextGoalModel pinextGoalModel,
  }) async {
    return await FirebaseServices()
        .firebaseFirestore
        .collection('pinext_users')
        .doc(FirebaseServices().getUserId())
        .collection('pinext_goals')
        .doc(pinextGoalModel.id)
        .set(pinextGoalModel.toMap());
  }

  Future updateGoal({
    required PinextGoalModel pinextGoalModel,
  }) async {
    return await FirebaseServices()
        .firebaseFirestore
        .collection('pinext_users')
        .doc(FirebaseServices().getUserId())
        .collection('pinext_goals')
        .doc(pinextGoalModel.id)
        .update(pinextGoalModel.toMap());
  }

  Future deleteGoal({
    required PinextGoalModel pinextGoalModel,
  }) async {
    return await FirebaseServices()
        .firebaseFirestore
        .collection('pinext_users')
        .doc(FirebaseServices().getUserId())
        .collection('pinext_goals')
        .doc(pinextGoalModel.id)
        .delete();
  }
}
