part of 'add_goal_cubit.dart';

abstract class AddGoalState extends Equatable {
  const AddGoalState();

  @override
  List<Object> get props => [];
}

class AddGoalDefaultState extends AddGoalState {}

class AddGoalLoadingState extends AddGoalState {}

class AddGoalErrorState extends AddGoalState {}

class AddGoalSuccessState extends AddGoalState {}

class UpdateGoalSuccessState extends AddGoalState {}
class DeleteGoalSuccessState extends AddGoalState {}
