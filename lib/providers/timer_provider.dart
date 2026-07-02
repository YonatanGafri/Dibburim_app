import 'dart:async';
import 'package:flutter/foundation.dart';
import '../config/constants.dart';
import '../data/prompts.dart';

/// Manages the countdown timer state for prayer sessions.
class TimerProvider extends ChangeNotifier {
  int _selectedDurationMinutes = AppConstants.defaultDurationMinutes;
  int _remainingSeconds = AppConstants.defaultDurationMinutes * 60;
  bool _isActive = false;
  bool _isCompleted = false;
  bool _isOvertime = false;
  bool _isPaused = false;
  int _overtimeSeconds = 0;
  int _currentPromptIndex = 0;

  Timer? _timer;
  DateTime? _startTime;
  DateTime? _pauseTime;
  int _totalSessionSeconds = 0;

  // ─── Getters ───
  int get selectedDurationMinutes => _selectedDurationMinutes;
  int get remainingSeconds => _remainingSeconds;
  bool get isActive => _isActive;
  bool get isCompleted => _isCompleted;
  bool get isOvertime => _isOvertime;
  bool get isPaused => _isPaused;
  int get overtimeSeconds => _overtimeSeconds;
  int get currentPromptIndex => _currentPromptIndex;

  String get displayTime {
    if (_isOvertime) {
      final m = (_overtimeSeconds ~/ 60).toString().padLeft(2, '0');
      final s = (_overtimeSeconds % 60).toString().padLeft(2, '0');
      return '+$m:$s';
    }
    final minutes = (_remainingSeconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (_remainingSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  double get progress {
    if (_isOvertime) return 1.0; // Full circle during overtime
    if (_totalSessionSeconds == 0) return 1.0;
    return _remainingSeconds / _totalSessionSeconds;
  }

  /// The actual total time the user spent (original + overtime)
  int get totalActualSeconds => _totalSessionSeconds + _overtimeSeconds;

  /// Get the current prompt to display (if any exist).
  InspirationPrompt? get currentPrompt {
    if (inspirationPrompts.isEmpty) return null;
    return inspirationPrompts[_currentPromptIndex % inspirationPrompts.length];
  }

  // ─── Actions ───

  /// Set the desired session duration.
  void setDuration(int minutes) {
    if (_isActive) return; // Can't change during active session
    _selectedDurationMinutes = minutes;
    _remainingSeconds = minutes * 60;
    _totalSessionSeconds = _remainingSeconds;
    notifyListeners();
  }

  /// Start the countdown timer.
  void start() {
    if (_isActive) return;
    _isActive = true;
    _isCompleted = false;
    _isOvertime = false;
    _isPaused = false;
    _overtimeSeconds = 0;
    _totalSessionSeconds = _selectedDurationMinutes * 60;
    _remainingSeconds = _totalSessionSeconds;
    _startTime = DateTime.now();
    _pauseTime = null;
    _currentPromptIndex = 0;

    _timer = Timer.periodic(const Duration(seconds: 1), _tick);
    notifyListeners();
  }

  /// Internal tick handler — runs every second.
  void _tick(Timer timer) {
    if (_startTime != null) {
      final elapsed = DateTime.now().difference(_startTime!).inSeconds;
      
      if (elapsed >= _totalSessionSeconds) {
        // We are in overtime
        if (!_isOvertime) {
          _isOvertime = true;
          _remainingSeconds = 0;
        }
        _overtimeSeconds = elapsed - _totalSessionSeconds;
      } else {
        _remainingSeconds = _totalSessionSeconds - elapsed;
      }

      // Rotate prompt every N seconds
      if (inspirationPrompts.isNotEmpty) {
        _currentPromptIndex =
            elapsed ~/ AppConstants.promptRotationIntervalSeconds;
      }
    }
    notifyListeners();
  }

  void pause() {
    if (!_isActive || _isPaused) return;
    _isPaused = true;
    _timer?.cancel();
    _pauseTime = DateTime.now();
    notifyListeners();
  }

  void resume() {
    if (!_isActive || !_isPaused) return;
    _isPaused = false;
    if (_pauseTime != null && _startTime != null) {
      final pausedDuration = DateTime.now().difference(_pauseTime!);
      _startTime = _startTime!.add(pausedDuration);
      _pauseTime = null;
    }
    _timer = Timer.periodic(const Duration(seconds: 1), _tick);
    notifyListeners();
  }

  /// Manually stop the timer and trigger completion (especially from overtime).
  void stopAndComplete() {
    _complete();
  }

  /// Mark the session as completed.
  void _complete() {
    _timer?.cancel();
    _timer = null;
    _isActive = false;
    _isCompleted = true;
    notifyListeners();
  }

  /// Cancel/stop the timer without completing.
  void cancel() {
    _timer?.cancel();
    _timer = null;
    _isActive = false;
    _isCompleted = false;
    _isOvertime = false;
    _isPaused = false;
    _pauseTime = null;
    _overtimeSeconds = 0;
    _remainingSeconds = _selectedDurationMinutes * 60;
    _totalSessionSeconds = _remainingSeconds;
    _startTime = null;
    notifyListeners();
  }

  /// Reset the completed state (after dismissing the completion dialog).
  void resetCompletion() {
    _isCompleted = false;
    _isOvertime = false;
    _isPaused = false;
    _pauseTime = null;
    _overtimeSeconds = 0;
    _remainingSeconds = _selectedDurationMinutes * 60;
    _totalSessionSeconds = _remainingSeconds;
    notifyListeners();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
