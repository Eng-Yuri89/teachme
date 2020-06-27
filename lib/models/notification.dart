

import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationMessage{
  String id;
  String title;
  String message;
  final Timestamp dateTime;
  String user;
  bool seen;

  NotificationMessage({this.id, this.title, this.message, this.dateTime, this.seen=false, this.user});

  factory NotificationMessage.fromMap(Map data, String id) {
    data = data ?? { };
    return NotificationMessage(
      id: id,
      dateTime: data['dateTime'] ?? Timestamp(0,0),
      title: data['title'] ?? '',
      message: data['message'] ?? '',
      user : data['user'] ?? '',
      seen : data['seen'] ?? false,
    );
  }
}