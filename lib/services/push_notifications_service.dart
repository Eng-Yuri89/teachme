import 'dart:async';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';

class PushNotificationProvider {
  final FirebaseMessaging _messaging = FirebaseMessaging();
  String token;
  final _messagesStreamController = StreamController<String>.broadcast();
  Stream<String> get messages => _messagesStreamController.stream;

  Future<void> setup() async {
    // Initializing different methods to manage
    // Push Notifications
    await _messaging.requestNotificationPermissions();
    token = await _messaging.getToken();
    _messaging.configure(onMessage: (Map<String, dynamic> message) async {
      print("ON MESSAGE" + message.toString());
      // Validating operating System
      String url;
      if (Platform.isAndroid) {
        final data = message['data'];
        final noti = message['notification'];
        url = data['url'];
        if (url == '')
          url =
              data['message_title_custom'] + ': ' + data['message_body_custom'];
      } else {
        url = message['url'];
      }
      _messagesStreamController.sink.add(url);
    }, onLaunch: (Map<String, dynamic> message) async {
      print("ON LAUNCH" + message.toString());
      // Validating operating System
      String url;
      if (Platform.isAndroid) {
        final data = message['data'];
        final noti = message['notification'];
        url = data['url'];
        if (url == '')
          url =
              data['message_title_custom'] + ': ' + data['message_body_custom'];
      } else {
        url = message['url'];
      }
      _messagesStreamController.sink.add(url);
    }, onResume: (Map<String, dynamic> message) async {
      print("ON RESUME" + message.toString());
      // Validating operating System
      String url;
      if (Platform.isAndroid) {
        final data = message['data'];
        final noti = message['notification'];
        url = data['url'];
        if (url == '')
          url =
              data['message_title_custom'] + ': ' + data['message_body_custom'];
      } else {
        url = message['url'];
      }
      _messagesStreamController.sink.add(url);
    });
  }
}
