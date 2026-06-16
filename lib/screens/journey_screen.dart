import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/strings.dart';
import '../providers/session_provider.dart';
import '../providers/settings_provider.dart';
import '../widgets/calendar_view.dart';
import '../widgets/stats_card.dart';

/// Tab 3: הדרך שלי (My Journey) — Analytics & Consistency
/// Monthly calendar, streak, and statistics display.
class JourneyScreen extends StatefulWidget {
  const JourneyScreen({super.key});

  @override
  State<JourneyScreen> createState() => _JourneyScreenState();
}

class _JourneyScreenState extends State<JourneyScreen> {
  late int _viewYear;
  late int _viewMonth;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _viewYear = now.year;
    _viewMonth = now.month;
  }

  @override
  Widget build(BuildContext context) {
    final sessionProvider = context.watch<SessionProvider>();
    final settingsProvider = context.watch<SettingsProvider>();
    final isFemale = settingsProvider.isFemale;

    final completedDates =
        sessionProvider.getCompletedDates(_viewYear, _viewMonth);
    final streak = sessionProvider.currentStreak;
    final monthlyCount = sessionProvider.monthlyCount;
    final yearlyMinutes = sessionProvider.yearlyMinutes;

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
            CalendarView(completedDates: completedDates),
            const SizedBox(height: 24),

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
