import 'package:flutter/foundation.dart';
import '../services/supabase_service.dart';

/// Manages the global prayer counter (Tab 2).
/// Currently backed by a local placeholder. When Supabase is configured,
/// this will use real-time subscriptions.
class CounterProvider extends ChangeNotifier {
  final SupabaseService _supabase;

  int _todayCount = 0;

  CounterProvider({required SupabaseService supabase}) : _supabase = supabase;

  int get todayCount => _todayCount;

  /// Load the initial count.
  Future<void> loadCount() async {
    _todayCount = await _supabase.getTodayCount();
    notifyListeners();
  }

  /// Increment the counter when a session is completed.
  Future<void> increment() async {
    await _supabase.incrementDailyCounter();
    _todayCount++;
    notifyListeners();
  }
}
