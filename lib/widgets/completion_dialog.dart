import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../config/theme.dart';
import '../data/strings.dart';
import '../providers/timer_provider.dart';

/// Warm, loving dialog displayed when a session completes.
class CompletionDialog extends StatelessWidget {
  final VoidCallback onDismiss;

  const CompletionDialog({super.key, required this.onDismiss});

  @override
  Widget build(BuildContext context) {
    final isFemale =
        false; // Will be overridden by parent passing settings context

    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 32),
        padding: const EdgeInsets.all(36),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withAlpha(25),
              blurRadius: 30,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Warm golden icon
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: AppColors.primary.withAlpha(20),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.favorite_rounded,
                color: AppColors.primary,
                size: 36,
              ),
            ),
            const SizedBox(height: 24),
            // Completion message
            Text(
              AppStrings.get('completionMessage', isFemale: isFemale),
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    height: 2.0,
                    fontSize: 17,
                  ),
            ),
            const SizedBox(height: 28),
            // Dismiss button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onDismiss,
                child: Text(AppStrings.neutral('finish')),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
