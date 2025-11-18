import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseApi {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();



  Future<void> initNotification() async {
    if (kIsWeb) {
      await _initWebNotification();
    } else {
      await _initLocalNotification();
      await _initMobileNotification();
    }
  }

  Future<void> _initLocalNotification() async {
    const AndroidInitializationSettings androidInit =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings iosInit = DarwinInitializationSettings();

    const InitializationSettings initSettings =
        InitializationSettings(android: androidInit, iOS: iosInit);

    await _localNotifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        print('Local notification tapped with payload: ${response.payload}');
      },
    );
  }

  Future<void> _initMobileNotification() async {
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    print('User permission: ${settings.authorizationStatus}');

    String? apnsToken;
    if (Platform.isIOS) {
      apnsToken = await _firebaseMessaging.getAPNSToken();
      print('APNs Token: $apnsToken');
    } else {
      print('APNs Token not applicable for this platform');
    }

    final fcmToken = await _firebaseMessaging.getToken();
    print('FCM Token: $fcmToken');
    if (fcmToken != null) {
      // await StoreService.storeFcmToken(fcmToken);
    }

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    FirebaseMessaging.onMessage.listen(_onForegroundMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(_onNotificationTap);

    RemoteMessage? initialMessage =
        await _firebaseMessaging.getInitialMessage();
    if (initialMessage != null) {
      print('App launched from terminated by notification');
      _handleMessageNavigation(initialMessage);
    }
  }

  /// Web notifications setup
  Future<void> _initWebNotification() async {
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    print('Web permission: ${settings.authorizationStatus}');

    final fcmToken = await _firebaseMessaging.getToken(
      vapidKey: 'YOUR_WEB_PUSH_CERTIFICATE_KEY_PAIR',
    );
    print('Web FCM Token: $fcmToken');

    if (fcmToken != null) {
      // await StoreService.storeFcmToken(fcmToken);
    }

    FirebaseMessaging.onMessage.listen(_onForegroundMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(_onNotificationTap);
  }

  static Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    await Firebase.initializeApp();
    print('Handling background message: ${message.messageId}');
  }

  void _onForegroundMessage(RemoteMessage message) async {
    print('Foreground notification received');
    print('Data: ${message.data}');

    final notification = message.notification;
    if (notification != null) {
      // toaster.showInfo(
      //   title: notification.title ?? 'Notification',
      //   msg: notification.body ?? '',
      // );

      const AndroidNotificationDetails androidDetails =
          AndroidNotificationDetails(
        'default_channel_id',
        'Default Notifications',
        channelDescription: 'Channel for foreground notifications',
        importance: Importance.max,
        priority: Priority.high,
        playSound: true,
      );

      const DarwinNotificationDetails iosDetails = DarwinNotificationDetails();

      const NotificationDetails platformDetails =
          NotificationDetails(android: androidDetails, iOS: iosDetails);

      await _localNotifications.show(
        DateTime.now().millisecondsSinceEpoch ~/ 1000,
        notification.title,
        notification.body,
        platformDetails,
        payload: message.data.toString(),
      );
    }
  }

  void _onNotificationTap(RemoteMessage message) {
    print('Notification tapped');
    print('Data: ${message.data}');
    _handleMessageNavigation(message);
  }

  void _handleMessageNavigation(RemoteMessage message) {}
}
