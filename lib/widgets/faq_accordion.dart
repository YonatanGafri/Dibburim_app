import 'package:flutter/material.dart';
import '../config/theme.dart';
import '../data/faq_data.dart';
import '../data/strings.dart';

/// Expandable FAQ accordion list for Tab 4.
/// Shows an empty state when no entries exist.
class FaqAccordion extends StatelessWidget {
  const FaqAccordion({super.key});

  @override
  Widget build(BuildContext context) {
    if (faqEntries.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        child: Text(
          '', // No FAQ entries yet — hide section entirely
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.secondary.withAlpha(15),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
              child: Text(
                AppStrings.neutral('faqTitle'),
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            ...faqEntries.map(
              (entry) => Theme(
                data: Theme.of(context).copyWith(
                  dividerColor: Colors.transparent,
                ),
                child: ExpansionTile(
                  tilePadding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                  childrenPadding:
                      const EdgeInsets.fromLTRB(20, 0, 20, 16),
                  expandedCrossAxisAlignment: CrossAxisAlignment.start,
                  iconColor: AppColors.primary,
                  collapsedIconColor: AppColors.secondary,
                  title: Text(
                    entry.question,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                  children: [
                    Divider(color: AppColors.divider, height: 1),
                    const SizedBox(height: 12),
                    Text(
                      entry.answer,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            height: 1.7,
                          ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
