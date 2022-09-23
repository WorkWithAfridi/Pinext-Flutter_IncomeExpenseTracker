import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class PinextGoalModel {
  String title;
  String amount;
  String description;
  String id;
  PinextGoalModel({
    required this.title,
    required this.amount,
    required this.description,
    required this.id,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      'amount': amount,
      'description': description,
      'id': id,
    };
  }

  factory PinextGoalModel.fromMap(Map<String, dynamic> map) {
    return PinextGoalModel(
      title: map['title'] as String,
      amount: map['amount'] as String,
      description: map['description'] as String,
      id: map['id'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory PinextGoalModel.fromJson(String source) =>
      PinextGoalModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
