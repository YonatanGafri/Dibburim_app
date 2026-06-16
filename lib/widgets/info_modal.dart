import 'package:flutter/material.dart';
import '../config/theme.dart';
import '../data/strings.dart';

/// Info modal with a biblical verse and explanation about
/// the connection between personal prayer and building the Temple.
class InfoModal extends StatelessWidget {
  const InfoModal({super.key});

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const InfoModal(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.secondary.withAlpha(30),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.divider,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 24),

          // Temple icon
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surfaceDim,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.auto_awesome,
              color: AppColors.primary,
              size: 32,
            ),
          ),
          const SizedBox(height: 20),

          // Biblical verse
          Text(
            AppStrings.neutral('infoModalVerse'),
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontStyle: FontStyle.italic,
                  color: AppColors.primary,
                  height: 1.8,
                ),
          ),
          const SizedBox(height: 20),

          // Divider
          Container(
            width: 60,
            height: 1,
            color: AppColors.divider,
          ),
          const SizedBox(height: 20),

          // Explanation
          Text(
            AppStrings.neutral('infoModalExplanation'),
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppColors.textSecondary,
                  height: 1.8,
                ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
