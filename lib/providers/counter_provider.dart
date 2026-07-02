import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/supabase_service.dart';

/// Manages the global prayer counter (Tab 2).
/// Uses real-time subscriptions to sync across all devices.
class CounterProvider extends ChangeNotifier {
  final SupabaseService _supabase;
  StreamSubscription<int>? _subscription;
  StreamSubscription<AuthState>? _authSubscription;

  int _todayCount = 0;
  bool _hasPrayedToday = false;

  CounterProvider({
    required SupabaseService supabase,
  })  : _supabase = supabase {
    _initHasPrayed();
    _startListening();
    
    _authSubscription = Supabase.instance.client.auth.onAuthStateChange.listen((data) {
      _initHasPrayed();
    });
  }

  int get todayCount => _todayCount;
  bool get hasPrayedToday => _hasPrayedToday;

  void _initHasPrayed() {
    _hasPrayedToday = false;
    final user = Supabase.instance.client.auth.currentUser;
    if (user != null) {
      final lastDateStr = user.userMetadata?['last_temple_prayer_date'] as String?;
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
    notifyListeners();
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
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null || _hasPrayedToday) return;

    _hasPrayedToday = true;
    
    // Optimistic UI update
    _todayCount++;
    notifyListeners();
    
    // Remote update
    try {
      await Supabase.instance.client.auth.updateUser(
        UserAttributes(data: {'last_temple_prayer_date': DateTime.now().toIso8601String()}),
      );
      await _supabase.incrementDailyCounter();
    } catch (e) {
      debugPrint('Error updating prayer: $e');
    }
  }
  
  @override
  void dispose() {
    _subscription?.cancel();
    _authSubscription?.cancel();
    super.dispose();
  }
}
