import 'package:cloud_firestore/cloud_firestore.dart';

/// Teacher data base model.
class Teacher {
  final String id;
  final String email;
  final String fullname;
  final String resume;
  final String phoneNumber;
  final String photoUrl;
  final String description;
  bool isFavorite;
  String favoriteId;

  Teacher({
    this.id,
    this.email,
    this.fullname,
    this.phoneNumber,
    this.photoUrl,
    this.description,
    this.resume,
  });

  factory Teacher.fromMap(Map<String, dynamic> map, String documentID) {
    final data = map ?? {};

    return Teacher(
      id: documentID ?? "",
      email: data["email"] ?? "",
      fullname: data["fullname"] ?? "",
      phoneNumber: data["phoneNumber"] ?? "",
      photoUrl: data["photoUrl"] ?? "",
      description: data["description"] ?? "",
      resume: data["resume"] ?? "",
    );
  }
}
