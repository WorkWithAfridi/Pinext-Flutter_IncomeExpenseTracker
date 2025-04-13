import 'package:pinext/app/models/pinext_goal_model.dart';
import 'package:pinext/app/services/firebase_services.dart';

class GoalHandler {
  factory GoalHandler() => _goalHandler;
  GoalHandler._internal();
  static final GoalHandler _goalHandler = GoalHandler._internal();

  Future addGoal({
    required PinextGoalModel pinextGoalModel,
  }) async {
    return FirebaseServices()
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
    return FirebaseServices()
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
    return FirebaseServices()
        .firebaseFirestore
        .collection('pinext_users')
        .doc(FirebaseServices().getUserId())
        .collection('pinext_goals')
        .doc(pinextGoalModel.id)
        .delete();
  }
}
