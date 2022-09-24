import 'dart:developer';

import 'package:pinext/app/models/pinext_goal_model.dart';

import '../firebase_services.dart';

class GoalHandler {
  GoalHandler._internal();
  static final GoalHandler _cardServices = GoalHandler._internal();
  factory GoalHandler() => _cardServices;

  Future addGoal({
    required PinextGoalModel pinextGoalModel,
  }) async {
    log("At Goal Handler");
    return await FirebaseServices()
        .firebaseFirestore
        .collection('pinext_users')
        .doc(FirebaseServices().getUserId())
        .collection('pinext_goals')
        .doc(pinextGoalModel.id)
        .set(pinextGoalModel.toMap());
  }
}
