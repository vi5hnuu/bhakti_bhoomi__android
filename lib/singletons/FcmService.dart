import 'package:bhakti_bhoomi/services/apis/AuthApi.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/// Background message handler — must be a top-level function.
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  // Notification-type messages are shown by the OS automatically when the app
  // is in the background/terminated; nothing else to do here for now.
}

/// Firebase Cloud Messaging: permission, token registration with our backend,
/// and foreground notification display (via flutter_local_notifications).
class FcmService {
  FcmService._();
  static final FcmService instance = FcmService._();

  final FlutterLocalNotificationsPlugin _fln = FlutterLocalNotificationsPlugin();
  bool _inited = false;

  static const AndroidNotificationChannel _channel = AndroidNotificationChannel(
    'fcm_default',
    'General Notifications',
    description: 'Updates and reminders from Bhakti Bhoomi',
    importance: Importance.high,
  );

  Future<void> init() async {
    if (_inited) return;
    _inited = true;

    final messaging = FirebaseMessaging.instance;
    await messaging.requestPermission(alert: true, badge: true, sound: true);
    await messaging.setForegroundNotificationPresentationOptions(alert: true, badge: true, sound: true);

    await _fln.initialize(const InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
    ));
    await _fln
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(_channel);

    FirebaseMessaging.onMessage.listen(_showForeground);
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    // Register the current token, and any future refreshed tokens, with the backend.
    await syncToken();
    messaging.onTokenRefresh.listen((token) => _register(token));
  }

  /// Sends the current FCM token to the backend (best-effort; requires the user
  /// to be signed in — otherwise the backend rejects it and we ignore the error).
  Future<void> syncToken() async {
    try {
      final token = await FirebaseMessaging.instance.getToken();
      if (token != null) await _register(token);
    } catch (_) {/* not signed in / no network — ignore */}
  }

  Future<void> _register(String token) async {
    try {
      await AuthApi().registerFcmToken(token: token);
    } catch (_) {/* ignore (e.g. 401 when signed out) */}
  }

  void _showForeground(RemoteMessage message) {
    final n = message.notification;
    if (n == null) return;
    _fln.show(
      n.hashCode,
      n.title,
      n.body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          _channel.id,
          _channel.name,
          channelDescription: _channel.description,
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
        ),
      ),
    );
  }
}
