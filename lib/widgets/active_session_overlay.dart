import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../config/theme.dart';
import '../providers/timer_provider.dart';
import '../providers/settings_provider.dart';
import '../services/audio_service.dart';
import 'circular_timer.dart';
import 'completion_dialog.dart';

/// Full-screen overlay that covers the entire app (including bottom nav)
/// during an active meditation session.
class ActiveSessionOverlay extends StatefulWidget {
  final AudioService audioService;
  final VoidCallback onSessionComplete;
  final VoidCallback onCancel;

  const ActiveSessionOverlay({
    super.key,
    required this.audioService,
    required this.onSessionComplete,
    required this.onCancel,
  });

  @override
  State<ActiveSessionOverlay> createState() => _ActiveSessionOverlayState();
}

class _ActiveSessionOverlayState extends State<ActiveSessionOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  bool _showCompletion = false;
  bool _hasPlayedOvertimeChime = false;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    );
    _fadeController.forward();

    // Start ambient audio
    widget.audioService.playAmbient();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    widget.audioService.stopAmbient();
    super.dispose();
  }

  void _handleCompletion() {
    setState(() => _showCompletion = true);
  }

  void _handleDismiss() {
    context.read<TimerProvider>().stopAndComplete();
    widget.onSessionComplete();
    setState(() => _showCompletion = false);
  }

  @override
  Widget build(BuildContext context) {
    final timerProvider = context.watch<TimerProvider>();
    final settingsProvider = context.watch<SettingsProvider>();
    final isFemale = settingsProvider.isFemale;

    // Trigger overtime chime when overtime starts
    if (timerProvider.isOvertime && !_hasPlayedOvertimeChime) {
      _hasPlayedOvertimeChime = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        widget.audioService.stopAmbient();
        widget.audioService.playChime();
      });
    }

    return FadeTransition(
      opacity: _fadeAnimation,
      child: Material(
        color: AppColors.background,
        child: SafeArea(
          child: Stack(
            children: [
              // Subtle gradient background
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      AppColors.background,
                      AppColors.surfaceDim.withAlpha(120),
                      AppColors.background,
                    ],
                  ),
                ),
              ),

              // Main session content
              Column(
                children: [
                  // Top bar with mute button
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Cancel button (subtle)
                        IconButton(
                          onPressed: () {
                            widget.audioService.stopAmbient();
                            widget.onCancel();
                          },
                          icon: Icon(
                            Icons.close_rounded,
                            color: AppColors.textSecondary.withAlpha(120),
                            size: 28,
                          ),
                        ),
                        // Mute/unmute button
                        IconButton(
                          onPressed: () {
                            widget.audioService.toggleMute();
                            setState(() {});
                          },
                          icon: Icon(
                            widget.audioService.isMuted
                                ? Icons.volume_off_rounded
                                : Icons.volume_up_rounded,
                            color: AppColors.primary,
                            size: 28,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Center content
                  const Spacer(flex: 3),

                  // Regular Circular Timer (Always shown)
                  CircularTimer(
                    displayTime: timerProvider.displayTime,
                    progress: timerProvider.progress,
                    isActive: true,
                    size: 280,
                  ),

                  const Spacer(flex: 2),

                  // "Done" button during overtime
                  if (timerProvider.isOvertime)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: ElevatedButton(
                        onPressed: () {
                          // Show the Ashrecha dialog
                          _handleCompletion();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: const Text(
                          'סיימתי',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  const Spacer(flex: 1),
                ],
              ),

              // Completion dialog overlay
              if (_showCompletion) 
                CompletionDialog(
                  onDismiss: _handleDismiss,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
