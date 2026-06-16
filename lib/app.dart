import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'config/theme.dart';
import 'data/strings.dart';
import 'providers/timer_provider.dart';
import 'providers/session_provider.dart';
import 'providers/counter_provider.dart';
import 'services/audio_service.dart';
import 'screens/home_screen.dart';
import 'screens/together_screen.dart';
import 'screens/journey_screen.dart';
import 'screens/inspiration_screen.dart';
import 'widgets/active_session_overlay.dart';

/// Root application widget with bottom navigation and session overlay.
class DiburimApp extends StatelessWidget {
  const DiburimApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'דיבורים',
      debugShowCheckedModeBanner: false,
      theme: buildAppTheme(),
      // Force RTL directionality for Hebrew
      builder: (context, child) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: child!,
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
    InspirationScreen(),
  ];

  @override
  void dispose() {
    _audioService.dispose();
    super.dispose();
  }

  void _onSessionComplete() {
    final timerProvider = context.read<TimerProvider>();
    final sessionProvider = context.read<SessionProvider>();
    final counterProvider = context.read<CounterProvider>();

    // Record the completed session
    sessionProvider.recordSession(timerProvider.selectedDurationMinutes);
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
                icon: const Icon(Icons.self_improvement_rounded),
                label: AppStrings.neutral('tab1'),
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.people_rounded),
                label: AppStrings.neutral('tab2'),
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.insights_rounded),
                label: AppStrings.neutral('tab3'),
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.auto_stories_rounded),
                label: AppStrings.neutral('tab4'),
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
