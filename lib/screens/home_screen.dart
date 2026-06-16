import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../config/theme.dart';
import '../data/strings.dart';
import '../providers/timer_provider.dart';
import '../providers/settings_provider.dart';
import '../widgets/circular_timer.dart';
import '../widgets/duration_toggle.dart';
import '../widgets/settings_panel.dart';

/// Tab 1: ההתבודדות שלי (My Hitbodedut) — Home Screen
/// The central, minimalist interface with timer and start button.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final timerProvider = context.watch<TimerProvider>();
    final settingsProvider = context.watch<SettingsProvider>();

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            // Top bar with settings gear
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(width: 40), // Balance for RTL
                  Text(
                    AppStrings.neutral('tab1'),
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                  ),
                  IconButton(
                    onPressed: () => SettingsPanel.show(context),
                    icon: const Icon(
                      Icons.settings_rounded,
                      color: AppColors.secondary,
                      size: 24,
                    ),
                  ),
                ],
              ),
            ),

            // Timer section
            const Spacer(flex: 2),

            // Circular countdown timer
            CircularTimer(
              displayTime: timerProvider.displayTime,
              progress: timerProvider.progress,
              isActive: false,
              size: 260,
            ),

            const SizedBox(height: 36),

            // Duration toggles
            const DurationToggle(),

            const SizedBox(height: 36),

            // Start button
            SizedBox(
              width: 220,
              height: 56,
              child: ElevatedButton(
                onPressed: () {
                  timerProvider.start();
                },
                style: ElevatedButton.styleFrom(
                  elevation: 4,
                  shadowColor: AppColors.primary.withAlpha(60),
                ),
                child: Text(
                  AppStrings.get('startButton',
                      isFemale: settingsProvider.isFemale),
                  style: const TextStyle(fontSize: 18),
                ),
              ),
            ),

            const Spacer(flex: 3),
          ],
        ),
      ),
    );
  }
}
