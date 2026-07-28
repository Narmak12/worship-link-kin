import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

class FirebaseMessagingService {
  static final FirebaseMessagingService _instance = FirebaseMessagingService._internal();
  factory FirebaseMessagingService() => _instance;
  FirebaseMessagingService._internal();

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications = FlutterLocalNotificationsPlugin();
  StreamSubscription<RemoteMessage>? _foregroundSub;
  StreamSubscription<String>? _tokenRefreshSub;
  bool _initialized = false;

  Future<void> initialize() async {
    if (_initialized) return;
    await Firebase.initializeApp();
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'worship_link_channel', 'Worship Link Notifications',
      description: 'Notifications pour candidatures et invitations', importance: Importance.high, playSound: true,
    );
    await _localNotifications.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.createNotificationChannel(channel);
    const AndroidInitializationSettings androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initSettings = InitializationSettings(android: androidSettings);
    await _localNotifications.initialize(initSettings);
    await _messaging.requestPermission(alert: true, badge: true, sound: true);
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    _foregroundSub = FirebaseMessaging.onMessage.listen((message) => _showForegroundNotification(message));
    final token = await _messaging.getToken();
    if (token != null) await _saveToken(token);
    _tokenRefreshSub = _messaging.onTokenRefresh.listen((newToken) => _saveToken(newToken));
    _initialized = true;
  }

  Future<void> _showForegroundNotification(RemoteMessage message) async {
    final notification = message.notification;
    if (notification == null) return;
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'worship_link_channel', 'Worship Link Notifications',
      channelDescription: 'Notifications', importance: Importance.high, priority: Priority.high, showWhen: true,
    );
    const NotificationDetails details = NotificationDetails(android: androidDetails);
    await _localNotifications.show(message.hashCode, notification.title, notification.body, details, payload: message.data['type']);
  }

  Future<void> _saveToken(String token) async {
    try {
      final user = Supabase.instance.client.auth.currentUser;
      if (user == null) return;
      await Supabase.instance.client.from('notification_tokens').upsert(
        {'user_id': user.id, 'fcm_token': token, 'platform': 'android', 'updated_at': DateTime.now().toIso8601String()},
        onConflict: 'user_id, fcm_token',
      );
    } catch (e) { debugPrint('Save token error: $e'); }
  }

  Future<void> deleteToken() async {
    try {
      final user = Supabase.instance.client.auth.currentUser;
      if (user == null) return;
      final token = await _messaging.getToken();
      if (token == null) return;
      await Supabase.instance.client.from('notification_tokens').delete().eq('user_id', user.id).eq('fcm_token', token);
      await _messaging.deleteToken();
    } catch (e) { debugPrint('Delete token error: $e'); }
  }

  void dispose() {
    _foregroundSub?.cancel();
    _tokenRefreshSub?.cancel();
  }
}
