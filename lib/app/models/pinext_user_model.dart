import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class PinextUserModel {
  String userId;
  String username;
  String emailAddress;
  String netBalance;
  String monthlyBudget;
  String budgetSpentSoFar;
  PinextUserModel({
    required this.userId,
    required this.username,
    required this.emailAddress,
    required this.netBalance,
    required this.monthlyBudget,
    required this.budgetSpentSoFar,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'userId': userId,
      'username': username,
      'emailAddress': emailAddress,
      'netBalance': netBalance,
      'monthlyBudget': monthlyBudget,
      'budgetSpentSoFar': budgetSpentSoFar,
    };
  }

  factory PinextUserModel.fromMap(Map<String, dynamic> map) {
    return PinextUserModel(
      userId: map['userId'] as String,
      username: map['username'] as String,
      emailAddress: map['emailAddress'] as String,
      netBalance: map['netBalance'] as String,
      monthlyBudget: map['monthlyBudget'] as String,
      budgetSpentSoFar: map['budgetSpentSoFar'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory PinextUserModel.fromJson(String source) =>
      PinextUserModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'PinextUserModel(userId: $userId, username: $username, emailAddress: $emailAddress, netBalance: $netBalance, monthlyBudget: $monthlyBudget, budgetSpentSoFar: $budgetSpentSoFar)';
  }
}
