import 'package:flutter/material.dart';
import '../config/theme.dart';

/// Displays the Beit HaMikdash (Holy Temple) illustration
/// with elegant framing on Tab 2.
class TempleIllustration extends StatelessWidget {
  const TempleIllustration({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surfaceDim.withAlpha(100),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: AppColors.divider,
          width: 1,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Image.asset(
          'assets/images/beit_hamikdash.png',
          height: 200,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
            // Fallback if image not yet generated
            return Container(
              height: 200,
              decoration: BoxDecoration(
                color: AppColors.surfaceDim,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.account_balance_rounded,
                      size: 64,
                      color: AppColors.primary.withAlpha(120),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'בית המקדש',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.primary,
                          ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
