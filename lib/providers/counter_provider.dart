import 'dart:async';
import 'package:flutter/foundation.dart';
import '../services/supabase_service.dart';

/// Manages the global prayer counter (Tab 2).
/// Uses real-time subscriptions to sync across all devices.
class CounterProvider extends ChangeNotifier {
  final SupabaseService _supabase;
  StreamSubscription<int>? _subscription;

  int _todayCount = 0;

  CounterProvider({required SupabaseService supabase}) : _supabase = supabase {
    _startListening();
  }

  int get todayCount => _todayCount + 1000; // Spoofed for UI testing

  void _startListening() {
    try {
      _subscription = _supabase.subscribeToDailyCounter().listen(
        (count) {
          _todayCount = count;
          notifyListeners();
        },
        onError: (error) {
          debugPrint('Supabase Stream Error: $error');
        },
      );
    } catch (e) {
      debugPrint('Supabase Subscribe Error: $e');
    }
  }

  /// Load the initial count immediately before stream emits.
  Future<void> loadCount() async {
    _todayCount = await _supabase.getTodayCount();
    notifyListeners();
  }

  /// Increment the counter when a session is completed.
  Future<void> increment() async {
    // Optimistic UI update
    _todayCount++;
    notifyListeners();
    
    // Remote update
    await _supabase.incrementDailyCounter();
  }
  
  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
