import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/session.dart';
import '../services/streak_service.dart';
import '../services/supabase_service.dart';

/// Manages prayer session history, streaks, and statistics.
class SessionProvider extends ChangeNotifier {
  final SupabaseService _supabase;

  List<PrayerSession> _sessions = [];

  SessionProvider({
    required SupabaseService supabase,
  })  : _supabase = supabase {
    // Listen to login/logout to manage data
    Supabase.instance.client.auth.onAuthStateChange.listen((data) {
      if (data.event == AuthChangeEvent.signedOut) {
        _sessions = [];
        notifyListeners();
      } else if (data.event == AuthChangeEvent.signedIn) {
        _syncAfterLogin();
      }
    });
  }

  Future<void> _syncAfterLogin() async {
    // 1. Upload any guest sessions to the cloud
    for (var s in _sessions) {
      await _supabase.saveUserSession(s);
    }
    
    // 2. Fetch all cloud sessions
    try {
      final cloudSessions = await _supabase.getUserSessions();
      _sessions = cloudSessions;
      notifyListeners();
    } catch (e) {
      debugPrint('Sync after login error: $e');
    }
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

  /// Load sessions from cloud.
  Future<void> loadFromStorage() async {
    // We strictly use cloud data for calendar to ensure reliability
    if (Supabase.instance.client.auth.currentUser != null) {
      try {
        final cloudSessions = await _supabase.getUserSessions();
        _sessions = cloudSessions;
        notifyListeners();
      } catch (e) {
        debugPrint('Sync error: $e');
      }
    } else {
      _sessions = [];
      notifyListeners();
    }
  }

  /// Record a new completed session.
  Future<void> recordSession(int durationMinutes, {DateTime? date}) async {
    final session = PrayerSession(
      date: date ?? DateTime.now(),
      durationMinutes: durationMinutes,
    );
    
    // Only save and track if user is logged in (cloud only)
    if (Supabase.instance.client.auth.currentUser != null) {
      _sessions.add(session);
      await _supabase.saveUserSession(session);
      notifyListeners();
    }
  }
}
