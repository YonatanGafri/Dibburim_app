import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/strings.dart';
import '../providers/session_provider.dart';
import '../providers/settings_provider.dart';
import '../widgets/calendar_view.dart';
import '../services/auth_service.dart';
import 'auth_screen.dart';
import '../widgets/stats_card.dart';

/// Tab 3: הדרך שלי (My Journey) — Analytics & Consistency
/// Monthly calendar, streak, and statistics display.
class JourneyScreen extends StatelessWidget {
  const JourneyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final sessionProvider = context.watch<SessionProvider>();
    final settingsProvider = context.watch<SettingsProvider>();
    final isFemale = settingsProvider.isFemale;

    final streak = sessionProvider.currentStreak;
    final monthlyCount = sessionProvider.monthlyCount;
    final yearlyMinutes = sessionProvider.yearlyMinutes;

    final authService = context.watch<AuthService>();
    final isLoggedIn = authService.isLoggedIn;

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          children: [
            // Title
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                AppStrings.neutral('journeyTitle'),
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            const SizedBox(height: 24),

            // Calendar
            CalendarView(sessions: sessionProvider.sessions),
            const SizedBox(height: 24),

            if (!isLoggedIn)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Card(
                  color: Theme.of(context).primaryColorLight,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        const Text(
                          'כדי לשמור את זמני ההתבודדות שלך ולעקוב אחריהם בלוח השנה לאורך זמן - יש להירשם לחשבון (בחינם)',
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 12),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const AuthScreen()),
                            );
                          },
                          child: const Text('הרשמה / התחברות'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            if (!isLoggedIn) const SizedBox(height: 24),

            // Stats cards
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  // Current streak
                  StatsCard(
                    icon: Icons.local_fire_department_rounded,
                    label: AppStrings.get('streakMessage', isFemale: isFemale),
                    value: '$streak',
                    suffix: AppStrings.neutral('daysInRow'),
                  ),
                  const SizedBox(height: 12),

                  // Monthly count
                  StatsCard(
                    icon: Icons.calendar_month_rounded,
                    label: AppStrings.get('monthlyMessage', isFemale: isFemale),
                    value: '$monthlyCount',
                    suffix: AppStrings.neutral('timesThisMonth'),
                  ),
                  const SizedBox(height: 12),

                  // Yearly minutes
                  StatsCard(
                    icon: Icons.timer_rounded,
                    label: AppStrings.get('yearlyMessage', isFemale: isFemale),
                    value: '$yearlyMinutes',
                    suffix: AppStrings.neutral('minutesThisYear'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
