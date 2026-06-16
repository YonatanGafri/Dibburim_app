import 'package:flutter/foundation.dart';
import '../services/storage_service.dart';
import '../services/notification_service.dart';

/// Manages app-wide user settings: gender phrasing and daily reminders.
class SettingsProvider extends ChangeNotifier {
  final StorageService _storage;
  final NotificationService _notifications;

  bool _isFemale = false;
  bool _reminderEnabled = false;
  bool _isBlueTheme = false;
  int _reminderHour = 20;
  int _reminderMinute = 0;

  SettingsProvider({
    required StorageService storage,
    required NotificationService notifications,
  })  : _storage = storage,
        _notifications = notifications;

  // ─── Getters ───
  bool get isFemale => _isFemale;
  bool get reminderEnabled => _reminderEnabled;
  bool get isBlueTheme => _isBlueTheme;
  int get reminderHour => _reminderHour;
  int get reminderMinute => _reminderMinute;

  String get reminderTimeDisplay =>
      '${_reminderHour.toString().padLeft(2, '0')}:${_reminderMinute.toString().padLeft(2, '0')}';

  /// Load saved settings from SharedPreferences.
  void loadFromStorage() {
    _isFemale = _storage.getIsFemale();
    _reminderEnabled = _storage.getReminderEnabled();
    _isBlueTheme = _storage.getIsBlueTheme();
    _reminderHour = _storage.getReminderHour();
    _reminderMinute = _storage.getReminderMinute();
    notifyListeners();
  }

  /// Toggle between male and female phrasing.
  Future<void> setGender(bool isFemale) async {
    _isFemale = isFemale;
    await _storage.setIsFemale(isFemale);
    notifyListeners();
  }

  /// Toggle the app theme color.
  Future<void> setTheme(bool isBlue) async {
    _isBlueTheme = isBlue;
    await _storage.setIsBlueTheme(isBlue);
    notifyListeners();
  }

  /// Enable/disable the daily reminder.
  Future<void> setReminderEnabled(bool enabled) async {
    _reminderEnabled = enabled;
    await _storage.setReminderEnabled(enabled);

    if (enabled) {
      await _notifications.requestPermissions();
      await _notifications.scheduleDailyReminder(_reminderHour, _reminderMinute);
    } else {
      await _notifications.cancelReminder();
    }
    notifyListeners();
  }

  /// Update the reminder time.
  Future<void> setReminderTime(int hour, int minute) async {
    _reminderHour = hour;
    _reminderMinute = minute;
    await _storage.setReminderHour(hour);
    await _storage.setReminderMinute(minute);

    if (_reminderEnabled) {
      await _notifications.scheduleDailyReminder(hour, minute);
    }
    notifyListeners();
  }
}
