import 'dart:async';
import 'package:teachme/models/category.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:teachme/models/profile.dart';
import 'package:teachme/models/teacher.dart';
import 'package:teachme/models/teacher_favorite.dart';
import 'package:teachme/models/user.dart';

class DatabaseService {
  final Firestore _db = Firestore.instance;
  final FirebaseMessaging _messaging = FirebaseMessaging();

  DatabaseService() {
    //_setup(user);
  }

  Future setup(String user) async {
    // Initializing different methods to manage
    // Push Notifications
    _messaging.configure(onMessage: (Map<String, dynamic> message) async {
      print("ON MESSAGE" + message.toString());
      final notification = message['notification'];
      //showNotification(notification['title'], notification['body']);
    }, onLaunch: (Map<String, dynamic> message) async {
      print("ON LAUNCH" + message.toString());
    }, onResume: (Map<String, dynamic> message) async {
      print("ON RESUME" + message.toString());
    });
    // Getting token from the user and saving
    var devToken = await _messaging.getToken();
    print("token del dispositivo  " + devToken);
    var newProfile = new Profile(devicetoken: devToken);
    updateCollection('users', newProfile.deviceTokenToJson(), user);
  }

  /// Get a stream of a single document
  Future<Profile> getProfile(String id) async {
    return _db
        .collection('users')
        .document(id)
        .get()
        .then((snap) => Profile.fromMap(snap.data, snap.documentID));
  }

  /// Get a stream of a single document
  Stream<Profile> streamProfile(String id) {
    return _db
        .collection('users')
        .document(id)
        .snapshots()
        .map((snap) => Profile.fromMap(snap.data, snap.documentID));
  }

  /// Save a new user with a [userID], [email], [photoUrl]
  /// and [userName] [firstName] [lastName]
  Future<void> createUserComplete(String userId, String email, String photoUrl,
      String firstName, String lastName) {
    return _db.collection('users').document(userId).setData({
      /* some data */
      "email": email,
      "photoUrl": photoUrl != null ? photoUrl : '',
      "status": 'active',
      "firstname": firstName,
      "lastname": lastName,
      "type": 'voclient'
    });
  }

  /// Save a new user with a [userID], [email], [photoUrl]
  /// and [userName] [fullName]
  Future<void> createUser(
      String userId, String email, String photoUrl, String fullName) {
    return _db.collection('users').document(userId).setData({
      /* some data */
      "email": email,
      "photoUrl": photoUrl != null ? photoUrl : '',
      "status": 'active',
      "firstname": fullName,
      "type": 'voclient'
    });
  }

  /// Method to manage the update of the collection
  /// [collectionName] witll all fields on
  /// [data] and their respective [id]
  Future<void> updateCollection(
    String collectionName,
    Map data,
    String id,
  ) async {
    var ref = _db.collection(collectionName);
    await ref.document(id).updateData(data);
    return;
  }

  /// Remove any item with [id] and
  /// from any [collection]
  Future<void> removeItem(String collection, String id) async {
    var ref = _db.collection(collection);
    await ref.document(id).delete();
    return;
  }

  ///Get the teacher list to the
  ///firebase database.
  Stream<List<Teacher>> getTeacherList(List<TeacherFavorite> favoriteList) {
    var ref = _db.collection("teachers");

    return ref.snapshots().map((list) {
      var teachList = list.documents
          .map(
            (doc) => Teacher.fromMap(doc.data, doc.documentID),
          )
          .toList();

      teachList.forEach((teach) {
        var _find = favoriteList.where((fav) => fav.teacher == teach.id);

        if (_find.isNotEmpty) {
          teach.isFavorite = true;
          teach.favoriteId = _find.first.id;
        } else {
          teach.isFavorite = false;
          teach.favoriteId = "";
        }
      });

      return teachList;
    });
  }

  ///Returns the favorite teacher
  ///for the user.
  Stream<List<TeacherFavorite>> getFavoriteTeacher(User user) {
    var ref =
        _db.collection("teacherfavorite").where("user", isEqualTo: user.uid);

    return ref.snapshots().map((list) => list.documents
        .map(
          (doc) => TeacherFavorite.fromMap(doc.data, doc.documentID),
        )
        .toList());
  }

  ///Get the favorite teacher list to the
  ///firebase database.
  Stream<List<Teacher>> getFavoriteTeacherList(
    List<TeacherFavorite> favoriteList,
  ) {
    var ref = _db.collection("teachers");

    return ref.snapshots().map((list) {
      var teachList = list.documents
          .map(
            (doc) => Teacher.fromMap(doc.data, doc.documentID),
          )
          .toList();
      List<Teacher> _finalList = new List<Teacher>();

      teachList.forEach((teach) {
        var _find = favoriteList.where((fav) => fav.teacher == teach.id);

        if (_find.isNotEmpty) {
          teach.isFavorite = true;
          teach.favoriteId = _find.first.id;

          _finalList.add(teach);
        }
      });

      return _finalList;
    });
  }

  ///Add a favorite teacher.
  Future<void> addFavoriteTeacher(String teacher, String user, String id) {
    return _db.collection('teacherfavorite').document(id).setData({
      "teacher": teacher,
      "user": user,
    });
  }

  ///Remove a favorite teacher.
  Future<void> removeFavorite(String id) {
    return _db.collection("teacherfavorite").document(id).delete();
  }

  ///Get the categories.
  Stream<List<Category>> getCategory() {
    var ref = _db.collection("category");

    return ref.snapshots().map((list) => list.documents
        .map((doc) => Category.fromMap(doc.data, doc.documentID))
        .toList());
  }

  ///Get teacher by category.
  Stream<List<Teacher>> getCategoryTeacher(
    String category,
    List<TeacherFavorite> favoriteList,
  ) {
    var ref =
        _db.collection("teachers").where("categories", arrayContains: category);

    return ref.snapshots().map((list) {
      var teachList = list.documents
          .map(
            (doc) => Teacher.fromMap(doc.data, doc.documentID),
          )
          .toList();

      teachList.forEach((teach) {
        var _find = favoriteList.where((fav) => fav.teacher == teach.id);

        if (_find.isNotEmpty) {
          teach.isFavorite = true;
          teach.favoriteId = _find.first.id;
        } else {
          teach.isFavorite = false;
          teach.favoriteId = "";
        }
      });

      return teachList;
    });
  }
}
