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
}
