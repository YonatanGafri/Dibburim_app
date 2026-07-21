import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/session.dart';
import '../services/streak_service.dart';
import '../services/supabase_service.dart';

/// Manages prayer session history, streaks, and statistics.
class SessionProvider extends ChangeNotifier {
  final SupabaseService _supabase;
  static const String _storageKey = 'cached_sessions';

  List<PrayerSession> _sessions = [];

  SessionProvider({
    required SupabaseService supabase,
  })  : _supabase = supabase {
    // Listen to login/logout to manage data
    Supabase.instance.client.auth.onAuthStateChange.listen((data) {
      if (data.event == AuthChangeEvent.signedOut) {
        _sessions = [];
        _clearLocalCache();
        notifyListeners();
      } else if (data.event == AuthChangeEvent.signedIn) {
        _syncAfterLogin();
      }
    });
  }

  Future<void> _saveToLocalCache() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonList = _sessions.map((s) => s.toJson()).toList();
      await prefs.setString(_storageKey, jsonEncode(jsonList));
    } catch (e) {
      debugPrint('Error saving to local cache: $e');
    }
  }

  Future<void> _loadFromLocalCache() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final rawData = prefs.getString(_storageKey);
      if (rawData != null) {
        final List<dynamic> decoded = jsonDecode(rawData);
        _sessions = decoded
            .map((json) => PrayerSession.fromJson(json as Map<String, dynamic>))
            .toList();
        _sessions.sort((a, b) => b.date.compareTo(a.date));
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error loading from local cache: $e');
    }
  }

  Future<void> _clearLocalCache() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_storageKey);
    } catch (e) {
      debugPrint('Error clearing local cache: $e');
    }
  }

  Future<void> _syncAfterLogin() async {
    await syncSessions();
  }

  // ─── Getters ───
  List<PrayerSession> get sessions => List.unmodifiable(_sessions);

  int get currentStreak => StreakService.getCurrentStreak(_sessions);

  int get monthlyCount {
    final now = DateTime.now();
    return StreakService.getMonthlyCount(_sessions, now.year, now.month);
  }

  int get yearlyMinutes {
    return StreakService.getYearlyMinutes(_sessions, DateTime.now().year);
  }

  /// Get completed dates for a specific month (for the calendar view).
  Set<DateTime> getCompletedDates(int year, int month) {
    return StreakService.getCompletedDates(_sessions, year, month);
  }

  /// Load sessions offline-first, then sync with cloud.
  Future<void> loadFromStorage() async {
    await _loadFromLocalCache();

    if (Supabase.instance.client.auth.currentUser != null) {
      await syncSessions();
    }
  }

  /// Main synchronization logic. Merges local and cloud data and uploads unsynced sessions.
  Future<void> syncSessions() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) return;

    try {
      final cloudSessions = await _supabase.getUserSessions();

      final Map<String, PrayerSession> merged = {};

      // 1. Load local sessions first
      for (var s in _sessions) {
        final key = s.date.toIso8601String();
        merged[key] = s;
      }

      // 2. Merge cloud sessions (remote is always master, marked as synced)
      for (var s in cloudSessions) {
        final key = s.date.toIso8601String();
        merged[key] = s.copyWith(isSynced: true);
      }

      _sessions = merged.values.toList();
      _sessions.sort((a, b) => b.date.compareTo(a.date));
      await _saveToLocalCache();
      notifyListeners();

      // 3. Upload any pending local sessions that aren't on the cloud
      await _syncPendingSessions();
    } catch (e) {
      debugPrint('Sync error: $e');
    }
  }

  Future<void> _syncPendingSessions() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) return;

    bool hasChanges = false;
    for (int i = 0; i < _sessions.length; i++) {
      final s = _sessions[i];
      if (!s.isSynced) {
        final success = await _supabase.saveUserSession(s);
        if (success) {
          _sessions[i] = s.copyWith(isSynced: true);
          hasChanges = true;
        }
      }
    }

    if (hasChanges) {
      await _saveToLocalCache();
      notifyListeners();
    }
  }

  /// Record a new completed session. Saved locally first, then attempts upload.
  Future<void> recordSession(int durationMinutes, {DateTime? date}) async {
    final session = PrayerSession(
      date: date ?? DateTime.now(),
      durationMinutes: durationMinutes,
      isSynced: false,
    );

    if (Supabase.instance.client.auth.currentUser != null) {
      _sessions.add(session);
      _sessions.sort((a, b) => b.date.compareTo(a.date));
      await _saveToLocalCache();
      notifyListeners();

      final success = await _supabase.saveUserSession(session);
      if (success) {
        final idx = _sessions.indexWhere((s) => s.date == session.date);
        if (idx != -1) {
          _sessions[idx] = session.copyWith(isSynced: true);
          await _saveToLocalCache();
          notifyListeners();
        }
      }
    }
  }

  /// Update or delete a session for a specific date (e.g. from the calendar).
  Future<void> updateSessionForDate(DateTime date, int newDurationMinutes) async {
    // 1. Remove from local list all sessions that match the year, month, day
    _sessions.removeWhere((s) =>
        s.date.year == date.year &&
        s.date.month == date.month &&
        s.date.day == date.day);

    // 2. Add the new session if > 0
    if (newDurationMinutes > 0) {
      final session = PrayerSession(
        date: DateTime(date.year, date.month, date.day, 12, 0), // Default to midday
        durationMinutes: newDurationMinutes,
        isSynced: false,
      );
      _sessions.add(session);
    }

    _sessions.sort((a, b) => b.date.compareTo(a.date));
    await _saveToLocalCache();
    notifyListeners();

    // 3. Update cloud
    if (Supabase.instance.client.auth.currentUser != null) {
      final deleted = await _supabase.deleteUserSessionsOnDate(date);
      if (deleted && newDurationMinutes > 0) {
        final idx = _sessions.indexWhere((s) =>
            s.date.year == date.year &&
            s.date.month == date.month &&
            s.date.day == date.day);

        if (idx != -1) {
          final success = await _supabase.saveUserSession(_sessions[idx]);
          if (success) {
            _sessions[idx] = _sessions[idx].copyWith(isSynced: true);
            await _saveToLocalCache();
            notifyListeners();
          }
        }
      }
    }
  }
}
