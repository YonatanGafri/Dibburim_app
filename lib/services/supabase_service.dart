import 'package:supabase_flutter/supabase_flutter.dart';
import '../config/supabase_config.dart';

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
}
