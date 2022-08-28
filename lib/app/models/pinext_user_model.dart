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
  String accountCreatedOn;
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
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'userId': userId,
      'username': username,
      'emailAddress': emailAddress,
      'netBalance': netBalance,
      'monthlyBudget': monthlyBudget,
      'monthlyExpenses': monthlyExpenses,
      'dailyExpenses': dailyExpenses,
      'weeklyExpenses': weeklyExpenses,
      'monthlySavings': monthlySavings,
      'accountCreatedOn': accountCreatedOn,
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
    );
  }

  String toJson() => json.encode(toMap());

  factory PinextUserModel.fromJson(String source) => PinextUserModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'PinextUserModel(userId: $userId, username: $username, emailAddress: $emailAddress, netBalance: $netBalance, monthlyBudget: $monthlyBudget, monthlyExpenses: $monthlyExpenses, dailyExpenses: $dailyExpenses, weeklyExpenses: $weeklyExpenses, monthlySavings: $monthlySavings, accountCreatedOn: $accountCreatedOn)';
  }

  @override
  bool operator ==(covariant PinextUserModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.userId == userId &&
      other.username == username &&
      other.emailAddress == emailAddress &&
      other.netBalance == netBalance &&
      other.monthlyBudget == monthlyBudget &&
      other.monthlyExpenses == monthlyExpenses &&
      other.dailyExpenses == dailyExpenses &&
      other.weeklyExpenses == weeklyExpenses &&
      other.monthlySavings == monthlySavings &&
      other.accountCreatedOn == accountCreatedOn;
  }

  @override
  int get hashCode {
    return userId.hashCode ^
      username.hashCode ^
      emailAddress.hashCode ^
      netBalance.hashCode ^
      monthlyBudget.hashCode ^
      monthlyExpenses.hashCode ^
      dailyExpenses.hashCode ^
      weeklyExpenses.hashCode ^
      monthlySavings.hashCode ^
      accountCreatedOn.hashCode;
  }
}
