import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'config/theme.dart';
import 'data/strings.dart';
import 'providers/timer_provider.dart';
import 'providers/session_provider.dart';
import 'providers/counter_provider.dart';
import 'providers/settings_provider.dart';
import 'services/audio_service.dart';
import 'screens/home_screen.dart';
import 'screens/together_screen.dart';
import 'screens/journey_screen.dart';
import 'widgets/active_session_overlay.dart';
import 'package:in_app_update/in_app_update.dart';
/// Root application widget with bottom navigation and session overlay.
class DiburimApp extends StatelessWidget {
  const DiburimApp({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();
    AppColors.isBlueTheme = settings.isBlueTheme;
    AppStrings.currentLanguage = settings.language;

    return MaterialApp(
      key: ValueKey('${settings.isBlueTheme}_${settings.language}'), // Force full app rebuild when theme or language changes
      title: 'דיבורים',
      debugShowCheckedModeBanner: false,
      scrollBehavior: const MaterialScrollBehavior().copyWith(
        physics: const ClampingScrollPhysics(),
      ),
      theme: buildAppTheme(),
      // Set directionality based on language
      builder: (context, child) {
        final textScaler = MediaQuery.textScalerOf(context);
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaler: textScaler.clamp(minScaleFactor: 1.0, maxScaleFactor: 1.3),
          ),
          child: Directionality(
            textDirection: settings.language == 'en' ? TextDirection.ltr : TextDirection.rtl,
            child: child!,
          ),
        );
      },
      home: const _AppShell(),
    );
  }
}

class _AppShell extends StatefulWidget {
  const _AppShell();

  @override
  State<_AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<_AppShell> {
  int _currentIndex = 0;
  final AudioService _audioService = AudioService();

  final List<Widget> _screens = const [
    HomeScreen(),
    TogetherScreen(),
    JourneyScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _checkForUpdates();
  }

  Future<void> _checkForUpdates() async {
    try {
      final updateInfo = await InAppUpdate.checkForUpdate();
      if (updateInfo.updateAvailability == UpdateAvailability.updateAvailable) {
        if (updateInfo.flexibleUpdateAllowed) {
          final result = await InAppUpdate.startFlexibleUpdate();
          if (result == AppUpdateResult.success) {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('עדכון חדש הורד בהצלחה. לחץ להתקנה.', textDirection: TextDirection.rtl),
                  duration: const Duration(days: 1), // Stay until user installs
                  action: SnackBarAction(
                    label: 'התקן כעת',
                    onPressed: () {
                      InAppUpdate.completeFlexibleUpdate();
                    },
                  ),
                ),
              );
            }
          }
        } else if (updateInfo.immediateUpdateAllowed) {
          await InAppUpdate.performImmediateUpdate();
        }
      }
    } catch (e) {
      debugPrint('In-App Update error: $e');
    }
  }

  @override
  void dispose() {
    _audioService.dispose();
    super.dispose();
  }

  void _onSessionComplete() {
    final timerProvider = context.read<TimerProvider>();
    final sessionProvider = context.read<SessionProvider>();
    final counterProvider = context.read<CounterProvider>();

    // Record the completed session (rounding up to nearest minute for overtime)
    final actualMinutes = (timerProvider.totalActualSeconds / 60).round();
    sessionProvider.recordSession(actualMinutes);
    counterProvider.increment();
    timerProvider.resetCompletion();
  }

  void _onSessionCancel() {
    context.read<TimerProvider>().cancel();
  }

  @override
  Widget build(BuildContext context) {
    final timerProvider = context.watch<TimerProvider>();
    final isSessionActive = timerProvider.isActive || timerProvider.isCompleted;

    return Stack(
      children: [
        // Main scaffold with bottom nav
        Scaffold(
          body: IndexedStack(
            index: _currentIndex,
            children: _screens,
          ),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (index) => setState(() => _currentIndex = index),
            items: [
              BottomNavigationBarItem(
                icon: const Icon(Icons.person_outline_rounded),
                activeIcon: const Icon(Icons.person_rounded),
                label: AppStrings.neutral('tab1'),
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.people_outline_rounded),
                activeIcon: const Icon(Icons.people_rounded),
                label: AppStrings.neutral('tab2'),
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.insights_rounded), // Insights outline doesn't look much different, but we can stick to rounded
                activeIcon: const Icon(Icons.insights_rounded),
                label: AppStrings.neutral('tab3'),
              ),
            ],
          ),
        ),

        // Full-screen session overlay (covers everything including nav bar)
        if (isSessionActive)
          ActiveSessionOverlay(
            audioService: _audioService,
            onSessionComplete: _onSessionComplete,
            onCancel: _onSessionCancel,
          ),
      ],
    );
  }
}
