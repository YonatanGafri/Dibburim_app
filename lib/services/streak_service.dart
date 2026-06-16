import '../models/session.dart';

/// Pure logic for calculating prayer streaks.
/// Stateless and easily testable.
class StreakService {
  /// Calculates the current consecutive-day streak ending today.
  /// Sessions must be sorted chronologically or unsorted (handled internally).
  static int getCurrentStreak(List<PrayerSession> sessions) {
    if (sessions.isEmpty) return 0;

    // Get unique dates (normalized to date-only)
    final uniqueDates = sessions
        .map((s) => DateTime(s.date.year, s.date.month, s.date.day))
        .toSet()
        .toList()
      ..sort((a, b) => b.compareTo(a)); // Most recent first

    final today = DateTime.now();
    final todayNormalized = DateTime(today.year, today.month, today.day);

    // Check if the most recent session is today or yesterday
    final diff = todayNormalized.difference(uniqueDates.first).inDays;
    if (diff > 1) return 0; // Streak broken

    int streak = 0;
    DateTime expectedDate = todayNormalized.subtract(Duration(days: diff));

    for (final date in uniqueDates) {
      if (date == expectedDate) {
        streak++;
        expectedDate = expectedDate.subtract(const Duration(days: 1));
      } else if (date.isBefore(expectedDate)) {
        break; // Gap found — streak ends
      }
    }

    return streak;
  }

  /// Count of sessions completed in a given month/year.
  static int getMonthlyCount(List<PrayerSession> sessions, int year, int month) {
    return sessions
        .where((s) => s.date.year == year && s.date.month == month)
        .length;
  }

  /// Total minutes accumulated in a given year.
  static int getYearlyMinutes(List<PrayerSession> sessions, int year) {
    return sessions
        .where((s) => s.date.year == year)
        .fold<int>(0, (sum, s) => sum + s.durationMinutes);
  }

  /// Set of completed dates (day-only) for a given month.
  static Set<DateTime> getCompletedDates(
      List<PrayerSession> sessions, int year, int month) {
    return sessions
        .where((s) => s.date.year == year && s.date.month == month)
        .map((s) => DateTime(s.date.year, s.date.month, s.date.day))
        .toSet();
  }
}
