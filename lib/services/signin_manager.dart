import 'dart:async';
import 'dart:wasm';
import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';
import 'package:teachme/models/user.dart';
import 'package:teachme/services/auth_service.dart';
import 'package:teachme/services/db.dart';

class SignInManager {
  SignInManager(
      {@required this.auth,
      @required this.isLoading,
      this.codeSent,
      this.db,
      this.verificationId});
  final AuthService auth;
  final ValueNotifier<bool> isLoading;
  final ValueNotifier<bool> codeSent;
  final DatabaseService db;
  String verificationId;

  Future<User> _signIn(Future<User> Function() signInMethod) async {
    try {
      isLoading.value = true;
      // Waiting while we create the new Firestore user and the new office configuration.
      User userLogged = await signInMethod();
      if (userLogged != null) {
        await _createFirestoreUser(userLogged.uid, userLogged.email,
            userLogged.photoUrl, userLogged.displayName);
      }

      return userLogged;
    } catch (e) {
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  Future<User> signInAnonymously() async {
    return await _signIn(auth.signInAnonymously);
  }

  Future<void> signInWithGoogle() async {
    return await _signIn(auth.signInWithGoogle);
  }

  Future<void> signInWithFacebook() async {
    return await _signIn(auth.signInWithFacebook);
  }

  Future<User> signInWithEmailAndPassword(String email, String password) async {
    try {
      isLoading.value = true;

      User userLogged = await auth.signInWithEmailAndPassword(email, password);
      await db.setup(userLogged.uid);
      return userLogged;
    } catch (e) {
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> verifyPhoneNumber(String phoneNumber) async {
    // At this moment only GT support, then this code
    // should from parameters
    final String areaCode = '+502';
    try {
      await auth.verifyPhoneNumber(areaCode + phoneNumber, (String verId,
          [int forceCodeResend]) {
        isLoading.value = true;
        // TODO replace by codeSent value notifier
        this.verificationId = verId;
      });
    } catch (e) {
      rethrow;
    }
  }

  Future<User> signInWithPhoneNumber(String otp) async {
    try {
      isLoading.value = true;
      User userLogged = await auth.signInWithPhoneNumber(verificationId, otp);
      await db.setup(userLogged.uid);
      return userLogged;
    } catch (e) {
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  /// Creating a new user with [email] and [password]
  /// further with add the [username] on Cloud Firestore
  Future<User> createUserWithEmailAndPassword(
      String email, String password, String firstName, String lastName) async {
    try {
      isLoading.value = true;
      User _user = await auth.createUserWithEmailAndPassword(email, password);
      // Waiting while we create the new Firestore user and the new office configuration.
      await _createFirestoreUserComplete(
          _user.uid, _user.email, _user.photoUrl, firstName, lastName);

      return _user;
    } catch (e) {
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  Future<Void> _createFirestoreUserComplete(String id, String email,
      String photoUrl, String firstName, String lastName) async {
    // Proccesing the new Firestore user
    await db.createUserComplete(id, email, photoUrl, firstName, lastName);
    // Saving device token and initialize pushnotifications methods, on resume
    // onmessage, onload
    await db.setup(id);
    return null;
  }

  Future<Void> _createFirestoreUser(
      String id, String email, String photoUrl, String fullName) async {
    // Proccesing the new Firestore user
    await db.createUser(id, email, photoUrl, fullName);
    // Saving device token and initialize pushnotifications methods, on resume
    // onmessage, onload
    await db.setup(id);
    return null;
  }

  Future<void> sendPasswordResetEmail(String email) async {
    try {
      isLoading.value = true;
      return await auth.sendPasswordResetEmail(email);
    } catch (e) {
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }
}
