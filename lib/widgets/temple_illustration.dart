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
        height: 250,
        width: 250,
        padding: const EdgeInsets.all(8), // Our new, thick modern frame!
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.primary, // The color of the thick frame
          boxShadow: [
            // Glowing aura around the thick frame
            BoxShadow(
              color: AppColors.primary.withAlpha(220), // Brighter gold aura
              blurRadius: 35,
              spreadRadius: 4,
              offset: Offset.zero,
            ),
            // Standard shadow to pop out from background
            BoxShadow(
              color: Colors.black.withAlpha(20),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipOval(
          child: Transform.scale(
            scale: 1.1, // Zoom in by 10% to completely hide the original thin frame!
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
          ), // Closes Transform.scale
        ), // Closes ClipOval
      ),
    );
  }
}
