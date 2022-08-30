// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'user_bloc.dart';

abstract class UserState extends Equatable {
  const UserState();

  @override
  List<Object> get props => [];
}

class UnauthenticatedUserState extends UserState {}

class AuthenticatedUserState extends UserState {
  String userId;
  String username;
  String emailAddress;
  String netBalance;
  String monthlyBudget;
  String monthlyExpenses;
  String dailyExpenses;
  String weeklyExpenses;
  String monthlySavings;
  String accountCreatedOn;
  String currentDate;
  String currentMonth;
  String currentWeekOfTheYear;
  String currentYear;
  AuthenticatedUserState({
    required this.userId,
    required this.username,
    required this.emailAddress,
    required this.netBalance,
    required this.monthlyBudget,
    required this.monthlyExpenses,
    required this.dailyExpenses,
    required this.weeklyExpenses,
    required this.monthlySavings,
    required this.accountCreatedOn,
    required this.currentDate,
    required this.currentMonth,
    required this.currentWeekOfTheYear,
    required this.currentYear,
  });

  @override
  List<Object> get props => [
        userId,
        username,
        emailAddress,
        netBalance,
        monthlyBudget,
        monthlyExpenses,
        dailyExpenses,
        weeklyExpenses,
        monthlySavings,
        accountCreatedOn,
        currentDate,
        currentMonth,
        currentWeekOfTheYear,
        currentYear,
      ];
}
