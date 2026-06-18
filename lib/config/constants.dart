/// App-wide constants for the Dibburim app.
class AppConstants {
  AppConstants._();

  /// Default meditation duration in minutes.
  static const int defaultDurationMinutes = 5;

  /// How often (in seconds) the inspiration prompt rotates during a session.
  static const int promptRotationIntervalSeconds = 60;

  /// Notification channel ID for Android.
  static const String notificationChannelId = 'diburim_reminders';
  static const String notificationChannelName = 'תזכורות דיבורים';
  static const String notificationChannelDesc = 'תזכורות יומיות להתבודדות';

  /// SharedPreferences keys.
  static const String keyGender = 'gender_is_female';
  static const String keySessions = 'sessions_json';
  static const String keyReminderEnabled = 'reminder_enabled';
  static const String keyReminderHour = 'reminder_hour';
  static const String keyReminderMinute = 'reminder_minute';
  static const String keyTheme = 'app_theme_color';
  static const String keyLastTemplePrayerDate = 'last_temple_prayer_date';

  /// Audio asset paths.
  static const String ambientAudioPath = 'audio/ambient.mp3';
  static const String chimeAudioPath = 'audio/chime.wav';
}
