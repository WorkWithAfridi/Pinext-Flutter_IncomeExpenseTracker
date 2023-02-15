import 'dart:convert';

class PinextSubscriptionModel {
  String dateAdded;
  String lastPaidOn;
  String amount;
  String subscriptionId;
  String assignedCardId;
  bool automaticallyDeductEnabled;
  String description;
  String title;
  PinextSubscriptionModel({
    required this.dateAdded,
    required this.lastPaidOn,
    required this.amount,
    required this.subscriptionId,
    required this.assignedCardId,
    required this.automaticallyDeductEnabled,
    required this.description,
    required this.title,
  });

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
    };
  }

  factory PinextSubscriptionModel.fromMap(Map<String, dynamic> map) {
    return PinextSubscriptionModel(
      dateAdded: map['dateAdded'] as String,
      lastPaidOn: map['lastPaidOn'] as String,
      amount: map['amount'] as String,
      subscriptionId: map['subscriptionId'] as String,
      assignedCardId: map['assignedCardId'] as String,
      automaticallyDeductEnabled: map['automaticallyDeductEnabled'],
      description: map['description'] as String,
      title: map['title'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory PinextSubscriptionModel.fromJson(String source) =>
      PinextSubscriptionModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'PinextSubscriptionModel(dateAdded: $dateAdded, lastPaidOn: $lastPaidOn, amount: $amount, subscriptionId: $subscriptionId, assignedCardId: $assignedCardId, automaticallyDeductEnabled: $automaticallyDeductEnabled, description: $description, title: $title)';
  }
}
