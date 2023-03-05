import 'dart:convert';

class PinextSubscriptionModel {
  PinextSubscriptionModel({
    required this.dateAdded,
    required this.lastPaidOn,
    required this.amount,
    required this.subscriptionId,
    required this.assignedCardId,
    required this.automaticallyDeductEnabled,
    required this.description,
    required this.title,
    required this.transactionId,
  });
  factory PinextSubscriptionModel.fromJson(String source) => PinextSubscriptionModel.fromMap(json.decode(source) as Map<String, dynamic>);

  factory PinextSubscriptionModel.fromMap(Map<String, dynamic> map) {
    return PinextSubscriptionModel(
      dateAdded: map['dateAdded'] as String,
      lastPaidOn: map['lastPaidOn'] as String,
      amount: map['amount'] as String,
      subscriptionId: map['subscriptionId'] as String,
      assignedCardId: map['assignedCardId'] as String,
      automaticallyDeductEnabled: map['automaticallyDeductEnabled'] as bool,
      description: map['description'] as String,
      title: map['title'] as String,
      transactionId: (map['transactionId'] ?? '') as String,
    );
  }
  String dateAdded;
  String lastPaidOn;
  String amount;
  String subscriptionId;
  String assignedCardId;
  bool automaticallyDeductEnabled;
  String description;
  String title;
  String transactionId;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'dateAdded': dateAdded,
      'lastPaidOn': lastPaidOn,
      'amount': amount,
      'subscriptionId': subscriptionId,
      'assignedCardId': assignedCardId,
      'automaticallyDeductEnabled': automaticallyDeductEnabled,
      'description': description,
      'title': title,
      'transactionId': transactionId,
    };
  }

  String toJson() => json.encode(toMap());

  @override
  String toString() {
    return 'PinextSubscriptionModel(dateAdded: $dateAdded, lastPaidOn: $lastPaidOn, transactionId: $transactionId,  amount: $amount, subscriptionId: $subscriptionId, assignedCardId: $assignedCardId, automaticallyDeductEnabled: $automaticallyDeductEnabled, description: $description, title: $title)';
  }
}
