import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class PinextTransactionModel {
  String transactionType;
  String amount;
  String details;
  String cardId;
  String transactionDate;
  String transactionId;
  PinextTransactionModel({
    required this.transactionType,
    required this.amount,
    required this.details,
    required this.cardId,
    required this.transactionDate,
    required this.transactionId,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'transactionType': transactionType,
      'amount': amount,
      'details': details,
      'cardId': cardId,
      'transactionDate': transactionDate,
      'transactionId': transactionId,
    };
  }

  factory PinextTransactionModel.fromMap(Map<String, dynamic> map) {
    return PinextTransactionModel(
      transactionType: map['transactionType'] as String,
      amount: map['amount'] as String,
      details: map['details'] as String,
      cardId: map['cardId'] as String,
      transactionDate: map['transactionDate'] as String,
      transactionId: map['transactionId'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory PinextTransactionModel.fromJson(String source) =>
      PinextTransactionModel.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'PinextTransactionModel(transactionType: $transactionType, amount: $amount, details: $details, cardId: $cardId, transactionDate: $transactionDate, transactionId: $transactionId)';
  }
}
