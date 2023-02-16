part of 'user_statistics_cubit.dart';

abstract class UserStatisticsState extends Equatable {
  UserStatisticsState({
    required this.totalExpenses,
    required this.totalSavings,
    required this.outcome,
    required this.noDataFound,
  });
  double totalExpenses;
  double totalSavings;
  double outcome;
  bool noDataFound;

  @override
  List<Object> get props => [
        totalExpenses,
        totalSavings,
        outcome,
        noDataFound,
      ];
}

class UserStatisticsDefaultState extends UserStatisticsState {
  UserStatisticsDefaultState({
    required super.totalExpenses,
    required super.totalSavings,
    required super.outcome,
    required super.noDataFound,
  });
}
