/// Supabase service — placeholder for future backend integration.
///
/// For the MVP, the app runs fully locally. This service provides
/// the interface that will later connect to Supabase Realtime
/// for the global prayer counter on Tab 2.
class SupabaseService {
  int _localCounter = 0;

  /// Initialize the Supabase client.
  /// Currently a no-op — will connect when credentials are configured.
  Future<void> init() async {
    // TODO: Uncomment when Supabase credentials are configured.
    // await Supabase.initialize(
    //   url: SupabaseConfig.url,
    //   anonKey: SupabaseConfig.anonKey,
    // );
  }

  /// Get today's global counter value.
  /// Currently returns a local placeholder value.
  Future<int> getTodayCount() async {
    // TODO: Replace with Supabase query:
    // final response = await Supabase.instance.client
    //     .from('daily_counter')
    //     .select('count')
    //     .eq('date', DateTime.now().toIso8601String().substring(0, 10))
    //     .maybeSingle();
    // return response?['count'] ?? 0;
    return _localCounter;
  }

  /// Increment the global counter when a user completes a session.
  /// Currently only increments a local variable.
  Future<void> incrementDailyCounter() async {
    _localCounter++;
    // TODO: Replace with Supabase RPC call:
    // await Supabase.instance.client.rpc('increment_daily_counter');
  }

  /// Subscribe to real-time counter updates.
  /// Currently returns an empty stream.
  Stream<int> subscribeToDailyCounter() {
    // TODO: Replace with Supabase Realtime subscription:
    // return Supabase.instance.client
    //     .from('daily_counter')
    //     .stream(primaryKey: ['id'])
    //     .map((data) => data.isNotEmpty ? data.first['count'] as int : 0);
    return Stream.value(_localCounter);
  }
}
