import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz_data;
import '../config/constants.dart';
import '../data/strings.dart';

/// Manages local push notifications for daily reminders.
class NotificationService {
  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  /// Initialize the notification system.
  Future<void> init() async {
    tz_data.initializeTimeZones();
    final timeZoneInfo = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timeZoneInfo.identifier));

    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const initSettings = InitializationSettings(
      android: androidSettings,
    );

    await _plugin.initialize(initSettings);

    // Create notification channel for Android
    const channel = AndroidNotificationChannel(
      AppConstants.notificationChannelId,
      AppConstants.notificationChannelName,
      description: AppConstants.notificationChannelDesc,
      importance: Importance.defaultImportance,
      sound: RawResourceAndroidNotificationSound('chime'),
    );

    await _plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  /// Schedule a repeating daily notification at the given hour:minute for specific days.
  Future<void> scheduleDailyReminder(int hour, int minute, List<int> days) async {
    // Cancel any existing reminders first
    await cancelReminder();

    if (days.isEmpty) return;

    final now = tz.TZDateTime.now(tz.local);

    const androidDetails = AndroidNotificationDetails(
      AppConstants.notificationChannelId,
      AppConstants.notificationChannelName,
      channelDescription: AppConstants.notificationChannelDesc,
      importance: Importance.defaultImportance,
      priority: Priority.defaultPriority,
      sound: RawResourceAndroidNotificationSound('chime'),
      styleInformation: BigTextStyleInformation(''),
    );

    const details = NotificationDetails(android: androidDetails);

    for (final day in days) {
      var scheduledDate = tz.TZDateTime(
        tz.local,
        now.year,
        now.month,
        now.day,
        hour,
        minute,
      );

      // If the time has already passed today, schedule for tomorrow
      if (scheduledDate.isBefore(now)) {
        scheduledDate = scheduledDate.add(const Duration(days: 1));
      }

      // Advance to the requested day of the week
      while (scheduledDate.weekday != day) {
        scheduledDate = scheduledDate.add(const Duration(days: 1));
      }

      await _plugin.zonedSchedule(
        day, // Notification ID based on day (1-7)
        AppStrings.neutral('reminderNotificationTitle'),
        AppStrings.neutral('reminderNotificationBody'),
        scheduledDate,
        details,
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime, // Repeat weekly
      );
    }
  }

  /// Cancel the daily reminder.
  Future<void> cancelReminder() async {
    for (int i = 0; i <= 7; i++) {
      await _plugin.cancel(i);
    }
  }

  /// Request notification permissions (Android 13+).
  Future<bool> requestPermissions() async {
    final android = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    
    // Request notification permission (Android 13+)
    final bool? granted = await android?.requestNotificationsPermission();
    
    // We use inexact alarms, so we do NOT need to request exact alarms permission
    // which throws the user out to the settings app on Android 14+.
    
    return granted ?? true;
  }
}
