import 'package:flutter/material.dart';
import '../config/theme.dart';

/// Displays the Beit HaMikdash (Holy Temple) illustration
/// with elegant framing on Tab 2.
class TempleIllustration extends StatelessWidget {
  const TempleIllustration({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 240,
        width: 240,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: AppColors.isBlueTheme ? null : Border.all(
            color: AppColors.primary.withAlpha(200),
            width: 4,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(15),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: ClipOval(
          child: Image.asset(
            AppColors.isBlueTheme
                ? 'assets/images/beit_hamikdash_blue.png'
                : 'assets/images/beit_hamikdash_gold.png',
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              // Fallback if image not yet generated
              return Container(
                decoration: BoxDecoration(
                  color: AppColors.surfaceDim,
                  shape: BoxShape.circle,
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
                      const SizedBox(height: 8),
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
      ),
    );
  }
}
