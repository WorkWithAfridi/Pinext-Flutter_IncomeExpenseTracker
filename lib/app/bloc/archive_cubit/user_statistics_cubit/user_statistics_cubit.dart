import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'user_statistics_state.dart';

class UserStatisticsCubit extends Cubit<UserStatisticsState> {
  UserStatisticsCubit()
      : super(
          UserStatisticsDefaultState(
            totalExpenses: 0,
            totalSavings: 0,
            outcome: 0,
          ),
        );

  updateStatistics({
    required double amount,
    required isExpense,
  }) {
    double totalExpenses = 0;
    double totalSavings = 0;
    double outcome = 0;
    if (isExpense) {
      totalExpenses = state.totalExpenses + amount;
      totalSavings = state.totalSavings;
    } else {
      totalSavings = state.totalSavings + amount;
      totalExpenses = state.totalExpenses;
    }
    outcome = totalSavings - totalExpenses;
    emit(UserStatisticsDefaultState(
      totalExpenses: totalExpenses,
      totalSavings: totalSavings,
      outcome: outcome,
    ));
  }

  resetState() {
    emit(
      UserStatisticsDefaultState(
        totalExpenses: 0,
        totalSavings: 0,
        outcome: 0,
      ),
    );
  }
}
