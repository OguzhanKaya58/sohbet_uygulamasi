import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:sohbet_uygulamasi/app/talk_page.dart';
import 'package:sohbet_uygulamasi/model/user.dart';
import 'package:sohbet_uygulamasi/viewmodel/chat_view_model.dart';
import 'package:sohbet_uygulamasi/viewmodel/user_view_model.dart';

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> myBackgroundMessageHandler(Map<String, dynamic> message) {
  if (message.containsKey('data')) {
    // Handle data message
    final dynamic data = message['data'];
    print("Arka planda gelen data : $data");
    NotificationHandler.showNotification(message);
  }
  if (message.containsKey('notification')) {
    // Handle notification message
    // final dynamic notification = message['notification'];
  }
  // Or do other work...
  return Future<void>.value();
}

class NotificationHandler {
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  static final NotificationHandler _singletor = NotificationHandler._internal();

  factory NotificationHandler() {
    return _singletor;
  }

  NotificationHandler._internal();

  BuildContext myContext;

  initializeFCMNotification(BuildContext context) async {
    myContext = context;
    var initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');
    var initializationSettingsIOS = IOSInitializationSettings(
        onDidReceiveLocalNotification: onDidReceiveLocalNotification);
    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);

    /* _firebaseMessaging.subscribeToTopic("all");

    String token = await _firebaseMessaging.getToken();
    print("token : $token");*/

    _firebaseMessaging.onTokenRefresh.listen((token) async {
      User _currentUser = FirebaseAuth.instance.currentUser;
      await FirebaseFirestore.instance
          .doc("tokens/" + _currentUser.uid)
          .set({"token": token});
    });

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        showNotification(message);
      },
      onBackgroundMessage: myBackgroundMessageHandler,
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
      },
    );
  }

  static Future<void> showNotification(Map<String, dynamic> message) async {
    //   var userURLPath =
    /*await _downloadAndSaveImage(message["data"]["profilURL"], 'largeIcon');
    var mesaj = Person(
      name: message["data"]["title"],
      key: '1',
      // icon: userURLPath,
    );
    var messageStyle = MessagingStyleInformation(mesaj,
        messages: [Message(message["data"]["message"], DateTime.now(), mesaj)]);
*/
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      "1234",
      "Yeni Mesaj",
      "Your channel description",
      //icon: userURLPath,
      //styleInformation: messageStyle,
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
    );
    var iosPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iosPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(0, message['data']['title'],
        message['data']['message'], platformChannelSpecifics,
        payload: jsonEncode(message));
  }

  Future onSelectNotification(String payload) async {
    final _userModel = Provider.of<UserViewModel>(myContext, listen: false);
    if (payload != null) {
      debugPrint("notification payload : $payload");
      Map<String, dynamic> comingNotification = await jsonDecode(payload);
      Navigator.of(myContext, rootNavigator: true).push(
        MaterialPageRoute(
          builder: (context) => ChangeNotifierProvider(
            create: (context) => ChatViewModel(
                currentUser: _userModel.user,
                talkUser: UserModel.idPictureAndUserName(
                    userID: comingNotification["data"]["sendUserID"],
                    profileUrl: comingNotification["data"]["profileURL"],
                    userName: comingNotification["data"]["title"],
                    email: comingNotification["data"]["email"])),
            child: TalkPage(),
          ),
        ),
      );
    }
    return Future.value();
  }

  Future onDidReceiveLocalNotification(
      int id, String title, String body, String payload) async {}

 /* static _downloadAndSaveImage(String url, String name) async {
    var directory = await getApplicationDocumentsDirectory();
    var filePath = '${directory.path}/$name';
    var response = await http.get(url);
    var file = File(filePath);
    await file.writeAsBytes(response.bodyBytes);
    return filePath;
  } */
}
