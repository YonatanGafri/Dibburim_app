import 'dart:async';
import 'package:flutter/foundation.dart';
import '../services/supabase_service.dart';
import '../services/storage_service.dart';

/// Manages the global prayer counter (Tab 2).
/// Uses real-time subscriptions to sync across all devices.
class CounterProvider extends ChangeNotifier {
  final SupabaseService _supabase;
  final StorageService _storage;
  StreamSubscription<int>? _subscription;

  int _todayCount = 0;
  bool _hasPrayedToday = false;

  CounterProvider({
    required SupabaseService supabase,
    required StorageService storage,
  })  : _supabase = supabase,
        _storage = storage {
    _initHasPrayed();
    _startListening();
  }

  int get todayCount => _todayCount;
  bool get hasPrayedToday => _hasPrayedToday;

  void _initHasPrayed() {
    final lastDateStr = _storage.getLastTemplePrayerDate();
    if (lastDateStr != null) {
      final lastDate = DateTime.tryParse(lastDateStr);
      if (lastDate != null) {
        final now = DateTime.now();
        if (lastDate.year == now.year &&
            lastDate.month == now.month &&
            lastDate.day == now.day) {
          _hasPrayedToday = true;
        }
      }
    }
  }

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
    if (_hasPrayedToday) return;

    _hasPrayedToday = true;
    await _storage.setLastTemplePrayerDate(DateTime.now().toIso8601String());
    
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
