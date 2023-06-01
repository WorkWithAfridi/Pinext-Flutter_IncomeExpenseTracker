import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class PinextUserModel {
  String userId;
  String username;
  String emailAddress;
  String netBalance;
  String monthlyBudget;
  String monthlyExpenses;
  String dailyExpenses;
  String weeklyExpenses;
  String monthlySavings;
  String monthlyEarnings;
  String accountCreatedOn;
  String currentDate;
  String currentMonth;
  String currentWeekOfTheYear;
  String currentYear;
  String currencySymbol;
  PinextUserModel({
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
    required this.currencySymbol,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'userId': userId,
      'username': username,
      'emailAddress': emailAddress,
      'netBalance': netBalance,
      'monthlyBudget': monthlyBudget,
      'monthlyExpenses': monthlyExpenses,
      'monthlyEarnings': monthlyEarnings,
      'dailyExpenses': dailyExpenses,
      'weeklyExpenses': weeklyExpenses,
      'monthlySavings': monthlySavings,
      'accountCreatedOn': accountCreatedOn,
      'currentDate': currentDate,
      'currentMonth': currentMonth,
      'currentWeekOfTheYear': currentWeekOfTheYear,
      'currentYear': currentYear,
      'currency': currencySymbol,
    };
  }

  factory PinextUserModel.fromMap(Map<String, dynamic> map) {
    return PinextUserModel(
      userId: map['userId'] as String,
      username: map['username'] as String,
      emailAddress: map['emailAddress'] as String,
      netBalance: map['netBalance'] as String,
      monthlyBudget: map['monthlyBudget'] as String,
      monthlyExpenses: map['monthlyExpenses'] as String,
      dailyExpenses: map['dailyExpenses'] as String,
      weeklyExpenses: map['weeklyExpenses'] as String,
      monthlySavings: map['monthlySavings'] as String,
      accountCreatedOn: map['accountCreatedOn'] as String,
      currentDate: map['currentDate'] as String,
      currentMonth: map['currentMonth'] as String,
      currentWeekOfTheYear: map['currentWeekOfTheYear'] as String,
      currentYear: map['currentYear'] as String,
      monthlyEarnings: (map['monthlyEarnings'] ?? '0000') as String,
      currencySymbol: (map['currencySymbol'] ?? '৳') as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory PinextUserModel.fromJson(String source) => PinextUserModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'PinextUserModel(userId: $userId, username: $username, emailAddress: $emailAddress, netBalance: $netBalance, monthlyBudget: $monthlyBudget, monthlyExpenses: $monthlyExpenses, dailyExpenses: $dailyExpenses, weeklyExpenses: $weeklyExpenses, monthlySavings: $monthlySavings, monthlyEarnings: $monthlyEarnings, accountCreatedOn: $accountCreatedOn, currentDate: $currentDate, currentMonth: $currentMonth, currentWeekOfTheYear: $currentWeekOfTheYear, currentYear: $currentYear, currencySymbol: $currencySymbol)';
  }
}
