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
  String _language = 'he';
  int _reminderHour = 20;
  int _reminderMinute = 0;
  List<int> _reminderDays = [1, 2, 3, 4, 5, 6, 7];

  SettingsProvider({
    required StorageService storage,
    required NotificationService notifications,
  })  : _storage = storage,
        _notifications = notifications;

  // ─── Getters ───
  bool get isFemale => _isFemale;
  bool get reminderEnabled => _reminderEnabled;
  bool get isBlueTheme => _isBlueTheme;
  String get language => _language;
  int get reminderHour => _reminderHour;
  int get reminderMinute => _reminderMinute;
  List<int> get reminderDays => _reminderDays;

  String get reminderTimeDisplay =>
      '${_reminderHour.toString().padLeft(2, '0')}:${_reminderMinute.toString().padLeft(2, '0')}';

  /// Load saved settings from SharedPreferences.
  void loadFromStorage() {
    _isFemale = _storage.getIsFemale();
    _reminderEnabled = _storage.getReminderEnabled();
    _isBlueTheme = _storage.getIsBlueTheme();
    _language = _storage.getLanguage();
    _reminderHour = _storage.getReminderHour();
    _reminderMinute = _storage.getReminderMinute();
    _reminderDays = _storage.getReminderDays();
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

  /// Change the app language.
  Future<void> setLanguage(String lang) async {
    _language = lang;
    await _storage.setLanguage(lang);
    notifyListeners();
  }

  /// Enable/disable the daily reminder. Returns null if success, or error string if failed.
  Future<String?> setReminderEnabled(bool enabled) async {
    if (enabled) {
      final granted = await _notifications.requestPermissions();
      if (!granted) {
        return 'Notification permission not granted';
      }
    }

    _reminderEnabled = enabled;
    notifyListeners(); // Update UI immediately

    await _storage.setReminderEnabled(enabled);

    if (enabled) {
      try {
        await _notifications.scheduleDailyReminder(_reminderHour, _reminderMinute, _reminderDays);
      } catch (e) {
        // Revert on failure (e.g., exact alarm permission denied)
        _reminderEnabled = false;
        await _storage.setReminderEnabled(false);
        notifyListeners();
        return e.toString();
      }
    } else {
      await _notifications.cancelReminder();
    }
    return null;
  }

  /// Update the reminder time.
  Future<void> setReminderTime(int hour, int minute) async {
    _reminderHour = hour;
    _reminderMinute = minute;
    notifyListeners(); // Update UI immediately

    await _storage.setReminderHour(hour);
    await _storage.setReminderMinute(minute);

    if (_reminderEnabled) {
      try {
        await _notifications.scheduleDailyReminder(hour, minute, _reminderDays);
      } catch (e) {
        debugPrint('Failed to reschedule reminder: $e');
      }
    }
  }

  /// Update the reminder days.
  Future<void> setReminderDays(List<int> days) async {
    _reminderDays = days;
    notifyListeners(); // Update UI immediately

    await _storage.setReminderDays(days);

    if (_reminderEnabled) {
      try {
        await _notifications.scheduleDailyReminder(_reminderHour, _reminderMinute, _reminderDays);
      } catch (e) {
        debugPrint('Failed to reschedule reminder days: $e');
      }
    }
  }
}
