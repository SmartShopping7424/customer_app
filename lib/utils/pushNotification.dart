import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final pushNotificationProvider =
    ChangeNotifierProvider((ref) => PushNotification());

class PushNotification extends ChangeNotifier {
  late FirebaseMessaging pushMessage;
  late FlutterLocalNotificationsPlugin localNotification;
  late NotificationDetails generalNotificationDetails;

  // main init function
  init() async {
    initLocalNotifications();
    initPushNotification();
    return;
  }

  // initialize local notification
  initLocalNotifications() async {
    pushMessage = FirebaseMessaging.instance;
    localNotification = FlutterLocalNotificationsPlugin();

    localNotification.initialize(
        const InitializationSettings(
          android: AndroidInitializationSettings("@mipmap/ic_launcher"),
          iOS: DarwinInitializationSettings(),
        ), onDidReceiveNotificationResponse: (data) {
      onDataReceive(data);
    });

    if (Platform.isIOS) {
      await localNotification
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );
    } else if (Platform.isAndroid) {
      final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
          localNotification.resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();
      await androidImplementation?.requestPermission();
    }

    // general notification setting for android and ios
    generalNotificationDetails = NotificationDetails(
      android: AndroidNotificationDetails(
        "dragmart",
        "Dragmart Notification",
        channelDescription: "This is notification channel of dragmart",
        icon: "@mipmap/ic_launcher",
        importance: Importance.high,
        priority: Priority.high,
        playSound: true,
      ),
      iOS: DarwinNotificationDetails(),
    );
  }

  // initialize push notification
  initPushNotification() async {
    try {
      if (Platform.isIOS) {
        await pushMessage.requestPermission(
          alert: true,
          announcement: false,
          badge: true,
          carPlay: false,
          criticalAlert: false,
          provisional: false,
          sound: true,
        );
      }
      pushMessage.setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );

      // for foreground message
      FirebaseMessaging.onMessage.listen((RemoteMessage event) {
        foregroundMessageHandler(event);
      });

      // for background message
      FirebaseMessaging.onBackgroundMessage(backgroundMessageHandler);
    } catch (e) {
      print("Error while initialize push notification ::: $e");
    }
  }

  // foreground message handler
  void foregroundMessageHandler(RemoteMessage message) async {
    RemoteNotification? notification = message.notification;
    // if there is no notification
    if (notification == null) return;

    // if there is notification
    localNotification.show(
      notification.hashCode,
      notification.title,
      notification.body,
      generalNotificationDetails,
      payload: message.data.toString(),
    );
  }

  // get push notification token
  getPushNotificationToken() async {
    return await pushMessage.getToken();
  }

  // on data receive
  onDataReceive(data) {
    print("data is received ::: $data");
  }
}

// background message handler
Future<void> backgroundMessageHandler(RemoteMessage message) async {
  print('receive background notification ${message.notification?.body}');
}
