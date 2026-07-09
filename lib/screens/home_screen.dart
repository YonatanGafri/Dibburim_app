import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../config/theme.dart';
import '../data/strings.dart';
import '../providers/timer_provider.dart';
import '../providers/settings_provider.dart';
import '../widgets/circular_timer.dart';
import '../widgets/duration_toggle.dart';
import '../widgets/settings_panel.dart';
import '../widgets/tips_modal.dart';
import '../services/auth_service.dart';
import 'auth_screen.dart';
import 'profile_screen.dart';

/// Tab 1: ההתבודדות שלי (My Hitbodedut) — Home Screen
/// The central, minimalist interface with timer and start button.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey profileButtonKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _checkFirstTimeAndShowTutorial();
  }

  Future<void> _checkFirstTimeAndShowTutorial() async {
    final prefs = await SharedPreferences.getInstance();
    final hasSeenTutorial = prefs.getBool('has_seen_profile_tutorial') ?? false;

    if (!hasSeenTutorial) {
      // Show tutorial after a short delay to let the UI build
      Future.delayed(const Duration(seconds: 1), () {
        if (!mounted) return;

        final authService = context.read<AuthService>();
        if (authService.isLoggedIn) return; // Don't show if already logged in

        TutorialCoachMark(
          targets: [
            TargetFocus(
              identify: 'profile-button',
              keyTarget: profileButtonKey,
              alignSkip: Alignment.bottomRight,
              contents: [
                TargetContent(
                  align: ContentAlign.bottom,
                  builder: (context, controller) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Text(
                          'כדי שהנתונים והמעקב יישמרו לך ותוכל לעקוב אחרי הדיבורים שלך, יש להירשם כאן.',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                          textDirection: TextDirection.rtl,
                        ),
                      ],
                    );
                  },
                ),
              ],
              shape: ShapeLightFocus.Circle,
            ),
          ],
          colorShadow: Colors.black,
          textSkip: 'הבנתי',
          textStyleSkip:
              const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          paddingFocus: 10,
          opacityShadow: 0.8,
          onFinish: () {
            prefs.setBool('has_seen_profile_tutorial', true);
          },
          onSkip: () {
            prefs.setBool('has_seen_profile_tutorial', true);
            return true;
          },
        ).show(context: context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final timerProvider = context.watch<TimerProvider>();
    final settingsProvider = context.watch<SettingsProvider>();
    final authService = context.watch<AuthService>();

    return SizedBox.expand(
      child: Stack(
        children: [
        // Background image
        Positioned.fill(
          child: Image.asset(
            'assets/images/bg_sky.png',
            fit: BoxFit.cover,
          ),
        ),
        // Soft overlay to maintain contrast
        Positioned.fill(
          child: Container(
            color: AppColors.background.withAlpha(180),
          ),
        ),
        // Main content
        SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight,
                  ),
                  child: IntrinsicHeight(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: [
                // Top bar with Logo, settings gear, and tab title
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Logo + Tab Title
                      SizedBox(
                        width: double.infinity,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const SizedBox(
                                    width:
                                        34), // Balances the 8px spacer + 26px heart on the other side
                                Text(
                                  'דיבורים',
                                  style: TextStyle(
                                    fontSize: 38,
                                    fontWeight: FontWeight.w900,
                                    color: AppColors.textSecondary,
                                    letterSpacing: -0.5,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Icon(
                                  Icons.favorite_rounded,
                                  color: AppColors.textSecondary,
                                  size: 26,
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'זמן להירגע, לשתף ולהתחבר',
                              style: TextStyle(
                                fontSize: 16,
                                color: AppColors.textSecondary.withAlpha(180),
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              AppStrings.neutral('tab1'),
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    color: AppColors.textSecondary,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 22,
                                  ),
                            ),
                          ],
                        ),
                      ),
                      // Left-aligned settings button
                      Positioned(
                        left: 0,
                        top: 0,
                        child: IconButton(
                          onPressed: () => SettingsPanel.show(context),
                          icon: Icon(
                            Icons.settings_rounded,
                            color: AppColors.secondary,
                            size: 24,
                          ),
                        ),
                      ),
                      // Right-aligned profile button
                      Positioned(
                        right: 0,
                        top: 0,
                        child: IconButton(
                          key: profileButtonKey,
                          onPressed: () {
                            if (authService.isLoggedIn) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => const ProfileScreen()));
                            } else {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => const AuthScreen()));
                            }
                          },
                          icon: Icon(
                            authService.isLoggedIn
                                ? Icons.person_rounded
                                : Icons.person_outline_rounded,
                            color: AppColors.secondary,
                            size: 26,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Timer section
                const Spacer(flex: 3),

                // Circular countdown timer
                CircularTimer(
                  displayTime: timerProvider.displayTime,
                  progress: timerProvider.progress,
                  isActive: false,
                  size: 240,
                ),

                const SizedBox(height: 20),

                // Duration toggles
                const DurationToggle(),

                const SizedBox(height: 20),

                // Start button
                SizedBox(
                  width: 220,
                  child: ElevatedButton(
                    onPressed: () {
                      timerProvider.start();
                    },
                    child: Text(
                      AppStrings.get('startButton',
                          isFemale: settingsProvider.isFemale),
                    ),
                  ),
                ),

                const Spacer(flex: 2),

                // Tips Card
                Center(
                  child: Card(
                    elevation: 0,
                    color: AppColors.surfaceDim.withAlpha(150),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: InkWell(
                      onTap: () => TipsModal.show(context),
                      borderRadius: BorderRadius.circular(16),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 12),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.lightbulb_outline_rounded,
                                color: AppColors.primary, size: 22),
                            const SizedBox(width: 8),
                            Text(
                              'טיפים ועצות',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    color: AppColors.primaryDark,
                                    fontWeight: FontWeight.w500,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Rabbi Nachman Quote
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    '"ההתבודדות היא מעלה עליונה וגדולה מן הכל"\n(רבי נחמן מברסלב)',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.textSecondary.withAlpha(150),
                          fontSize: 15,
                          height: 1.5,
                          fontStyle: FontStyle.italic,
                        ),
                  ),
                ),

                const Spacer(flex: 2),
                      ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        ],
      ),
    );
  }
}
