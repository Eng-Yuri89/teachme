import 'package:cloud_firestore/cloud_firestore.dart';

/// Message data base model.
class Message {
  Timestamp dateTime;
  String officeId;
  String issue;
  String message;
  String senderId;

  Message({this.dateTime, this.officeId, this.issue, this.message, this.senderId});

  factory Message.fromMap(Map<String, dynamic> map, String documentId) {
    return Message(
      dateTime : map["dateTime"] ?? Timestamp.fromDate(DateTime.now()),
      officeId : map["officeId"] ?? "",
      issue    : map["issue"] ?? "",
      message  : map["message"] ?? "", 
      senderId : map["senderId"] ?? ""
    );
  }
}