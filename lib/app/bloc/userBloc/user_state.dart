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
  String monthlyEarnings;
  String regionCode;
  bool isLoading;

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
    required this.monthlyEarnings,
    required this.regionCode,
    this.isLoading = false,
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
        monthlyEarnings,
        regionCode,
        isLoading,
      ];

  AuthenticatedUserState copyWith({
    String? userId,
    String? username,
    String? emailAddress,
    String? netBalance,
    String? monthlyBudget,
    String? monthlyExpenses,
    String? dailyExpenses,
    String? weeklyExpenses,
    String? monthlySavings,
    String? accountCreatedOn,
    String? currentDate,
    String? currentMonth,
    String? currentWeekOfTheYear,
    String? currentYear,
    String? monthlyEarnings,
    String? regionCode,
    bool? isLoading,
  }) {
    return AuthenticatedUserState(
      userId: userId ?? this.userId,
      username: username ?? this.username,
      emailAddress: emailAddress ?? this.emailAddress,
      netBalance: netBalance ?? this.netBalance,
      monthlyBudget: monthlyBudget ?? this.monthlyBudget,
      monthlyExpenses: monthlyExpenses ?? this.monthlyExpenses,
      dailyExpenses: dailyExpenses ?? this.dailyExpenses,
      weeklyExpenses: weeklyExpenses ?? this.weeklyExpenses,
      monthlySavings: monthlySavings ?? this.monthlySavings,
      accountCreatedOn: accountCreatedOn ?? this.accountCreatedOn,
      currentDate: currentDate ?? this.currentDate,
      currentMonth: currentMonth ?? this.currentMonth,
      currentWeekOfTheYear: currentWeekOfTheYear ?? this.currentWeekOfTheYear,
      currentYear: currentYear ?? this.currentYear,
      monthlyEarnings: monthlyEarnings ?? this.monthlyEarnings,
      regionCode: regionCode ?? this.regionCode,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
