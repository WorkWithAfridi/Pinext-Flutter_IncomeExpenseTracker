import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class PinextCardModel {
  String cardId;
  String title;
  String description;
  double balance;
  String color;
  String lastTransactionData;
  PinextCardModel({
    required this.cardId,
    required this.title,
    required this.description,
    required this.balance,
    required this.color,
    required this.lastTransactionData,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'cardId': cardId,
      'title': title,
      'description': description,
      'balance': balance,
      'color': color,
      'lastTransactionData': lastTransactionData,
    };
  }

  factory PinextCardModel.fromMap(Map<String, dynamic> map) {
    return PinextCardModel(
      cardId: map['cardId'] as String,
      title: map['title'] as String,
      description: map['description'] as String,
      balance: map['balance'] as double,
      color: map['color'] as String,
      lastTransactionData: map['lastTransactionData'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory PinextCardModel.fromJson(String source) =>
      PinextCardModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'PinextCardModel(cardId: $cardId, title: $title, description: $description, balance: $balance, color: $color, lastTransactionData: $lastTransactionData)';
  }
}
