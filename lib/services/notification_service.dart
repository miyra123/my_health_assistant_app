import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final FlutterLocalNotificationsPlugin notificationsPlugin =
  FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    const AndroidInitializationSettings androidSettings =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings settings =
    InitializationSettings(android: androidSettings);

    await notificationsPlugin.initialize(settings);

    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Asia/Muscat'));
  }

  static Future<void> showInstantNotification() async {
    await notificationsPlugin.show(
      0,
      "Test Now",
      "Immediate notification",
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'test_channel',
          'Test Channel',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
    );
  }

  static Future<void> scheduleSimpleNotification(int id, String title,
      String body, Duration delay) async {
    Future.delayed(delay, () async {
      await notificationsPlugin.show(
        id,
        title,
        body,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'simple_channel',
            'Simple Notifications',
            importance: Importance.max,
            priority: Priority.high,
          ),
        ),
      );
    });
  }
}