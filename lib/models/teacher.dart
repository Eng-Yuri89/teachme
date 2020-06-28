import 'package:cloud_firestore/cloud_firestore.dart';

/// Teacher data base model.
class Teacher {
  final String id;
  final String email;
  final String fullname;
  final String phoneNumber;
  final String photoUrl;
  final String description;

  Teacher({
    this.id,
    this.email,
    this.fullname,
    this.phoneNumber,
    this.photoUrl,
    this.description,
  });

  factory Teacher.fromMap(Map<String, dynamic> map, String documentID) {
    final data = map ?? {};

    return Teacher(
      id: data["id"] ?? "",
      email: data["email"] ?? "",
      fullname: data["firstName"] ?? "",
      phoneNumber: data["phoneNumber"] ?? "",
      photoUrl: data["photoUrl"] ?? "",
      description: data["description"] ?? "",
    );
  }
}
