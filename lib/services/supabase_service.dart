import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/foundation.dart';
import '../config/supabase_config.dart';
import '../models/session.dart';

/// Supabase service — handles backend integration for the global prayer counter.
class SupabaseService {
  /// Initialize the Supabase client.
  Future<void> init() async {
    await Supabase.initialize(
      url: SupabaseConfig.url,
      anonKey: SupabaseConfig.anonKey,
    );
  }

  /// Get the current global counter value.
  Future<int> getTodayCount() async {
    try {
      final response = await Supabase.instance.client
          .from('global_stats')
          .select('total_prayers')
          .eq('id', 1)
          .maybeSingle();
      return (response?['total_prayers'] as num?)?.toInt() ?? 0;
    } catch (e) {
      return 0; // Fallback if table doesn't exist yet or offline
    }
  }

  /// Increment the global counter when a user completes a session.
  Future<void> incrementDailyCounter() async {
    try {
      await Supabase.instance.client.rpc('increment_counter');
    } catch (e) {
      // Ignore errors (e.g. offline)
    }
  }

  /// Subscribe to real-time counter updates.
  Stream<int> subscribeToDailyCounter() {
    return Supabase.instance.client
        .from('global_stats')
        .stream(primaryKey: ['id'])
        .map((data) {
      if (data.isNotEmpty) {
        final row = data.firstWhere((element) => element['id'] == 1, orElse: () => {});
        return (row['total_prayers'] as num?)?.toInt() ?? 0;
      }
      return 0;
    });
  }

  /// Save a user's personal session to the cloud.
  Future<void> saveUserSession(PrayerSession session) async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) return;
    try {
      await Supabase.instance.client.from('user_sessions').insert({
        'user_id': user.id,
        'date': session.date.toIso8601String(),
        'duration_minutes': session.durationMinutes,
      });
    } catch (e) {
      debugPrint('Error saving session to cloud: $e');
    }
  }

  /// Fetch user's personal sessions from the cloud.
  Future<List<PrayerSession>> getUserSessions() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) return [];
    try {
      final response = await Supabase.instance.client
          .from('user_sessions')
          .select()
          .eq('user_id', user.id);
      
      return response.map<PrayerSession>((json) {
        return PrayerSession(
          date: DateTime.parse(json['date']),
          durationMinutes: json['duration_minutes'],
        );
      }).toList();
    } catch (e) {
      debugPrint('Error fetching cloud sessions: $e');
      return [];
    }
  }
}
