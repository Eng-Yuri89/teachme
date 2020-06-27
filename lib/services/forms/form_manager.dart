import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';
import 'package:teachme/services/auth_service.dart';
import 'package:teachme/services/db.dart';
import '../firebase_storage_service.dart';
import '../firestore_service.dart';
import 'package:teachme/models/message.dart';
import 'package:uuid/uuid.dart';

class FormManager {
  FormManager(
      {@required this.auth,
      @required this.isLoading,
      this.db,
      this.storage,
      this.database});

  final AuthService auth;
  final ValueNotifier<bool> isLoading;
  final DatabaseService db;
  final FirebaseStorageService storage;
  final FirestoreService database;

  /// Creating a new message with [dateTime], [officeId]
  /// [issue], [message] and [senderId]
  Future<void> createMessage(Message message) async {
    try {
      isLoading.value = true;

      // Waiting while we create the new Firestore message
      await _createFirestoreMessage(message, new Uuid().v1());
    } catch (e) {
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  /// Internal method to save the new Message
  /// to Cloud Firestore database
  Future<void> _createFirestoreMessage(
      Message message, String messageId) async {
    // Proccesing the new Firestore user
    return await db.createMessage(message, messageId);
  }
}
