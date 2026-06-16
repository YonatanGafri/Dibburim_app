import 'package:flutter/foundation.dart';
import '../models/session.dart';
import '../services/storage_service.dart';
import '../services/streak_service.dart';

/// Manages prayer session history, streaks, and statistics.
class SessionProvider extends ChangeNotifier {
  final StorageService _storage;

  List<PrayerSession> _sessions = [];

  SessionProvider({required StorageService storage}) : _storage = storage;

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

  /// Load sessions from local storage.
  void loadFromStorage() {
    _sessions = _storage.getSessions();
    notifyListeners();
  }

  /// Record a new completed session.
  Future<void> recordSession(int durationMinutes) async {
    final session = PrayerSession(
      date: DateTime.now(),
      durationMinutes: durationMinutes,
    );
    _sessions.add(session);
    await _storage.addSession(session);
    notifyListeners();
  }
}
