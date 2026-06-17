import 'package:flutter_test/flutter_test.dart';
import 'package:dibburim_app/models/session.dart';
import 'package:dibburim_app/services/streak_service.dart';

void main() {
  group('StreakService Tests', () {
    test('Empty sessions list returns 0 streak', () {
      expect(StreakService.getCurrentStreak([]), 0);
    });

    test('Single session today returns 1 streak', () {
      final now = DateTime.now();
      final sessions = [PrayerSession(date: now, durationMinutes: 10)];
      expect(StreakService.getCurrentStreak(sessions), 1);
    });
  });
}
