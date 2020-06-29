import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:teachme/models/action_package.dart';
import 'package:teachme/models/category.dart';
import 'package:teachme/models/issue_message.dart';
import 'package:queries/collections.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:teachme/models/event.dart';
import 'package:teachme/models/mail.dart';
import 'package:teachme/models/notification.dart';
import 'package:teachme/models/office.dart';
import 'package:teachme/models/profile.dart';
import 'package:teachme/models/message.dart';
import 'package:teachme/models/status.dart';
import 'package:teachme/models/teacher.dart';
import 'package:teachme/models/teacher_favorite.dart';
import 'package:teachme/models/user.dart';
import 'package:teachme/models/voclients.dart';
import 'package:uuid/uuid.dart';

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

  /// Query a subcollection
  Stream<List<Mail>> streamMails(String officeID) {
    var ref = _db.collection('mails').where("office", isEqualTo: officeID);
    return ref.snapshots().map((list) => list.documents
        .map((doc) => Mail.fromMap(doc.data, doc.documentID))
        .toList());
  }

  /// Query a subcollection
  Stream<List<Mail>> streamMailsByRecents(
      Timestamp startDay, Timestamp endDay) {
    var ref = _db
        .collection('mails')
        .where("dateTime", isGreaterThan: startDay)
        .where("dateTime", isLessThan: endDay);
    return ref.snapshots().map((list) => list.documents
        .map((doc) => Mail.fromMap(doc.data, doc.documentID))
        .toList());
  }

  /// Query a subcollection
  Stream<List<Mail>> streamMailsByStatus(String status) {
    var ref = _db.collection('mails').where("status", isEqualTo: status);
    return ref.snapshots().map((list) => list.documents
        .map((doc) => Mail.fromMap(doc.data, doc.documentID))
        .toList());
  }

  /// Get a stream of a single document
  Future<Office> getMyOffice(String userID) async {
    return _db
        .collection('offices')
        .document(userID)
        .get()
        .then((snap) => Office.fromMap(snap.data, snap.documentID));
  }

  /// Query a subcollection
  Stream<List<NotificationMessage>> streamNotifications(String userID) {
    var ref = _db.collection('notifications').where("user", isEqualTo: userID);
    return ref.snapshots().map((list) => list.documents
        .map((doc) => NotificationMessage.fromMap(doc.data, doc.documentID))
        .toList());
  }

  /// Remove any item with [id] and
  /// from any [collection]
  Future<void> removeItem(String collection, String id) async {
    var ref = _db.collection(collection);
    await ref.document(id).delete();
    return;
  }

  /// Returns the stream of the packages lis of the mail.
  Stream<List<Package>> getPackagesMailStream(String mailID) {
    var ref = _db.collection("packages").where("mailID", isEqualTo: mailID);

    return ref.snapshots().map((list) => list.documents
        .map((doc) => Package.fromMap(doc.data, doc.documentID))
        .toList());
  }

  /// Query a subcollection
  Stream<List<Event>> streamEvents(String officeID) {
    var ref =
        _db.collection('events') /* .where("office", isEqualTo: officeID) */;
    return ref.snapshots().map((list) => list.documents
        .map((doc) => Event.fromMap(doc.data, doc.documentID))
        .toList());
  }

  /// Save a new Message with a [dateTime], [officeId]
  /// [issue], [message] and [senderId]
  Future<void> createMessage(Message message, String messageId) {
    return _db.collection('messages').document(messageId).setData({
      "dateTime": message.dateTime,
      "officeId": message.officeId,
      "issue": message.issue,
      "message": message.message,
      "senderId": message.senderId
    });
  }

  /// Query a subcollection
  Stream<List<VOClients>> streamVOClients(String email) {
    if (email != null) {
      var ref = _db.collection('voclients').where("email", isEqualTo: email);
      final list = ref.snapshots().map((list) => list.documents
          .map((doc) => VOClients.fromMap(doc.data, doc.documentID))
          .toList());

      return list;
    }

    return new Stream.empty();
  }

  /// Get the mail by offices
  Stream<List<Mail>> getMailByOficess(List<VOClients> listOffices) {
    // Owner id's list.
    List<String> _idList = new List<String>();

    listOffices.forEach((office) {
      _idList.add(office.id);
    });

    var ref = _db.collection("mails").where("owner", whereIn: _idList);

    final _list = ref.snapshots().map((list) => list.documents
        .map((mail) => Mail.fromMap(mail.data, mail.documentID))
        .toList());

    return _list;
  }

  /// Returns the list of events by user offices.
  Stream<List<Event>> getEventsByOffices(List<VOClients> offices) {
    // Office id's list.
    List<String> _idList = new List<String>();

    offices.forEach((office) {
      _idList.add(office.office);
    });

    var ref = _db.collection('events').where("officeID", whereIn: _idList);
    return ref.snapshots().map((list) => list.documents
        .map((doc) => Event.fromMap(doc.data, doc.documentID))
        .toList());
  }

  /// Returns the states based on the item that requires it.
  Stream<List<Status>> getStreamStatus({bool isForEvent}) {
    var ref = _db.collection(isForEvent ? "eventstatus" : "mailstatus");

    return ref.snapshots().map((list) =>
        list.documents.map((doc) => Status.fromMap(doc.data)).toList());
  }

  /// Retruns the office to the filter.
  Stream<Map<String, String>> getOfficeFilter(List<VOClients> officeList) {
    if (officeList != null) {
      var ref = _db.collection("offices");

      final _listFuture = ref.snapshots().map((list) {
        List<Office> _listOffice = new List<Office>();
        Map<String, String> _finalList = {"": ""};

        final _listUnfilter = list.documents
            .map((doc) => Office.fromMap(doc.data, doc.documentID))
            .toList();

        officeList.forEach((off) {
          final _listFilter = _listUnfilter
              .where(
                  (office) => office.owner == off.office && office.name != "")
              .toList();

          _listOffice.addAll(_listFilter);
        });

        _listOffice.sort((a, b) => a.name.compareTo(b.name));

        _listOffice.forEach((of) {
          if (_finalList[of.name] == null) {
            _finalList.addAll({of.name: of.id});
          }
        });

        return _finalList;
      });

      return _listFuture;
    }

    return Stream.empty();
  }

  /// Returns the issue message's
  Stream<List<IssueMessage>> getIssueMessage() {
    var ref = _db.collection("issueoptions");

    return ref.snapshots().map(
      (list) {
        List<IssueMessage> _issueList = new List<IssueMessage>();

        _issueList.add(new IssueMessage(issue: ""));

        final _dbList = list.documents
            .map((doc) => IssueMessage.fromMap(doc.data))
            .toList();

        _issueList.addAll(_dbList);
        _issueList.sort((a, b) => a.issue.compareTo(b.issue));

        return _issueList;
      },
    );
  }

  /// Returns the message
  Stream<Map<int, String>> getActionPackage() {
    var ref = _db.collection("handleoptions");

    return ref.snapshots().map(
      (list) {
        Map<int, String> _actionMap = {};
        final _dbList = list.documents
            .map((doc) => HandleOption.fromMap(doc.data))
            .toList();
        int count = 1;

        _actionMap.addAll({0: ""});

        _dbList.sort((a, b) => a.option.compareTo(b.option));

        _dbList.forEach((opt) {
          _actionMap.addAll({count: opt.option});

          count++;
        });

        return _actionMap;
      },
    );
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

    return ref.snapshots().map((list) =>
        list.documents.map((doc) => Category.fromMap(doc.data)).toList());
  }
}
