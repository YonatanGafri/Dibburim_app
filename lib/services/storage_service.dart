import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../config/constants.dart';
import '../models/session.dart';

/// Wraps SharedPreferences for all local persistence needs.
class StorageService {
  late SharedPreferences _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // ─── Theme ───

  bool getIsBlueTheme() {
    return _prefs.getBool(AppConstants.keyTheme) ?? false;
  }

  Future<void> setIsBlueTheme(bool value) async {
    await _prefs.setBool(AppConstants.keyTheme, value);
  }

  // ─── Language ───

  String getLanguage() {
    return _prefs.getString(AppConstants.keyLanguage) ?? 'he';
  }

  Future<void> setLanguage(String value) async {
    await _prefs.setString(AppConstants.keyLanguage, value);
  }

  // ─── Gender ───

  bool getIsFemale() {
    return _prefs.getBool(AppConstants.keyGender) ?? false;
  }

  Future<void> setIsFemale(bool value) async {
    await _prefs.setBool(AppConstants.keyGender, value);
  }

  // ─── Reminder ───

  bool getReminderEnabled() {
    return _prefs.getBool(AppConstants.keyReminderEnabled) ?? false;
  }

  Future<void> setReminderEnabled(bool value) async {
    await _prefs.setBool(AppConstants.keyReminderEnabled, value);
  }

  int getReminderHour() {
    return _prefs.getInt(AppConstants.keyReminderHour) ?? 20; // Default 8 PM
  }

  Future<void> setReminderHour(int value) async {
    await _prefs.setInt(AppConstants.keyReminderHour, value);
  }

  int getReminderMinute() {
    return _prefs.getInt(AppConstants.keyReminderMinute) ?? 0;
  }

  Future<void> setReminderMinute(int value) async {
    await _prefs.setInt(AppConstants.keyReminderMinute, value);
  }

  List<int> getReminderDays() {
    final raw = _prefs.getStringList(AppConstants.keyReminderDays);
    if (raw == null || raw.isEmpty) return [1, 2, 3, 4, 5, 6, 7]; // Default all days
    return raw.map(int.parse).toList();
  }

  Future<void> setReminderDays(List<int> days) async {
    final strList = days.map((e) => e.toString()).toList();
    await _prefs.setStringList(AppConstants.keyReminderDays, strList);
  }

  // ─── Sessions ───

  List<PrayerSession> getSessions() {
    final raw = _prefs.getString(AppConstants.keySessions);
    if (raw == null || raw.isEmpty) return [];
    try {
      final List<dynamic> decoded = jsonDecode(raw);
      return decoded
          .map((e) => PrayerSession.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> saveSessions(List<PrayerSession> sessions) async {
    final encoded = jsonEncode(sessions.map((s) => s.toJson()).toList());
    await _prefs.setString(AppConstants.keySessions, encoded);
  }

  Future<void> addSession(PrayerSession session) async {
    final sessions = getSessions();
    sessions.add(session);
    await saveSessions(sessions);
  }

  // ─── Temple Prayer ───

  String? getLastTemplePrayerDate() {
    return _prefs.getString(AppConstants.keyLastTemplePrayerDate);
  }

  Future<void> setLastTemplePrayerDate(String dateStr) async {
    await _prefs.setString(AppConstants.keyLastTemplePrayerDate, dateStr);
  }
}
