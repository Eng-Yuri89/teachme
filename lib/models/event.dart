import 'package:cloud_firestore/cloud_firestore.dart';

/// Event data base model.
class Event {
  final Timestamp startDateTime;
  final Timestamp endDateTime;
  final String eventName;
  final String description;
  final String officeID;
  final String location;
  final String eventImageUrl;
  String status;

  Event({this.startDateTime, this.endDateTime, this.eventName, this.description, this.officeID, this.location, this.eventImageUrl, this.status});

  factory Event.fromMap(Map<String, dynamic> map, String documentID) {
    final data = map ?? {};

    return Event(
      startDateTime: data["dateTime"] ?? Timestamp(10, 10),
      endDateTime: data["endDateTime"] ?? Timestamp(10, 10),
      eventName: data["eventName"] ?? "",
      description: data["description"] ?? "",
      officeID: data["officeID"] ?? "",
      location: data["location"] ?? "",
      eventImageUrl: data["eventImageUrl"] ?? "",
      status: data["status"] ?? ""
    );
  }
}