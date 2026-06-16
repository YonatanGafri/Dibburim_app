import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../config/theme.dart';
import '../data/prompts.dart' as prompts_data;
import '../providers/timer_provider.dart';
import '../providers/settings_provider.dart';
import '../services/audio_service.dart';
import 'circular_timer.dart';
import 'inspiration_prompt.dart';
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
    widget.audioService.stopAmbient();
    widget.audioService.playChime();
    setState(() => _showCompletion = true);
  }

  void _handleDismiss() {
    widget.onSessionComplete();
    setState(() => _showCompletion = false);
  }

  @override
  Widget build(BuildContext context) {
    final timerProvider = context.watch<TimerProvider>();
    final settingsProvider = context.watch<SettingsProvider>();

    // Trigger completion when timer finishes
    if (timerProvider.isCompleted && !_showCompletion) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _handleCompletion();
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
              if (!_showCompletion)
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

                    // Timer in center
                    const Spacer(flex: 2),
                    CircularTimer(
                      displayTime: timerProvider.displayTime,
                      progress: timerProvider.progress,
                      isActive: true,
                      size: 280,
                    ),
                    const SizedBox(height: 40),

                    // Rotating inspiration prompt
                    InspirationPromptWidget(
                      prompt: timerProvider.currentPrompt,
                      isFemale: settingsProvider.isFemale,
                    ),
                    const Spacer(flex: 3),
                  ],
                ),

              // Completion dialog overlay
              if (_showCompletion)
                CompletionDialog(onDismiss: _handleDismiss),
            ],
          ),
        ),
      ),
    );
  }
}
