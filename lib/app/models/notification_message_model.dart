import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first

class NotificationMessageModel {
  bool showAlert;
  String alertMessage;
  String alertTitle;
  String id;
  NotificationMessageModel({
    required this.showAlert,
    required this.alertMessage,
    required this.alertTitle,
    required this.id,
  });

  NotificationMessageModel copyWith({
    bool? showAlert,
    String? alertMessage,
    String? alertTitle,
    String? id,
  }) {
    return NotificationMessageModel(
      showAlert: showAlert ?? this.showAlert,
      alertMessage: alertMessage ?? this.alertMessage,
      alertTitle: alertTitle ?? this.alertTitle,
      id: id ?? this.id,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'showAlert': showAlert,
      'alertMessage': alertMessage,
      'alertTitle': alertTitle,
      'id': id,
    };
  }

  factory NotificationMessageModel.fromMap(Map<String, dynamic> map) {
    return NotificationMessageModel(
      showAlert: map['showAlert'] as bool,
      alertMessage: map['alertMessage'] as String,
      alertTitle: map['alertTitle'] as String,
      id: map['id'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory NotificationMessageModel.fromJson(String source) => NotificationMessageModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'NotificationMessageModel(showAlert: $showAlert, alertMessage: $alertMessage, alertTitle: $alertTitle, id: $id)';
  }

  @override
  bool operator ==(covariant NotificationMessageModel other) {
    if (identical(this, other)) return true;

    return other.showAlert == showAlert && other.alertMessage == alertMessage && other.alertTitle == alertTitle && other.id == id;
  }

  @override
  int get hashCode {
    return showAlert.hashCode ^ alertMessage.hashCode ^ alertTitle.hashCode ^ id.hashCode;
  }
}
