import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/session.dart';
import '../services/storage_service.dart';
import '../services/streak_service.dart';
import '../services/supabase_service.dart';

/// Manages prayer session history, streaks, and statistics.
class SessionProvider extends ChangeNotifier {
  final StorageService _storage;
  final SupabaseService _supabase;

  List<PrayerSession> _sessions = [];

  SessionProvider({
    required StorageService storage,
    required SupabaseService supabase,
  })  : _storage = storage,
        _supabase = supabase {
    // Listen to login/logout to manage data
    Supabase.instance.client.auth.onAuthStateChange.listen((data) {
      if (data.event == AuthChangeEvent.signedOut) {
        _sessions = [];
        _storage.saveSessions([]);
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
    
    // 2. Fetch all cloud sessions and overwrite local storage
    try {
      final cloudSessions = await _supabase.getUserSessions();
      _sessions = cloudSessions;
      await _storage.saveSessions(_sessions);
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

  /// Load sessions from local storage and sync with cloud if applicable.
  Future<void> loadFromStorage() async {
    // Start with local sessions for fast load
    _sessions = _storage.getSessions();
    notifyListeners();
    
    // If logged in, fetch from cloud to make sure we are exactly in sync
    if (Supabase.instance.client.auth.currentUser != null) {
      try {
        final cloudSessions = await _supabase.getUserSessions();
        // Always trust cloud as source of truth for logged-in users
        _sessions = cloudSessions;
        await _storage.saveSessions(_sessions);
        notifyListeners();
      } catch (e) {
        debugPrint('Sync error: $e');
      }
    }
  }

  /// Record a new completed session.
  Future<void> recordSession(int durationMinutes) async {
    final session = PrayerSession(
      date: DateTime.now(),
      durationMinutes: durationMinutes,
    );
    _sessions.add(session);
    await _storage.addSession(session);
    await _supabase.saveUserSession(session);
    notifyListeners();
  }
}
