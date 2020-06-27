import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:teachme/models/profile_picture.dart';
import 'package:teachme/services/firestore_path.dart';

class FirestoreService {
  // Sets the avatar download url
  Future<void> setPictureReference(
      {@required String id,
      @required Picture avatarReference,
      @required String type}) async {
    final path = FirestorePath.getPath(type, id);
    final reference = Firestore.instance.document(path);
    await reference.setData(avatarReference.toMap());
  }

  // Reads the current avatar download url
  Stream<Picture> avatarReferenceStream({
    @required String uid,
  }) {
    final path = FirestorePath.avatar(uid);
    final reference = Firestore.instance.document(path);
    final snapshots = reference.snapshots();
    return snapshots.map((snapshot) => Picture.fromMap(snapshot.data));
  }
}
