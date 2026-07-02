import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../config/theme.dart';
import '../data/strings.dart';
import '../providers/counter_provider.dart';
import '../widgets/temple_illustration.dart';
import '../widgets/info_modal.dart';
import '../services/auth_service.dart';
import 'auth_screen.dart';

/// Tab 2: יחד (Together) — Community & Holy Temple Screen
/// Shows the Temple illustration, global prayer counter, and info modal.
class TogetherScreen extends StatelessWidget {
  const TogetherScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final counterProvider = context.watch<CounterProvider>();
    final authService = context.watch<AuthService>();

    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset(
            'assets/images/bg_sky.png',
            fit: BoxFit.cover,
          ),
        ),
        Positioned.fill(
          child: Container(
            color: AppColors.background.withAlpha(180),
          ),
        ),
        SafeArea(
          child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          children: [
            const SizedBox(height: 10),
            // Title
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                AppStrings.neutral('togetherTitle'),
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            const SizedBox(height: 16),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                AppStrings.neutral('templeSubtitle'),
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 20),

            // Temple illustration
            const TempleIllustration(),
            const SizedBox(height: 20),

            // The Counter
            Center(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.secondary.withAlpha(20),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Text(
                      '${counterProvider.todayCount}',
                      style: TextStyle(
                        fontSize: 52,
                        fontWeight: FontWeight.w300,
                        color: AppColors.primary,
                      ),
                    ),
                    Text(
                      'תפילות היום',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),

            // The Prayer
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                AppStrings.neutral('templePrayer'),
                style: TextStyle(
                  fontSize: 18,
                  color: AppColors.primary,
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 30),

            // The Action Button
            ElevatedButton(
              onPressed: counterProvider.hasPrayedToday
                  ? null
                  : () {
                      if (!authService.isLoggedIn) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('יש להתחבר לחשבון כדי להשתתף בתפילה על בית המקדש.'),
                          ),
                        );
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const AuthScreen()),
                        );
                        return;
                      }

                      counterProvider.increment();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('זכינו! התפילה שלך נוספה.'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: counterProvider.hasPrayedToday
                    ? Colors.grey.shade400
                    : AppColors.primary,
                foregroundColor: Colors.white,
                disabledBackgroundColor: Colors.grey.shade400,
                disabledForegroundColor: Colors.white,
              ),
              child: Text(
                counterProvider.hasPrayedToday
                    ? AppStrings.neutral('togetherPrayedSuccess')
                    : AppStrings.neutral('templeButton'),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 40),

            // Info (?) Card
            Center(
              child: Card(
                elevation: 0,
                color: AppColors.surfaceDim.withAlpha(150),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: InkWell(
                  onTap: () => InfoModal.show(context),
                  borderRadius: BorderRadius.circular(16),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppColors.primary,
                              width: 1.5,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              '?',
                              style: TextStyle(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'מה המשמעות?',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
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
            const SizedBox(height: 20),
          ],
        ),
      ),
      ), // SafeArea
      ],
    );
  }
}
